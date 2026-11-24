# Technical Delivery Workflow (Adapted SDLC)

This is a reusable adaptation of ideas such as tier triage, dependency graph, parallel lanes and staged QA. It does not copy another project's ownership rules verbatim. It is run by the Requirements role and the Implementation role (together, the "Tech side"), each in its own session.

1. **Intake (Requirements):** Maintain the canonical product contract, feature ID and acceptance criteria, incorporate Business input and record open decisions. Verify Founder approval of the contract and relevant security/privacy and integration assumptions before relying on it as approved.
2. **Risk tier:** Requirements proposes a tier (T1 low, T2 moderate, T3 high) with reasons; the Founder approves it. Tier determines design/test intensity, never overrides Founder approval. T3 includes security review; auth, payments, personal data, money movement and high-risk reliability need explicit risk analysis.
3. **Technical design (Implementation):** T1 short design note; T2/T3 solution document, ADRs and testability/recovery considerations. Implementation proposes technical choices (libraries, internal architecture, ADRs) and the Founder approves them. The original architecture rules live in the code repository; the documents repository holds only a pointer pinned by commit and blob SHA and the record of the Founder's approval, no second copy. Route business-rule changes to Requirements for coordination with Business and Founder approval where required.
4. **Task decomposition (Implementation):** Cross-check scope; decompose into atomic tasks with acceptance/done criteria, Depends on/Blocks, expected changed files, ownership and evidence. Build a DAG and identify the critical path. Acceptance criteria come from Requirements and are not rewritten here. Task issues, their comment markers and the split into sub-issues follow `protocols/TASK_ISSUE_PROTOCOL.md`.
5. **Parallel lanes:** Group independent tasks by domain; do not assign overlapping write ownership to simultaneous workers. Extract shared utilities/contracts first and make lanes depend on them.
6. **Implementation gate:** Require explicit Founder approval before changing application code, deploying, or spending. Use feature branches and reviewable PRs; keep changes within approved scope.
7. **Code-level checks (Implementation):** Write and run unit tests and integration tests for the change and report commands, results, commit and date. Do not merge when tests or acceptance fail. These tests replace the independent code review that earlier versions of this step required. **This removes an independent gate: the author's tests check the author's own understanding, not an outside reader's. The Founder accepted this.** The security checklist is not removed or weakened: the Implementation role applies it to its change in proportion to the approved tier, records the result in the PR, and T3 work still requires the security review of step 2 before it can be READY TO MERGE. Who may perform a T3 security review is not decided here; it is recorded per adopting project and, if not recorded, is an OPEN Founder decision.
8. **Business-level and user-level checks (QA):**
   - Business writes the scenarios of user behavior and the business rules that must not break, and judges whether results match what the business needs.
   - Requirements writes AND runs the automated e2e scripts against the environment the Founder names, and reports pass or fail with environment, commit and date.
   - Implementation writes the unit and integration tests (step 7).
   - **Phase 0:** draft scenarios, scripts and test data in parallel with design. **Phase A:** per-task checks in a development or integration environment. **Phase B:** e2e, regression, security and recovery checks in the Founder-named staging environment. **Phase C:** post-release smoke only after release approval.
9. **Release gate:** Verified build, QA sign-off, rollback plan, critical defects resolved and explicit Founder Go/No-Go. Do not infer production authorization from a passing CI pipeline.
10. **Hotfix:** Define urgent triage and expedited approvals in each adopting project; emergency paths must not silently bypass security, audit trail or Founder authority.

**Optional deeper measurements.** Branch coverage, mutation testing and similar measurements are optional commands that the Founder orders when wanted. They are not a standing rule for the Implementation role; when ordered, report the command, tool, result and commit.

## Evidence and references

Link exact issue, PR, commit, test run, environment and date. Pin every reference to another document or code by commit (and blob SHA for a single file). Feature and QA work issues live in the code repository; decisions and requirements stay in the documents repository. Record NOT VERIFIED when inaccessible.

## PR readiness

Keep a PR in GitHub Draft while it cannot be merged: work or acceptance is incomplete, required checks (unit, integration, e2e, security checklist) have not passed, dependencies or blockers remain, required approval is missing, or readiness cannot be verified. Move it to Ready for review only after every applicable merge requirement and approval has been verified and no blocker remains; report it as **READY TO MERGE** with evidence. GitHub's Ready for review state alone does not establish merge readiness, and readiness does not itself authorize or perform a merge.

Every pull request in every repository uses the description headings in `templates/PULL_REQUEST_TEMPLATE.md`. GitHub fills a template only in the browser, so a session that opens a PR with `gh pr create --body` must copy the headings into the body.

Verify the actual GitHub state before reporting it. If the PR state conflicts with readiness, change it only when authorized and access permits; otherwise report the actual state, the mismatch, the responsible owner and the next action. Never claim a Draft/Ready change or merge without evidence. If a formerly ready PR becomes blocked, return it to Draft when authorized and possible.

If a required check cannot run while the PR is Draft, report this as a blocker and request a decision on the applicable workflow; do not declare it merge-ready or silently waive the requirement.
