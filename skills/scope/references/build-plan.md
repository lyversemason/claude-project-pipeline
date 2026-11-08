# The build plan: roles, models, effort, checkpoints

How the project gets built is a scope decision, not something to improvise on day one. This
file is the menu; the scope's build-plan section picks from it and sizes it to the project.
Full Nelson is the reference for the large setup, and it's in `~/Projects/full-nelson/skill/SKILL.md`
and `AGENTS.md` if you need to see one in full.

## The roles, and why each exists

- **Commander (Mason).** Decides anything that changes what the user sees or does, costs money,
  touches privacy or security, or is hard to undo. Everything else is delegated. This is
  commander's intent: the agents know the goal and the limits and decide the "how" inside them.
- **XO (the project skill).** The one agent Mason talks to during the build. Plans each
  checkpoint, sends out builders and reviewers, keeps the files current, brings Mason only what
  needs him. *Why:* one point of contact keeps Mason's chat light and his attention on decisions.
- **Builder (fresh agent per step).** Reads the files, does one step, writes tests, runs the
  checks, reports in under two hundred words. *Why fresh:* a clean memory works from the files,
  so nothing depends on a long chat remembering a rule. A step small enough for one fresh agent
  is also small enough to redo if it goes wrong.
- **Reviewer (fresh agent per step, didn't write it).** Reviews only that step's changes against
  the rules and the step's "done". *Why:* the writer of code is the worst judge of it; the
  reviewer has no stake in the approach. Same vendor is fine here; speed matters.
- **Cross-vendor reviewer (at checkpoints).** A different company's model reviews everything
  since the last checkpoint. *Why:* different training, different blind spots. Unanimity from
  one vendor's models is not proof. Currently Codex (OpenAI) on Mason's ChatGPT Pro plan.
- **Style robots (every change).** Linters, formatters, type checkers, size budgets. Not AI. *Why:*
  they never get tired, never agree with you to be nice, and they are the answer to "AI slop" that
  Mason can point at without reading code.
- **Breaker (checkpoints and pre-launch).** A fresh agent whose only job is the break-it list in
  `testing.md`. *Why:* building and breaking are different mindsets; the builder wants it to work.
- **Built-in skills, at their moments:** `/code-review` (each step), `/simplify` (anti-bloat, at
  checkpoints), `/security-review` (checkpoints, level 2+), `/run` (demos), `diagnose-crash`
  (if a service dies), the Chrome tools (muted phone-screen tests).

## Sizing the setup to the project

Not every project needs the full Full Nelson apparatus. Overbuilding the process is its own
overplanning. Pick by the production bar's size.

| Size | Roles | Reviews | Checkpoints |
|---|---|---|---|
| **Small** (CLI, skill, no network) | XO + builder; reviewer for anything non-trivial | `/code-review` per step; style robots | One at the end, or none for a one-session build |
| **Medium** (tailnet app, desktop tool, scheduled job) | XO + fresh builder + fresh reviewer per step; style robots | Per step: tests + robots + reviewer. Per checkpoint: `/simplify`, `/security-review` if level 2 | Every few steps; demo on the real device |
| **Large** (public, remote control, others' data) | Everything above + cross-vendor reviewer + breaker | Per checkpoint add Codex and the break-it list; pre-launch: ultra review, full break-it pass, secret scan, clean-install test | Every few steps; end-of-phase whole-app review |

Say in the scope which row the project is in and why. If Mason wants more process than the row
calls for, that's his call, but flag it: process has a cost in time and usage, and a medium
project with large-project ceremony ships later for no gain in safety.

## Models and effort

The lineup changes; the rule doesn't: **the strongest model at high effort where mistakes are
expensive, a cheaper or faster one where they're not, and always a different vendor for the
second opinion.** Write the specific choices into the project skill so builders set them, not
Mason.

Current lineup (November 2026):

| Job | Model | Effort | Why |
|---|---|---|---|
| Scoping, architecture, the spike, the break-it pass | Claude Fable 5.1 | xhigh or max | Mistakes here are one-way doors |
| Routine build steps | Fable 5.1; Opus 5.5 when Fable's usage is out | xhigh for medium/large, high for small | Agents build, test, fix in loops; strength saves cycles |
| Per-step reviewer | Same as builder, fresh context | high | Speed matters; it's reviewing one step |
| Cross-vendor review | Codex: GPT-6-Astra; GPT-6.1-Sol when limited | high at checkpoints, max at end of phase, ultra pre-launch | Different blind spots |
| Emergency builder (both Claude limits out) | Codex building, Claude reviewing when back | high | Only with Mason's OK, and say which steps Codex built |
| Style robots | Not AI | n/a | Deterministic |

Step down models when usage runs low, and say so in the build log. Never let a step go unsaved
because a model ran out: stop at a clean point, save, hand off.

## The checkpoint

What Mason sees, in this order, every time, plain English:

1. **Demo:** working, on the real device where possible, or exact steps for him to try.
2. **What got done:** a few lines.
3. **Decisions to approve:** new records that are his call, one line each.
4. **Agent decisions:** the small ones, one line each, so he can veto.
5. **Budget breaks:** any limit broken (file size, dependencies, cost), with the reason.
6. **Reviews:** what reviewers, Codex and the robots found and what was done.
7. **Read the code:** five to fifteen real lines, explained line by line. Learning to read code
   like a map, not learning to write it.
8. **Textbook:** one or two lines on what this checkpoint added to the project's chapter.
9. **Device checklist** (if applicable): numbered things to try, numbers to record.
10. **Next:** what the next checkpoint covers.

Then the cue for a fresh chat. A long chat gets its memory summarised and forgets rules; starting
fresh is cheap and the files hold everything.

## Rules that go into every build plan

- **Small steps, each saved.** One step = one testable change, versioned, tagged, logged. Worst
  case is redoing one step.
- **Files over memory.** Everything important is in PLAN.md, AGENTS.md, the build log and the
  decision records. A reload hook reprints them after a summary.
- **The late-idea rule.** Mason says every new idea immediately, in one sentence, never
  discussed mid-build. The XO applies the one-way-door test: data model, anything others already
  use, security model, core architecture → stop and decide now. Otherwise Later, triaged at the
  next checkpoint.
- **Things only Mason can do** (device tests, sign-ins, passwords, money): the XO stops and gives
  numbered instructions, waits, writes his results into the files. A password prompt needs a real
  terminal, not the chat's `!` prefix.
- **The owner's live machine is not a test bench.** Tests that change what he sees need a
  hands-off window he's agreed to.
- **No step is saved unless tests and robots pass.**
- **After-action reviews.** When Mason reports a problem (saw / expected / how bad / where), fix
  the cause in the files or the skill, as a version, not just the instance.

## Where the large row comes from

The large row is drawn from the Full Nelson setup (fresh builder and reviewer per step,
cross-vendor review, style robots, the reload hook, "read the code" at checkpoints, commander's
intent written down, a spike before the language choice). Whether that setup was right for Full
Nelson is a judgment for `/scope full-nelson check` and the textbook, not for this file: the
reference that the audit measures against shouldn't carry an opinion about the project it's
measuring. The sizing table above is the rule; applying the large row unchanged to a medium
project roughly doubles time to ship for little safety gain.
