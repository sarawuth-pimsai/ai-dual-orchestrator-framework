import contextlib
import hashlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest import mock
import zipfile

from ai_framework import __main__ as cli

class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'project'
        self.commit = 'a' * 40

    def archive(self, text='one'):
        out = io.BytesIO()
        with zipfile.ZipFile(out, 'w') as z:
            for doc in cli.DOCS:
                z.writestr('framework/' + doc, f'{doc}: {text}\n')
        path = Path(self.temp.name) / (text + '.zip')
        path.write_bytes(out.getvalue())
        return path, hashlib.sha256(out.getvalue()).hexdigest()

    def args(self, action='init', text='one', commit=None):
        path, sha = self.archive(text)
        return type('Args', (), dict(project=str(self.root), action=action, commit=commit or self.commit, sha256=sha, archive=str(path)))()

    def test_init_idempotent_and_preserves_other_files(self):
        self.root.mkdir()
        (self.root / 'decision.md').write_text('private decision')
        args = self.args()
        cli.run(args)
        first = (self.root / cli.CONFIG).read_bytes()
        cli.run(args)
        self.assertEqual(first, (self.root / cli.CONFIG).read_bytes())
        self.assertEqual((self.root / 'decision.md').read_text(), 'private decision')
        self.assertEqual(json.loads(first)['commit'], self.commit)

    def test_conflict_is_untouched(self):
        self.root.mkdir()
        (self.root / 'AGENTS.md').write_text('existing')
        with self.assertRaises(cli.BootstrapError): cli.run(self.args())
        self.assertEqual((self.root / 'AGENTS.md').read_text(), 'existing')
        self.assertFalse((self.root / 'CLAUDE.md').exists())

    def test_wrong_integrity_never_writes(self):
        args = self.args()
        args.sha256 = '0' * 64
        with self.assertRaises(cli.BootstrapError): cli.run(args)
        self.assertFalse(self.root.exists())

    def test_update_preview_cancel_confirm_and_rollback_to_prior_pin(self):
        old = self.args()
        cli.run(old)
        before = (self.root / cli.VERSION).read_bytes()
        new = self.args('update', 'two', 'b' * 40)
        with mock.patch('builtins.input', return_value='no'), contextlib.redirect_stdout(io.StringIO()) as out:
            cli.run(new)
        self.assertIn('proposed/', out.getvalue())
        self.assertEqual((self.root / cli.VERSION).read_bytes(), before)
        with mock.patch('builtins.input', return_value='yes'), contextlib.redirect_stdout(io.StringIO()): cli.run(new)
        self.assertEqual((self.root / cli.VERSION).read_text().strip(), 'b' * 40)
        old.action = 'update'
        with mock.patch('builtins.input', return_value='yes'), contextlib.redirect_stdout(io.StringIO()): cli.run(old)
        self.assertEqual((self.root / cli.VERSION).read_bytes(), before)

    def test_update_rejects_modified_file(self):
        cli.run(self.args())
        p = self.root / 'AGENTS.md'
        p.write_text('my instructions')
        with self.assertRaises(cli.BootstrapError): cli.run(self.args('update', 'two', 'b' * 40))
        self.assertEqual(p.read_text(), 'my instructions')

    def test_incompatible_schema_rejected(self):
        cli.run(self.args())
        p = self.root / cli.CONFIG
        cfg = json.loads(p.read_text()); cfg['schema'] = 99; p.write_text(json.dumps(cfg))
        with self.assertRaises(cli.BootstrapError): cli.run(self.args('update', 'two', 'b' * 40))

    def test_partial_failure_restores_files(self):
        cli.run(self.args())
        before = cli.current(self.root, cli.render(self.commit, self.args().sha256, cli.fetch(self.commit, self.args().sha256, self.args().archive)))
        args = self.args('update', 'two', 'b' * 40)
        real = cli.os.replace
        count = 0
        def fail_once(src, dst):
            nonlocal count
            count += 1
            if count == 3: raise OSError('simulated failure')
            return real(src, dst)
        with mock.patch('builtins.input', return_value='yes'), mock.patch.object(cli.os, 'replace', side_effect=fail_once), contextlib.redirect_stdout(io.StringIO()):
            with self.assertRaises(OSError): cli.run(args)
        self.assertEqual(cli.current(self.root, before), before)

    def test_symlink_conflict(self):
        self.root.mkdir()
        (self.root / '.ai-framework').symlink_to(Path(self.temp.name), target_is_directory=True)
        with self.assertRaises(cli.BootstrapError): cli.run(self.args())

if __name__ == '__main__': unittest.main()
