# Release procedure for this repository

The Founder has authorized a new release after each PR merge into this repository's `main`. This is repository-specific and does not grant release authority for adopting projects. It is a continuing instruction to the responsible maintainer or agent, not an automated workflow; a merge alone does not create a release.

1. Inspect the actual `main` commit, existing releases, open blockers and changes. Choose an appropriate new version and update the CLI version, tests, README, Thai guide and other affected documentation before building the release. Ensure examples distinguish the new CLI from previously published versions. Never move or overwrite a previously published tag or release.
2. Run the applicable test suites, verify CLI behavior, release asset checksums and project upgrade/rollback paths where relevant. Resolve failures before publishing. Report blockers rather than skipping checks.
3. Create a new tag pointing to the verified commit and publish a GitHub release with `ai-framework`, `framework-vVERSION.zip` and `SHA256SUMS`, including accurate notes, breaking changes and trust limitations. Do not describe an action as complete without evidence.
4. Verify the published tag, asset hashes and CLI behavior. Report the release link, commit, validation and any limitations. Do not modify an installed CLI or adopting project without the user's authorization.
