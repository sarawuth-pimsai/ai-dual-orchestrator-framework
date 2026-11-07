# Starting sessions

First identify the adopting project, its repository, board, decision records and permissions. Copy the bootstrap template into that project, recording unknowns explicitly. Read the shared instructions, governance, relevant role and protocols before acting. Confirm live issues, PRs, baseline and approvals; if the project or source of truth is missing, request that essential detail.

## ChatGPT — Business or PM

Open a separate session for each role. Provide access to the framework and the adopting project's canonical records, or supply current copies with dates and limitations. Instruct the session to follow `AGENTS.md`, `GOVERNANCE.md`, the relevant file in `roles/` and protocols. Use the start prompt in that role. Verify connector capabilities and project access; without them, label evidence unverified and arrange a human relay.

## Claude Code — Tech

Open the adopting project in Claude Code. Provide this framework to the session and explicitly direct it to read `AGENTS.md`, `GOVERNANCE.md`, `roles/TECH_ORCHESTRATOR.md` and `protocols/TECH_EXECUTION.md`. Verify actual repository permissions and Founder implementation authorization before changes. Do not assume another session has received an issue or comment.

## Codex — bounded work

Open the adopting project's workspace in VS Code or Codex, make the framework instructions available, identify the assigned role and point to its canonical records. Explicitly request the authorized bounded task and have Codex follow `AGENTS.md` and relevant role and protocol files. Codex is a tool or session acting within the assigned ownership; its use does not transfer orchestration authority or automatically invoke Claude or GPT.

## Handoffs and decisions

Use `templates/HANDOFF.md` in the adopting project, relay it to a real receiver, and record explicit acknowledgment before reporting receipt. Record decisions using `templates/DECISION_RECORD.md`; distinguish recommendations from Founder approval. These documents install no runtime, scheduler or integrations.
