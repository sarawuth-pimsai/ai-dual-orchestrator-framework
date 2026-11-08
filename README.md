# AI Dual-Orchestrator Framework

A reusable, project-agnostic governance and delivery framework for a Founder, GPT Business Orchestrator, Claude Tech Orchestrator, and a cross-functional PM support role.

**Status:** Initial reusable framework template; no agent runtime, scheduler, external integrations or autonomous execution is installed by these files.

**[คู่มือการใช้งานภาษาไทย](GUIDE.th.md)** · [Starting sessions](USAGE.md) · [Releases](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases) · [Governance](GOVERNANCE.md)

## How it works

1. Founder gives requirements directly to Tech/PO in Claude.
2. Tech/PO clarifies requirements and requests Business/GPT input when UX, legal, finance or other business expertise is needed.
3. Founder approves product decisions and the implementation scope. Tech coordinates authorized delivery, QA and evidence.
4. Business and Tech report using a shared template, including copy-ready handoffs and PR actions when relevant. Founder decides release.

Business and Tech are separate sessions. Unless an integration is actually configured, the Founder relays handoffs and the receiver must acknowledge them; an issue comment alone does not dispatch an agent.

## Topology

Founder (approves strategic, product, commercial, implementation and release decisions)

- Business Orchestrator (GPT): UX/UI, Marketing, Finance, Accounting & Tax, Legal & Compliance and business input to Product.
- Tech Orchestrator (Claude): Product Owner (PO), Architecture/SA, Tech Lead function, Development, QA and Security.
- PM Agent: reconciles both plans, monitors critical path, dependencies, risks and verified progress. PM is not a third orchestrator and cannot approve or dispatch cross-domain specialists.

Both orchestrators are peers, report to Founder and coordinate via one project's source of truth. The framework repo contains reusable policy only; each **adopting project** owns its own decisions, issues, artifacts and code. Do not place project-specific confidential information in this framework.

Tech PO receives requirements directly from Founder and maintains the canonical product requirements, feature IDs and acceptance criteria. When business specialist input is needed, PO hands off to Business for UX/UI, legal or other relevant work. Founder retains approval of product scope, business decisions, implementation and release; PO ownership does not delegate those approvals.

Business GPT, Tech/PO Claude and PM use the shared [Founder communication template](templates/STATUS_REPORT.md) for work reports and decisions; simple answers remain concise.

## Quick start

