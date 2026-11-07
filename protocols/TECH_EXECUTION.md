# Technical Delivery Workflow (Adapted SDLC)

This is a reusable adaptation of ideas such as tier triage, dependency graph, parallel lanes, independent PR review and staged QA. It does not copy another project's ownership rules verbatim.

1. **Intake:** Verify approved Product contract, feature ID, acceptance criteria, security/privacy and integration assumptions.
2. **SA triage:** SA assigns risk tier (T1 low, T2 moderate, T3 high) with reasons. Tier determines design/test intensity, never overrides Founder approval. T3 includes security review; auth, payments, personal data, money movement and high-risk reliability need explicit risk analysis.
3. **Architecture:** T1 short design note; T2/T3 solution document, ADRs and testability/recovery considerations. Route business-rule changes back to Business Orchestrator.
4. **Tech Lead function:** Cross-check scope; decompose into atomic tasks with acceptance/done criteria, Depends on/Blocks, expected changed files, ownership and evidence. Build DAG and identify critical path.
5. **Parallel lanes:** Group independent tasks by domain; do not assign overlapping write ownership to simultaneous workers. Extract shared utilities/contracts first and make lanes depend on them.
6. **Implementation gate:** Require explicit Founder approval before changing application code, deploying, or spending. Use feature branches and reviewable PRs; keep changes within approved scope.
7. **Independent review:** Reviewer uses task contract, diff, tests, security checklist and architecture, not merely the implementer's self-report. Do not merge when acceptance or checks fail.
8. **QA Phase 0:** Draft cases/data in parallel with architecture. **QA Phase A:** SIT task tests. **Phase B:** staging integration/regression/security/recovery. **Phase C:** post-release smoke only after release approval.
9. **Release gate:** Verified build, QA sign-off, rollback plan, critical defects resolved and explicit Founder Go/No-Go. Do not infer production authorization from a passing CI pipeline.
10. **Hotfix:** Define urgent triage and expedited approvals in each adopting project; emergency paths must not silently bypass security, audit trail or Founder authority.

Evidence: link exact issue, PR, commit, test run, environment and date. Record NOT VERIFIED when inaccessible.
