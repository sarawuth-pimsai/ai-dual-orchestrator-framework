# Founder communication template

Use this shared format for Business (GPT), Tech/PO (Claude), and PM when reporting work or requesting a decision. Respond in the Founder's preferred language. Keep ordinary answers concise; for a simple question, answer directly without filling every field. Include the fields needed for the task and use NONE or NOT VERIFIED where material instead of inventing information. Adapt presentation to the request without changing ownership or approval authority.

## Standard response

**Role / project:** <Business | Tech/PO | PM; project name and source, or UNKNOWN>

**Outcome / current state:** <direct answer or current work state; distinguish PROPOSED, APPROVED, SUPERSEDED and OPEN when relevant>

**Completed and evidence:** <actions actually completed, with file paths, links, dates, or NONE; distinguish evidence from plans and simulations>

**Acceptance and approval:** <acceptance evidence and actual result; identify any separate Founder approval gate and its state, or NOT APPLICABLE>

**Dependencies / blockers:** <what is needed, responsible owner and unblock condition; NONE if none>

**Next action / owner:** <concrete next step and accountable role; indicate if waiting for an actual receiver acknowledgment>

**Handoff to send (when applicable):**
- Sender → receiver: <role → role>
- State: <NOT SENT | POSTED / AWAITING RECEIVER | ACKNOWLEDGED | IN EXECUTION | EVIDENCE RECEIVED | VERIFIED | BLOCKED>
- Copy-ready prompt: <self-contained request with project/source, context, deliverable, acceptance criteria, dependencies, approval gate and next owner; include the link to the full handoff when available>

**PRs requiring action (when applicable):**
- PR: <link, change and owner>
- Review / checks / blockers: <actual states and evidence, or NOT VERIFIED>
- GitHub state / merge readiness: <DRAFT or READY FOR REVIEW; BLOCKED or READY TO MERGE based on verified criteria; note any mismatch>
- Next action / owner: <review, resolve, merge or other action; do not imply a merge or approval occurred>
- Approval gate: <required decision and actual state, or NONE>

**Founder action:** <specific decision or authorization needed, with options and consequences when useful; NONE if none>

## Optional details

For milestones or status, include the as-of time and timezone, approved baseline and commitment, requested target, current forecast, critical path and assumptions when known. Distinguish project state, issue or board state, and approval evidence. Report unknown estimates as UNVERIFIED.

For a handoff, use `templates/HANDOFF.md` for the full contract and report its actual state using `protocols/HANDOFF_PROTOCOL.md`. A posted message or issue is not receiver acknowledgment. Do not claim another role, agent or test ran without evidence.

For PRs, follow `protocols/TECH_EXECUTION.md`: keep non-mergeable or unverified PRs in Draft; use Ready for review and report READY TO MERGE only after all applicable requirements and approvals are verified. State the actual GitHub status and any mismatch or access limitation.

For a proposed Founder decision, state the recommendation, meaningful alternatives and impact; do not imply approval or stop independently authorized work while a decision is pending.
