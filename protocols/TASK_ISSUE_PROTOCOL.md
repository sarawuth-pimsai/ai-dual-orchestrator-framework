# Task Issue Protocol

How the Requirements role writes a task issue in the code repository so that the Implementation role can work without asking questions that exist only because the issue was unclear, and how the two roles record state on that issue. It adds to `templates/TASK_CONTRACT.md` (the fields) and `protocols/TECH_EXECUTION.md` (the workflow); it does not replace either. Authority is unchanged: scope, tier and technical choices stay with the Founder, and no step here authorizes code changes that the Founder has not authorized (`protocols/TECH_EXECUTION.md` step 6).

## 1. Checks before the Requirements role publishes a task issue

If the Implementation role has to ask a question because one of these checks failed, that is a fault of the issue, not of the implementer.

1. No two sentences disagree. Where a folder, word or rule appears twice, both places say the same thing.
2. Every "every", "all" and "never" says what counts.
3. Every measured number has a command, a list of exclusions, and a named decider for cases the tool cannot measure.
4. Each acceptance criterion has been walked through against the plan; if no command shows it, rewrite it.
5. Every word for an environment or place ("production", "the test system", "a clean checkout") is defined by something that code or a person can look at, or is left to the Implementation role.
6. Every "no other" or "only" rule lists what already exists in the code repository.
7. Every value the sources do not fix ("a short wait", "a limit", "a suitable library") is given a value or is explicitly left to the Implementation role, to be named in its proposal.
8. Every "document", "record" or "report" names the file or comment where the answer goes.
9. Every kind of file the change needs (entry point, error type, settings, shared types, test helpers, migrations, configuration) has a named place.
10. One thing has one name everywhere, including between a parent issue and its sub-issues. A rule or decision the issue cites is pinned by commit (and blob SHA for a single file).

## 2. Comment markers

The first word of a comment is its marker. The newest comment that carries a marker is the state of the issue; a comment without a marker changes nothing.

| Marker | Written by | Meaning |
|---|---|---|
| READ | Implementation | What I understood and what I found missing |
| UNDERSTOOD / CORRECTION | Requirements | The reading is right / what is wrong in it |
| PLAN | Implementation | The split of section 3 |
| PROPOSAL | Implementation | A library, tool or internal design choice (see "Technical choices" below) |
| QUESTION | Implementation | Blocked on one named point |
| EVIDENCE | Implementation | Commands, results, commit, date, and what is NOT verified |
| REWORK / VERIFIED | Requirements | After running the commands again: what failed / what passed |

On a QUESTION the implementer also writes, in its own session, a copy-ready prompt for the Founder to relay, because a session does not watch GitHub (`protocols/HANDOFF_PROTOCOL.md`, Founder relay channel). For the same reason the Founder tells a session to continue after each wait; no template removes that step.

## 3. Splitting a large issue

After UNDERSTOOD, and only inside work the Founder has authorized, the Implementation role splits the issue into sub-issues, one Draft pull request each. This is a technical choice about the order of work, not a change of scope or acceptance criteria. It posts PLAN: the sub-issues in order, which sub-issue must be merged first (by issue number), and a table that maps every acceptance criterion to a sub-issue. It then implements without asking for a further go-ahead, closes each sub-issue itself after its merge, and posts EVIDENCE on the parent issue when all are merged. A sub-issue and the plan use the same name for the same dependency. `Closes #n` does not close an issue when the merge goes to a branch other than the default branch; close it by hand and say so.

## 4. Technical choices

A PROPOSAL does not block work: the implementer proceeds on it, at its own risk. Until the Founder approves it (for example by merging the pull request that carries it), it stays PROPOSED and is reported as such. Founder approval of technical choices is not removed.

## 5. Optional: re-running before Ready

The Founder, or the adopting project's recorded rule, may order the Requirements role to run a sub-issue's commands in a fresh clone with an isolated environment of its own, and to mark the pull request Ready only if the results match. It posts no marker on the sub-issue. This is a check of the evidence, not a second code review, and it does not replace VERIFIED on the parent issue. It is off by default because `protocols/TECH_EXECUTION.md` step 7 records that the Founder accepted the removal of an independent code gate.
