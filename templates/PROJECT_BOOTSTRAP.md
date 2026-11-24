# Project Bootstrap

Project name: <name>
Documents repository (decisions and requirements): <owner/repo>
Code repository (work issues, code, architecture rules): <owner/repo>
Design assets and prototypes (approved logo files, UI prototypes, other design files): <owner/repo or path / NONE>
Project board: <URL or NONE>
Founder: <role/identifier>
Business Orchestrator runtime: <ChatGPT / other / not connected>
Requirements role runtime: <Claude Code / other / not connected>
Implementation role runtime: <Claude Code / other / not connected>
May the Implementation role write in the documents repository: <yes / no (acknowledge via Founder relay)>
Product Owner: Requirements role / <assigned role or actual receiver>
PM runtime: <ChatGPT / Codex / other / on demand>
Canonical decisions index: <path>
Canonical requirements/features: <path>
Architecture rules pointer (code repository path @ commit, blob SHA) and Founder approval record: <link / NOT APPROVED>
Environment the Founder names for e2e tests: <name / NOT NAMED>
Approved roadmap baseline: <date / not approved>
Requested target: <date / NONE>
Jurisdiction / privacy constraints: <details>
Authorized implementation scope: <link / NOT APPROVED>
Authorized deployment scope: <link / NOT APPROVED>
Review cadence: <on demand / configured schedule>

## Bootstrap checks
- [ ] GitHub access verified separately for each runtime
- [ ] Decision authority recorded
- [ ] Existing work items inventoried before creating any new ones
- [ ] Cross-model handoff receiver acknowledgment mechanism tested (record channel and, where a role may not write, Founder relay)
- [ ] No unapproved implementation or release assumed
