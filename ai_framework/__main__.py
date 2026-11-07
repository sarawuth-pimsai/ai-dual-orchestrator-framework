import argparse
import difflib
import hashlib
import io
import json
import os
from pathlib import Path
import re
import sys
import tempfile
import urllib.request
import zipfile

DOCS = ('AGENTS.md', 'GOVERNANCE.md', 'USAGE.md', 'roles/BUSINESS_ORCHESTRATOR.md',
        'roles/TECH_ORCHESTRATOR.md', 'roles/PM_AGENT.md', 'roles/SPECIALISTS.md',
        'protocols/HANDOFF_PROTOCOL.md', 'protocols/TECH_EXECUTION.md', 'protocols/PM_TRACKING.md',
        'templates/PROJECT_BOOTSTRAP.md', 'templates/DECISION_RECORD.md', 'templates/HANDOFF.md',
        'templates/TASK_CONTRACT.md', 'templates/STATUS_REPORT.md', 'templates/RISK_REGISTER.md')
CONFIG = '.ai-framework/config.yaml'
VERSION = '.ai-framework/VERSION'
SCHEMA = 1
MAX_ARCHIVE = 20 * 1024 * 1024
MAX_DOC = 1024 * 1024

class BootstrapError(Exception):
    pass

def digest(data):
    return hashlib.sha256(data).hexdigest()

def check_pin(commit, sha):
    if not re.fullmatch(r'[0-9a-f]{40}', commit or ''):
        raise BootstrapError('commit must be a full lowercase 40-character Git SHA')
    if not re.fullmatch(r'[0-9a-f]{64}', sha or ''):
        raise BootstrapError('archive SHA-256 must be 64 lowercase hexadecimal characters')

def fetch(commit, expected, archive=None):
    check_pin(commit, expected)
    if archive:
        data = Path(archive).read_bytes()
    else:
        url = f'https://api.github.com/repos/sarawuth-pimsai/ai-dual-orchestrator-framework/zipball/{commit}'
        headers = {'Accept': 'application/vnd.github+json', 'User-Agent': 'ai-framework-bootstrap'}
        token = os.environ.get('GITHUB_TOKEN')
        if token:
            headers['Authorization'] = 'Bearer ' + token
        with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=30) as response:
            data = response.read(MAX_ARCHIVE + 1)
    if len(data) > MAX_ARCHIVE or digest(data) != expected:
        raise BootstrapError('archive too large or SHA-256 mismatch; no files changed')
    try:
        with zipfile.ZipFile(io.BytesIO(data)) as z:
            names = z.namelist()
            found = {}
            for doc in DOCS:
                matches = [n for n in names if n.endswith('/' + doc) and n.count('/') == doc.count('/') + 1]
                if len(matches) != 1:
                    raise BootstrapError(f'archive missing or duplicates {doc}')
                info = z.getinfo(matches[0])
                if info.file_size > MAX_DOC:
                    raise BootstrapError(f'document too large: {doc}')
                found[doc] = z.read(info)
                found[doc].decode('utf-8')
            return found
    except (zipfile.BadZipFile, UnicodeDecodeError) as exc:
        raise BootstrapError(f'invalid framework archive: {exc}') from exc

def path_at(root, name):
    p = root
    for part in Path(name).parts:
        p = p / part
        if p.is_symlink():
            raise BootstrapError(f'symlink in managed path: {name}')
    return p

def render(commit, archive_sha, docs):
    intro = ('# AI Framework project instructions\n\n'
             'Read `.ai-framework/framework/AGENTS.md`, `GOVERNANCE.md` and the relevant role and protocol files under `.ai-framework/framework/` before acting. '
             'Identify this project’s canonical repository, board and approved decisions. Project context and decisions belong in this project.\n\n'
             'Business GPT and Tech Claude are peers; PM supports both. Founder retains final approval. '
             'A handoff requires actual receiver acknowledgment. Do not infer agent execution from a GitHub comment.\n')
    result = {'AGENTS.md': intro.encode(), 'CLAUDE.md': (intro + '\nFor Tech, read `.ai-framework/framework/roles/TECH_ORCHESTRATOR.md`.\n').encode(),
              VERSION: (commit + '\n').encode()}
    result.update({'.ai-framework/framework/' + k: v for k, v in docs.items()})
    cfg = {'schema': SCHEMA, 'repository': 'sarawuth-pimsai/ai-dual-orchestrator-framework', 'commit': commit,
           'archive_sha256': archive_sha, 'managed_sha256': {k: digest(v) for k, v in result.items()}}
    # JSON is a strict subset of YAML 1.2, avoiding a parser dependency.
    result[CONFIG] = (json.dumps(cfg, indent=2, sort_keys=True) + '\n').encode()
    return result

