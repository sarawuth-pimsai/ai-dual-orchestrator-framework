# Governance and Operating Model

## Authority

Founder: final authority for vision, scope, business/financial/legal decisions, risk tier, technical choices, implementation, deployment, release and material date rebaseline.

Business Orchestrator (GPT): owns UX/UI, Marketing, Finance, Accounting & Tax and Legal & Compliance readiness. Writes the scenarios of user behavior and the business rules that must not break, and judges whether test results match what the business needs. Receives handoffs from the Requirements role when business specialist input is needed, and returns evidence, recommendations and open decisions. May coordinate authorized business-side work, not Founder decisions.

Requirements role: owns the Product Owner (PO) function, the canonical product contract, feature IDs, scope, business rules and measurable acceptance criteria, and the end-to-end (e2e) test scripts. Writes and runs the e2e scripts against the environment the Founder names and reports pass or fail. Proposes risk tiers. Receives requirements directly from Founder and requests Business input when needed; does not approve decisions reserved for Founder or redefine approved scope.

Implementation role: owns the code and the code-level checks. Writes and tests the code in the code repository, including unit and integration tests. Proposes technical choices (libraries, internal architecture) and architecture decision records (ADRs). Keeps the original architecture rules in the code repository.

PM Agent: reconciles all schedules and evidence, highlights critical path, risk, variance and blockers; does not command any role or approve work.

The Requirements and Implementation roles run in separate sessions and are peers. "Tech side" below means both. Whether one session may hold more than one role is not decided by this framework; it is a Founder decision per adopting project.

## Proposals and approvals

| Item | Proposes | Approves |
|---|---|---|
| Product scope, business rules, acceptance criteria | Requirements (with Business input) | Founder |
| Risk tier (T1-T3) | Requirements | Founder |
| Technical choices, architecture, ADRs | Implementation | Founder |
| Implementation scope, deployment, release | Requirements / Implementation | Founder |

The tier never overrides Founder approval. Only the Founder may approve strategic, business, financial, legal, implementation or release decisions unless an explicit delegation is recorded.

## Where records live

Work issues (feature and QA tasks) live in the code repository. Decisions and requirements stay in the documents repository. The original architecture rules live in the code repository; the documents repository keeps only a pointer pinned by commit and blob SHA and the record of the Founder's approval, never a second copy. Pin every cross-reference by commit.

## Gates

1. Discovery / Problem Defined: evidence and objectives identified.
2. Product Ready: scope, business rules and acceptance criteria approved.
3. Design Ready: UX and technical design reconciled; risk tier and security triage approved or recorded.
4. Implementation Authorized: Founder approves defined implementation scope; authorization is not implied by design completion.
5. QA Verified: code-level, business-level and user-level test evidence, critical defects, security and recovery requirements satisfied.
6. Release Authorized: Founder approves release after evidence-backed Go/No-Go.

A status in a GitHub Issue or Project board is not itself proof of approval or acceptance.

## Checks before the Founder merges

Three levels. Code level: unit and integration tests written and run by the Implementation role. Business level and user level: automated e2e tests written and run by the Requirements role from Business scenarios, with Business judging fit. Details are in `protocols/TECH_EXECUTION.md`.

The code-level tests replace the independent code review that earlier versions required. This removes an independent gate, and the author's tests check the author's own understanding. The Founder accepted this. The decision does not remove or weaken any security checklist.

## Operating rhythm

Business and the Tech side maintain their own workstream plans. PM merges milestones and dependencies into one critical path. Cross-side handoffs use `protocols/HANDOFF_PROTOCOL.md`. At meaningful checkpoints each role publishes verifiable status; automated schedules require separately configured infrastructure.

## Conflict resolution

Business rule conflict -> Requirements and Business Orchestrator reconcile inputs -> Founder if a new decision or change to approved scope is required.
Technical architecture conflict -> Implementation proposes; Requirements coordinates with Business on affected business requirements and UX; Founder decides.
Test result disagreement (a script fails, or a pass does not match the business need) -> Requirements reports facts; Business judges fit; Implementation fixes code; Founder decides if scope or rules change.
Deadline or resource conflict -> PM consolidates options -> Founder decides commitments.

## Stop conditions

Stop when acceptance is met, a genuine external dependency/approval blocks further work, or no necessary authorized independent action remains. Report exact unblock condition. Never label a role incomplete solely because implementation is not yet approved if all preparatory work is complete.
