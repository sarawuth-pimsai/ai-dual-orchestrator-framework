# Cross-Model Handoff Protocol

Use existing project work items. Do not create duplicate tickets merely to hand off.

Required fields: Handoff ID; source project/issue; sender role; receiver role; business/technical context; deliverable; acceptance criteria; exact source paths/versions/commit SHAs; dependencies; approval gate; proposed due date; next owner; confidentiality classification.

States: NOT SENT -> POSTED / AWAITING RECEIVER -> ACKNOWLEDGED -> IN EXECUTION -> EVIDENCE RECEIVED -> VERIFIED. BLOCKED can apply at any stage with owner and unblock condition.

Posting a file or comment is not dispatch. Receiver must explicitly acknowledge receipt and check scope, versions and prerequisites. Sender verifies returned evidence against acceptance criteria. If tools cannot call the receiver, label it awaiting receiver; do not fabricate completion.

Business-to-Tech: approved requirements, feature IDs, business rules, UX contract and acceptance criteria.
Tech-to-Business: feasibility, trade-offs, unresolved business questions, demo/QA evidence, risk and decisions requiring Founder.
Tech-to-PM and Business-to-PM: dated status and evidence, forecast and blockers; PM cannot alter owner approvals.
