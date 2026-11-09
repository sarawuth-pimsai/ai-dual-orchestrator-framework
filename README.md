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

1. Download a trusted CLI from a [release](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/releases) and install the framework into the **adopting project**, not this framework repository. See the [Thai guide](GUIDE.th.md#2-ติดตั้งในโปรเจกต์ใหม่) for complete commands.
2. Copy `.ai-framework/framework/templates/PROJECT_BOOTSTRAP.md` to a project-owned location and record the canonical repository, board, decision records and access. Keep project-specific context outside managed framework files.
3. Open Claude Code in the project and start the Tech role using `.ai-framework/framework/roles/TECH_ORCHESTRATOR.md`. Give PO your requirements; implementation requires explicit Founder authorization.
4. Open a separate GPT Business session when needed. Relay handoffs and require real receiver acknowledgment. Use a separate PM session if integrated tracking is needed.
5. Review evidence, approvals and PR readiness; approve release separately. See [Starting sessions](USAGE.md) and the [Thai guide](GUIDE.th.md) for prompts and examples.

## Bootstrap CLI

The shell CLI installs project entry points and a fixed subset of the framework documents without a submodule, Python, or a framework clone inside the project. It needs Bash, `unzip`, `curl` for downloads, `sha256sum` or `shasum`, and standard Unix utilities. macOS and Linux are supported when these tools are present; native Windows requires a compatible Unix environment. Obtain `bin/ai-framework` from a trusted copy of this repository and run `chmod +x ai-framework`. It is a local tool, not an agent runtime. See [LICENSE](LICENSE) for usage terms.

Run `ai-framework --version` (or `ai-framework version`) to show the CLI version without network access. If the executable is named `ai`, use `ai --version`. This reports the CLI version, not the framework commit installed in a project; inspect `.ai-framework/VERSION` in the project for that commit. Published CLI v1.2.0 and earlier do not support this command.

CLI v1.5.0 provides `ai --help`, `ai update`, `ai init project [DIR]` and `ai project update [DIR]`. Omit `DIR` to use the current directory. `ai update` updates only the installed CLI, after confirmation; project updates preview a diff and require their own confirmation. The `ai framework update` name is not supported in CLI v1.4.0 or newer. CLI v1.4.0 and earlier do not support `ai update` or automatic release checksums; see the [Thai guide](GUIDE.th.md) for version-specific instructions.

For a release tag, CLI v1.5.0 downloads the GitHub release's `SHA256SUMS` and matching ZIP over HTTPS and verifies the ZIP before making changes. This removes the per-release trust-file setup. The checksum and archive come from the same source: this verifies integrity, not independent authenticity. Review the release and use an independently obtained `--sha256` if stronger source verification is needed. With `--commit`, a 40-character commit, `--sha256` and optionally `--archive` provide a pinned, offline-capable route. The archive digest alone does not prove an arbitrary local ZIP corresponds to the named commit.

```sh
ai update
ai init project
ai project update
ai init project . --commit FULL_40_CHAR_COMMIT --sha256 TRUSTED_64_CHAR_SHA256 --archive /path/to/framework.zip
```

`ai update` stages the replacement in the CLI's directory, verifies its checksum, asks for confirmation, and replaces the executable by rename. It refuses symlinked executables, checks that the original did not change after preview, and does not touch projects. If the CLI is installed through a package manager, use that manager instead. A copy of the original or an independently verified release asset should be retained if manual rollback is needed; abrupt interruption or filesystem failure can still require recovery. Git, curl and network access are required when resolving a project release. The older v1.4.0 CLI still requires the separately configured trust file for short commands.

`init` refuses existing managed paths and is safe to repeat with identical files. Move or reconcile existing instructions yourself before initialization; the tool never silently overwrites them. Update checks configuration compatibility and managed file hashes, shows a diff, and requires the operator to type `yes`. Local edits to managed files block updates and must be reconciled first. To restore an earlier version, run `project update` with its previous commit and trusted archive digest, review the diff and confirm. Keep the older archive if GitHub serves different ZIP bytes later. Save a project backup or use version control before updating: normal write errors trigger rollback, but an interruption or machine failure may require manual recovery.

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
- `RELEASING.md`: this repository's release procedure and Founder delegation.
- `examples/`: example handoff and fictional workflow dry-run.

## Integration boundaries

This framework is compatible with ChatGPT, Claude Code and Codex as **instructions**. It does not automatically transfer conversations between providers, spawn agents, connect GitHub Projects, or run unattended. Verify permissions and runtime capabilities before claiming any operation.

## License

This repository uses the [Business Source License 1.1](LICENSE), with the same terms as the SDLC Playbook. The license permits free internal production and operation, and restricts commercial managed services and embedding and sublicensing in commercial proprietary products sold to third parties. The license specifies July 17, 2029 as the Change Date. Consult the full license for its terms and conditions; for commercial licensing, contact Sarawuth Pimsai through [GitHub Issues](https://github.com/sarawuth-pimsai/ai-dual-orchestrator-framework/issues).
