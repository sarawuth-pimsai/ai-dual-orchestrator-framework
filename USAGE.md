# Starting sessions

First identify the adopting project, its repository, board, decision records and permissions. Copy the bootstrap template into that project, recording unknowns explicitly. Read the shared instructions, governance, relevant role and protocols before acting. Confirm live issues, PRs, baseline and approvals; if the project or source of truth is missing, request that essential detail.

Business, Requirements, Implementation and PM use `templates/STATUS_REPORT.md` as a shared format for reporting to Founder. Answer simple questions directly and use the full format when the task needs it. The template is included in bootstrapped projects under `.ai-framework/framework/templates/STATUS_REPORT.md`.

## ChatGPT — Business or PM

Open a separate session for each role. Provide access to the framework and the adopting project's canonical records, or supply current copies with dates and limitations. Instruct the session to follow `AGENTS.md`, `GOVERNANCE.md`, the relevant file in `roles/` and protocols. Use the start prompt in that role. Verify connector capabilities and project access; without them, label evidence unverified and arrange a human relay.

## Claude Code — Requirements and Implementation

Open a separate session for each role. Provide this framework to each session and explicitly direct it to read `AGENTS.md`, `GOVERNANCE.md`, its own role file (`roles/REQUIREMENTS.md` or `roles/IMPLEMENTATION.md`) and `protocols/TECH_EXECUTION.md`. The Requirements session owns the product contract, risk-tier proposals and the e2e scripts, and coordinates with Business; open it on the repository that holds the documents. The Implementation session owns the code, unit and integration tests and technical proposals; open it on the code repository. Founder retains product, tier, technical-choice and implementation approval. Verify actual repository permissions and Founder implementation authorization before changes. If a session may not write in a repository, it reports acknowledgments and evidence to the Founder, who relays them. Do not assume another session has received an issue or comment. Whether one session may hold both roles is a Founder decision for the adopting project.

## Codex — bounded work

Open the adopting project's workspace in VS Code or Codex, make the framework instructions available, identify the assigned role and point to its canonical records. Explicitly request the authorized bounded task and have Codex follow `AGENTS.md` and relevant role and protocol files. Codex is a tool or session acting within the assigned ownership; its use does not transfer orchestration authority or automatically invoke Claude or GPT.

## Handoffs and decisions

Use `templates/HANDOFF.md` in the adopting project, relay it to a real receiver, and record explicit acknowledgment (in the record, or relayed by the Founder when the receiver may not write there) before reporting receipt. Open every pull request with the headings of `templates/PULL_REQUEST_TEMPLATE.md`; with `gh pr create --body`, copy the headings into the body. Record decisions using `templates/DECISION_RECORD.md`; distinguish recommendations from Founder approval. These documents install no runtime, scheduler or integrations.
