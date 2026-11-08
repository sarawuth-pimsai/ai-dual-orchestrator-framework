# Governance and Operating Model

## Authority

Founder: final authority for vision, scope, business/financial/legal decisions, implementation, deployment, release and material date rebaseline.

Business Orchestrator (GPT): owns UX/UI, Marketing, Finance, Accounting & Tax and Legal & Compliance readiness. Receives handoffs from Tech PO when business specialist input is needed, and returns evidence, recommendations and open decisions. May coordinate authorized business-side work, not Founder decisions.

Tech Orchestrator (Claude): owns Product Owner (PO), the canonical product requirements and acceptance contract, solution architecture, engineering task decomposition, implementation coordination when approved, code reviews, QA and security readiness. PO receives requirements directly from Founder, requests Business specialist input when needed, and maintains feature IDs, scope, rules and measurable acceptance criteria; PO does not approve decisions reserved for Founder or redefine approved scope.

PM Agent: reconciles both schedules and evidence, highlights critical path, risk, variance and blockers; does not command either orchestrator or approve work.

## Gates

1. Discovery / Problem Defined: evidence and objectives identified.
2. Product Ready: scope, business rules and acceptance criteria approved.
3. Design Ready: UX and architecture reconciled; security and risk triage documented.
4. Implementation Authorized: Founder approves defined implementation scope; authorization is not implied by design completion.
5. QA Verified: test evidence, critical defects, security and recovery requirements satisfied.
6. Release Authorized: Founder approves release after evidence-backed Go/No-Go.

A status in a GitHub Issue or Project board is not itself proof of approval or acceptance.

## Operating rhythm

Business and Tech maintain their own workstream plans. PM merges milestones and dependencies into one critical path. Cross-side handoffs use `protocols/HANDOFF_PROTOCOL.md`. At meaningful checkpoints each role publishes verifiable status; automated schedules require separately configured infrastructure.

## Conflict resolution

Business rule conflict -> Tech PO and Business Orchestrator reconcile inputs -> Founder if a new decision or change to approved scope is required.
Technical architecture conflict -> Tech Orchestrator/SA; PO coordinates with Business on affected business requirements and UX before Founder approval when required.
Deadline or resource conflict -> PM consolidates options -> Founder decides commitments.

## Stop conditions

Stop when acceptance is met, a genuine external dependency/approval blocks further work, or no necessary authorized independent action remains. Report exact unblock condition. Never label a team incomplete solely because implementation is not yet approved if all preparatory work is complete.