1. Download the CLI and exact ZIP for a [release](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases) and independently verify their checksums and commit. Install them into the **adopting project**, not this framework repository. See the [Thai guide](GUIDE.th.md#2-ติดตั้งในโปรเจกต์ใหม่) for complete commands.
2. Copy `.ai-framework/framework/templates/PROJECT_BOOTSTRAP.md` to a project-owned location and record the canonical repository, board, decision records and access. Keep project-specific context outside managed framework files.
3. Open Claude Code in the project and start the Tech role using `.ai-framework/framework/roles/TECH_ORCHESTRATOR.md`. Give PO your requirements; implementation requires explicit Founder authorization.
4. Open a separate GPT Business session when needed. Relay handoffs and require real receiver acknowledgment. Use a separate PM session if integrated tracking is needed.
5. Review evidence, approvals and PR readiness; approve release separately. See [Starting sessions](USAGE.md) and the [Thai guide](GUIDE.th.md) for prompts and examples.

## Bootstrap CLI

The shell CLI installs project entry points and a fixed subset of the framework documents without a submodule, Python, or a framework clone inside the project. It needs Bash, `unzip`, `curl` for downloads, `sha256sum` or `shasum`, and standard Unix utilities. macOS and Linux are supported when these tools are present; native Windows requires a compatible Unix environment. Obtain `bin/ai-framework` from a trusted copy of this repository and run `chmod +x ai-framework`. It is a local tool, not an agent runtime. See [LICENSE](LICENSE) for usage terms.

Obtain a full 40-character framework commit and the SHA-256 of the **exact ZIP archive** through a trusted channel. For a private GitHub repository set `GITHUB_TOKEN` to a token with repository read access; keep it out of shell history and project files. The CLI fetches the commit-specific GitHub ZIP over HTTPS, or use `--archive /path/to/framework.zip` for a previously downloaded archive. The supplied digest must match the exact ZIP bytes. Do not trust a checksum obtained solely from the same unverified source as the archive.

```sh
./ai-framework init project /path/to/project --commit FULL_40_CHAR_COMMIT --sha256 TRUSTED_64_CHAR_SHA256
./ai-framework framework update /path/to/project --commit NEW_40_CHAR_COMMIT --sha256 TRUSTED_64_CHAR_SHA256
```

Alternatively, use a release tag such as `--version v1.0.0` in place of `--commit`. This requires Git and network access to resolve the tag to a commit; the resolved commit is recorded in the project. Verify that the tag points to the intended commit through a trusted channel, and provide the trusted SHA-256 of that commit's exact ZIP. Tags can move, so a tag name alone is not an immutable pin. For example:

```sh
./ai-framework init project . --version v1.0.0 --sha256 TRUSTED_64_CHAR_SHA256
./ai-framework framework update . --version v1.1.0 --sha256 TRUSTED_64_CHAR_SHA256
```

If neither `--version` nor `--commit` is supplied, the CLI resolves GitHub's latest published release for this public repository, then resolves its tag to a commit. This requires `curl`, Git and network access even when `--archive` is supplied. For reproducibility or offline use, pin an independently verified `--commit` and use `--archive`.

```sh
./ai-framework init project . --sha256 TRUSTED_LATEST_ZIP_SHA256 --archive /path/to/latest-release.zip
./ai-framework framework update . --sha256 TRUSTED_LATEST_ZIP_SHA256 --archive /path/to/latest-release.zip
```

For shorter commands, install a trusted copy of the current CLI into a directory on `PATH`, and create `${XDG_CONFIG_HOME:-$HOME/.config}/ai-framework/trusted-releases`. Each line must contain a release tag, its full commit, and the SHA-256 of the exact `framework-TAG.zip` release asset, separated by spaces. Independently authenticate the commit and digest before recording them; do not treat a checksum from the same unverified source as independent authentication. See the [Thai guide](GUIDE.th.md) for a complete CLI download and setup example. Before the following example, check for an existing CLI because `cp` overwrites it; after verifying the values for `v1.1.0`:

```sh
mkdir -p "$HOME/.local/bin" "${XDG_CONFIG_HOME:-$HOME/.config}/ai-framework"
cp /path/to/trusted/ai-framework "$HOME/.local/bin/ai-framework"
chmod +x "$HOME/.local/bin/ai-framework"
export PATH="$HOME/.local/bin:$PATH"
```

Add the PATH setting to your shell configuration if needed. Use an editor to add the following line to the trust file, preserving existing entries and adding only one entry per release:

```text
v1.1.0 3685cb76c8c2c71679ab7b809702a8799ff379ab 7fccbeff9b3e11906b2083049334485b903fc002bc29bc224002d4e9fdcbab37
```

You can then run `ai-framework init project .` or `ai-framework framework update .`; the CLI checks the resolved tag against the recorded commit, downloads the named release ZIP and checks its digest. If a newer release has no trusted entry, the CLI stops without modifying the project until its commit and digest are independently verified and added. If specifying `--archive` without `--sha256`, it must match the trusted release asset bytes. You can use `AI_FRAMEWORK_TRUST_FILE` to choose a different trust file. Direct `--commit` use still requires `--sha256`.

The previously published `v1.1.0` CLI does not support the latest-release default or the trust file; these require the newer CLI.

`init` refuses existing managed paths and is safe to repeat with identical files. Move or reconcile existing instructions yourself before initialization; the tool never silently overwrites them. Update checks configuration compatibility and managed file hashes, shows a diff, and requires the operator to type `yes`. Local edits to managed files block updates and must be reconciled first. To restore an earlier version, run `framework update` with its previous commit and trusted archive digest, review the diff and confirm. Keep the older archive if GitHub serves different ZIP bytes later. Save a project backup or use version control before updating: normal write errors trigger rollback, but an interruption or machine failure may require manual recovery.

The generated `AGENTS.md` and `CLAUDE.md` point to `.ai-framework/framework/`; the project owns its own context, decisions and handoffs. `.ai-framework/config.yaml` records schema 2 and the pin, `.ai-framework/MANIFEST` tracks managed file hashes, and `.ai-framework/VERSION` records the commit. Commit these files as appropriate for the project. The archive digest verifies bytes against the independently supplied digest; it does not prove an arbitrary local ZIP corresponds to the stated Git commit. See `ARCHITECTURE_BOOTSTRAP.md` for security and recovery limitations.

Troubleshooting: a 404 or authentication error requires verified private-repository access; a SHA mismatch requires the original archive and independently trusted digest; an incompatible schema or modified managed file requires manual reconciliation. No file is intentionally overwritten to resolve these errors. Run `bash tests/test_shell.sh` from the framework source to validate the shell CLI (the tests also need `zip`). The previous Python CLI remains available but uses schema 1; the two implementations cannot update each other's projects. Migrate manually after backing up and reviewing existing files.

## Commands (natural language, not installed CLI commands)

- `business status` / `business continue`
- `tech status` / `tech plan` / `tech continue`
- `pm status` / `pm plan` / `pm risks` / `pm handoffs`

## Documents

- `AGENTS.md`: shared startup and safety rules.
- `GOVERNANCE.md`: authority and lifecycle.
- `roles/`: role instructions for GPT, Claude and PM.
- `roles/SPECIALISTS.md`: specialist ownership and boundaries.
- `protocols/`: technical execution, handoff and tracking protocols.
- `templates/`: reusable project documents.
- `USAGE.md`: session startup for ChatGPT, Claude Code and Codex.
- `GUIDE.th.md`: Thai installation, workflow, handoff, PR and update guide (read from this repository; not included in the bootstrap-managed document set).
- `examples/`: example handoff and fictional workflow dry-run.

## Integration boundaries

This framework is compatible with ChatGPT, Claude Code and Codex as **instructions**. It does not automatically transfer conversations between providers, spawn agents, connect GitHub Projects, or run unattended. Verify permissions and runtime capabilities before claiming any operation.

## License

This repository uses the [Business Source License 1.1](LICENSE), with the same terms as the SDLC Playbook. The license permits free internal production and operation, and restricts commercial managed services and embedding and sublicensing in commercial proprietary products sold to third parties. The license specifies July 17, 2029 as the Change Date. Consult the full license for its terms and conditions; for commercial licensing, contact Sarawuth Pimsai through [GitHub Issues](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/issues).
