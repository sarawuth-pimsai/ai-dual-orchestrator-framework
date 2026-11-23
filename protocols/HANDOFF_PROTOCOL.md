# Cross-Model Handoff Protocol

Use existing project work items. Do not create duplicate tickets merely to hand off.

Required fields: Handoff ID; source project/issue; sender role; receiver role; business/technical context; deliverable; acceptance criteria; exact source paths/versions/commit SHAs; dependencies; approval gate; proposed due date; next owner; confidentiality classification.

States: NOT SENT -> POSTED / AWAITING RECEIVER -> ACKNOWLEDGED -> IN EXECUTION -> EVIDENCE RECEIVED -> VERIFIED. BLOCKED can apply at any stage with owner and unblock condition.

Posting a file or comment is not dispatch. Receiver must explicitly acknowledge receipt and check scope, versions and prerequisites. Sender verifies returned evidence against acceptance criteria. If tools cannot call the receiver, label it awaiting receiver; do not fabricate completion.

## Acknowledgment channels

Two channels are allowed side by side. In both, a comment or a file alone is not proof of receipt.

1. **Record channel.** The receiver writes its acknowledgment and evidence in the project work item or document where the handoff lives, naming the Handoff ID and the versions it read.
2. **Founder relay channel.** Some receivers may be forbidden to write in the repository that holds the handoff (for example, the Implementation role in the documents repository). Then the receiver reports its acknowledgment and evidence in its own session to the Founder, and the Founder relays them to the sender. The receiver's report names the Handoff ID, the exact versions it read (commit, and blob SHA for files) and its scope check. The sender records the state as ACKNOWLEDGED or EVIDENCE RECEIVED **via Founder relay**, with the relay date and the relayed text, and verifies the evidence against the acceptance criteria. A relay that does not name the Handoff ID and the versions read does not count as acknowledgment.



Founder-to-Requirements: requirements, intent and any explicit decisions or approvals, recorded against the canonical project source (the documents repository).
Requirements-to-Business: a specific request for UX/UI, legal, financial or other business specialist input, or for user-behavior scenarios and business rules, including context, deliverable, acceptance criteria, dependencies and approval gate.
Business-to-Requirements: specialist findings, scenarios, business needs and rules, constraints, UX contract, evidence, relevant approvals and open decisions, and judgments on whether e2e results match what the business needs. Receipt requires actual acknowledgment. Requirements maintains the canonical contract; Business input or handoff acknowledgment is not Founder approval.
Requirements-to-Implementation: the approved contract, feature IDs, acceptance criteria and the Founder-approved risk tier, with pinned commit and blob SHAs. Work issues live in the code repository. Implementation acknowledges via either channel above.
Implementation-to-Requirements: test evidence (unit, integration), PR links, proposed technical choices and ADR proposals, questions about acceptance criteria, and build or environment details needed to run e2e scripts. Technical choices still need Founder approval.
Requirements and Implementation to PM, and Business to PM: dated status and evidence, forecast and blockers; PM cannot alter owner approvals.
