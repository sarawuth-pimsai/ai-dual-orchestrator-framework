# Cross-Model Handoff Protocol

Use existing project work items. Do not create duplicate tickets merely to hand off.

Required fields: Handoff ID; source project/issue; sender role; receiver role; business/technical context; deliverable; acceptance criteria; exact source paths/versions/commit SHAs; dependencies; approval gate; proposed due date; next owner; confidentiality classification.

States: NOT SENT -> POSTED / AWAITING RECEIVER -> ACKNOWLEDGED -> IN EXECUTION -> EVIDENCE RECEIVED -> VERIFIED. BLOCKED can apply at any stage with owner and unblock condition.

Posting a file or comment is not dispatch. Receiver must explicitly acknowledge receipt and check scope, versions and prerequisites. Sender verifies returned evidence against acceptance criteria. If tools cannot call the receiver, label it awaiting receiver; do not fabricate completion.

Founder-to-Tech PO: requirements, intent and any explicit decisions or approvals, recorded against the canonical project source.
Tech PO-to-Business: a specific request for UX/UI, legal, financial or other business specialist input, including context, deliverable, acceptance criteria, dependencies and approval gate.
Business-to-Tech PO: specialist findings, business needs and rules, constraints, UX contract, evidence, relevant approvals and open decisions. PO receipt requires actual acknowledgment. PO maintains the canonical contract; Business input or handoff acknowledgment is not Founder approval.
Tech-to-PM and Business-to-PM: dated status and evidence, forecast and blockers; PM cannot alter owner approvals.