def load_config(root):
    try:
        cfg = json.loads(path_at(root, CONFIG).read_text())
        if cfg['schema'] != SCHEMA or cfg['repository'] != 'sarawuth-pimsai/ai-dual-orchestrator-framework':
            raise BootstrapError('incompatible configuration schema or repository')
        check_pin(cfg['commit'], cfg['archive_sha256'])
        allowed = {'AGENTS.md', 'CLAUDE.md', VERSION} | {'.ai-framework/framework/' + d for d in DOCS}
        if set(cfg['managed_sha256']) != allowed:
            raise BootstrapError('incompatible managed file list')
        if any(not re.fullmatch(r'[0-9a-f]{64}', x) for x in cfg['managed_sha256'].values()):
            raise BootstrapError('invalid managed file hash')
        return cfg
    except (OSError, ValueError, KeyError, TypeError) as exc:
        raise BootstrapError(f'cannot read compatible config: {exc}') from exc

def current(root, paths):
    out = {}
    for name in paths:
        p = path_at(root, name)
        if p.exists():
            if not p.is_file():
                raise BootstrapError(f'not a regular file: {name}')
            out[name] = p.read_bytes()
    return out

def transact(root, before, after):
    # Check for intervening changes immediately before writing.
    if current(root, set(before) | set(after)) != before:
        raise BootstrapError('files changed since preview; retry')
    applied = []
    try:
        for name, data in after.items():
            p = path_at(root, name)
            p.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(dir=p.parent, delete=False) as f:
                temp = Path(f.name)
                try:
                    f.write(data)
                    f.flush()
                    os.fsync(f.fileno())
                except BaseException:
                    temp.unlink(missing_ok=True)
                    raise
            try:
                os.replace(temp, p)
            finally:
                temp.unlink(missing_ok=True)
            applied.append(name)
    except BaseException:
        for name in reversed(applied):
            p = path_at(root, name)
            if name in before:
                p.write_bytes(before[name])
            else:
                p.unlink(missing_ok=True)
        raise

def preview(before, after):
    for name in sorted(after):
        if before.get(name) == after[name]:
            continue
        print(f'--- {name} ---')
        old = before.get(name, b'').decode('utf-8').splitlines(keepends=True)
        new = after[name].decode('utf-8').splitlines(keepends=True)
        print(''.join(difflib.unified_diff(old, new, fromfile='current/' + name, tofile='proposed/' + name)), end='')

def run(args):
    root = Path(args.project).absolute()
    if root.is_symlink() or (root.exists() and not root.is_dir()):
        raise BootstrapError('project must be a non-symlink directory')
    docs = fetch(args.commit, args.sha256, args.archive)
    after = render(args.commit, args.sha256, docs)
    before = current(root, after)
    if args.action == 'init':
        if before:
            if before == after:
                print('Already initialized with identical files; no changes.')
                return
            raise BootstrapError('existing managed paths conflict; no files changed: ' + ', '.join(sorted(before)))
    else:
        cfg = load_config(root)
        for name, expected in cfg['managed_sha256'].items():
            if name not in before or digest(before[name]) != expected:
                raise BootstrapError(f'managed file missing or modified: {name}; preserve and reconcile it before updating')
        # Re-read config and VERSION as part of the pre-write snapshot.
        before = current(root, after)
        if before == after:
            print('Already at requested version; no changes.')
            return
        preview(before, after)
        if input('Apply these changes? Type yes: ').strip() != 'yes':
            print('Cancelled; no files changed.')
            return
    transact(root, before, after)
    print(f'{args.action} complete: {args.commit}')

def main():
    parser = argparse.ArgumentParser(prog='ai-framework')
    sub = parser.add_subparsers(dest='group', required=True)
    init = sub.add_parser('init').add_subparsers(dest='action', required=True).add_parser('project')
    update = sub.add_parser('framework').add_subparsers(dest='action', required=True).add_parser('update')
    for p in (init, update):
        p.add_argument('project', help='new or existing workspace directory')
        p.add_argument('--commit', required=True, help='full immutable Git commit SHA')
        p.add_argument('--sha256', required=True, help='trusted SHA-256 of the exact ZIP archive')
        p.add_argument('--archive', help='local ZIP archive instead of downloading')
    args = parser.parse_args()
    args.action = 'init' if args.group == 'init' else 'update'
    try:
        run(args)
    except (BootstrapError, OSError, EOFError, KeyboardInterrupt, zipfile.BadZipFile) as exc:
        print(f'Error: {exc}', file=sys.stderr)
        return 1
    return 0

if __name__ == '__main__':
    sys.exit(main())
