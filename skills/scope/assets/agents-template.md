# <Display Name>: rules for every agent

<Two or three lines: what the project is, who it's for, the one quality it's built around.>

This file holds the rules every agent follows, whichever company's model it is (Claude reads it
through CLAUDE.md, Codex reads it directly). Don't copy rules into other files; point here.

## Read first
1. `PLAN.md`: the scope. Decisions (indexed), What it won't do, How it works, Hard rules,
   Security, Testing, Hard parts and risks, Build plan, Phases and "done", **Where we left off**.
2. `docs/build-log.md`: every build step so far, newest first.
3. `docs/decisions/`: one file per real decision (what was chosen, what else was considered, why).
<4. `docs/contract.md` if two sides exchange messages: the source of truth for both.>

## How work happens
- Work in **small steps**. One step = one clear, testable change.
- The owner makes the calls on anything that changes what the user sees or does, costs money,
  touches privacy or security, or is hard to undo. Agents decide the inside-the-code "how" that's
  easy to change, and record it in a decision record. When unsure which side it falls on, ask.
- A step is saved only when its tests and style checks pass. Each saved step gets a version bump,
  a `CHANGELOG.md` entry (date, what changed in plain English, "Restore this if:"), a commit and an
  annotated tag. Never rewrite history; restore old work by committing it as a new version.
- After every step, update "Where we left off" in `PLAN.md` and add the step to
  `docs/build-log.md`, so a fresh agent can pick up from the files alone.
- New ideas from the owner mid-build go to PLAN.md → Later unless they touch a one-way door (data
  model, anything others already use, security model, core architecture); then stop and decide.
<- Project-specific rule about the owner's live machine / devices, if any.>

## Code rules
- **Language(s):** <from the scope, with the decision record number>.
- **Dependencies:** as few as possible; each non-obvious one gets a decision record. Dev tools
  (test runners, linters, formatters, type checkers) don't count as shipped dependencies.
- **Size budgets (starting values):** about 400 lines per file, about 50 lines per function, the
  language checker's standard complexity limit. Breaking one needs a written reason in the step
  report.
- **Nothing hard-coded to one machine:** no usernames, home paths, ports or device names in code.
  Settings come from `<settings file>` with sensible defaults; a committed example with
  placeholders.
- **Secrets** live in files at mode 600 (or a secret store), never in the repo, logs or chat.
- Plain, boring code beats clever code. Comments explain *why*, not *what*.
- **Versions** live in git tags (`vX.Y.Z`) and the CHANGELOG. Main branch is `main`.
<- Contract rule, if two sides talk: define the message in docs/contract.md first, test both sides.>

## Safety rules (never broken)
<From PLAN.md → Hard rules and Security. Number them. Typical:>
1. <Access rule: who may use it, verified how, on every request.>
2. <Data rule: what never leaves the machine / is never recorded.>
3. No secrets or personal information in any tracked file or commit.
4. No paid service or purchase without the owner's OK.
5. Browser and audio tests run muted.
<6. Fail-safe rule for anything that acts on the machine or sends on the owner's behalf.>

## Testing
- Safety behaviour gets its test written first.
- <The tracer path> has an end-to-end test.
- Every connection between parts has an integration test.
- Tests never touch real data: <the sandbox: test database / folder / test_mode flag>.
- One command runs everything: `<make test | npm test | go test ./...>`. A pre-commit hook runs it;
  a failing step is not saved.
- Style robots: `<linter>`, `<formatter>`, `<type checker>`, run with the tests.
- Real-device checks are a numbered checklist the owner runs at checkpoints.
- Every bug found becomes a regression test.
