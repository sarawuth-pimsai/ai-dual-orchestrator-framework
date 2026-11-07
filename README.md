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
