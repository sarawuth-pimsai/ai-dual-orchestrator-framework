# AI Dual-Orchestrator Framework

A reusable, project-agnostic governance and delivery framework for a Founder, GPT Business Orchestrator, Claude Tech Orchestrator, and a cross-functional PM support role.

**Status:** Initial reusable framework template; no agent runtime, scheduler, external integrations or autonomous execution is installed by these files.

## Topology

Founder (approves strategic, product, commercial, implementation and release decisions)

- Business Orchestrator (GPT): Product, UX/UI, Marketing, Finance, Accounting & Tax, Legal & Compliance.
- Tech Orchestrator (Claude): Architecture/SA, Tech Lead function, Development, QA and Security.
- PM Agent: reconciles both plans, monitors critical path, dependencies, risks and verified progress. PM is not a third orchestrator and cannot approve or dispatch cross-domain specialists.

Both orchestrators are peers, report to Founder and coordinate via one project's source of truth. The framework repo contains reusable policy only; each **adopting project** owns its own decisions, issues, artifacts and code. Do not place project-specific confidential information in this framework.

## Quick start

1. Make this framework available to each session. Keep it separate from each adopting project.
2. For each adopting project, copy `templates/PROJECT_BOOTSTRAP.md`, `templates/DECISION_RECORD.md`, `templates/TASK_CONTRACT.md`, `templates/HANDOFF.md`, `templates/STATUS_REPORT.md`, and `templates/RISK_REGISTER.md` as needed.
3. Set a single project source of truth and configure actual GitHub/IDE access for each role.
4. Open separate GPT Business, Claude Tech and PM sessions, using the prompts in `roles/`.
5. Start with discovery and evidence-based planning; implementation requires explicit Founder authorization.

## Bootstrap CLI

The shell CLI installs project entry points and a fixed subset of the framework documents without a submodule, Python, or a framework clone inside the project. It needs Bash, `unzip`, `curl` for downloads, `sha256sum` or `shasum`, and standard Unix utilities. macOS and Linux are supported when these tools are present; native Windows requires a compatible Unix environment. Obtain `bin/ai-framework` from a trusted copy of this repository and run `chmod +x ai-framework`. It is a local tool, not an agent runtime. The existing all-rights-reserved license applies.

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
- `examples/`: example handoff and fictional workflow dry-run.

## Integration boundaries

This framework is compatible with ChatGPT, Claude Code and Codex as **instructions**. It does not automatically transfer conversations between providers, spawn agents, connect GitHub Projects, or run unattended. Verify permissions and runtime capabilities before claiming any operation.
