---
name: scope
description: Write the scope for one of Mason's planned projects, section by section, to a production-grade standard, until it's ready to build; then create the project's build skill. Use when the user types /scope (optionally with a project name), says "let's scope <project>", "pick up the plan for <project>", wants to work out what a planned project will and won't do before building, or asks how an existing scope stacks up ("/scope <project> check", "audit the scope", "does the plan meet the bar"), or wants the pre-build gate run ("/scope <project> gate", "run the gate", "is it ready to build"). Stage 2 after /ideas.
---

# Scope

Stage 2 of Mason's project pipeline: **project idea → a scope he agrees to → ready to build.**
Stage 1 (is the idea worth it?) is `/ideas`. Building is neither skill: no code here.

Two things make this skill different from "chat about the plan":

1. **Everything is scoped as if it ships.** Mason builds for his portfolio and resume. Whether a
   project is ever deployed is decided later; the scope always meets the production bar for its
   kind. Never ask "is this just for you?" as a way to lower the bar.
2. **Mason learns as he scopes.** He is the architect, agents are the contractors. An architect
   who can't explain the building isn't one. So every section teaches the why, every decision is
   recorded with its reasoning, and a textbook grows across projects.

## Files this skill reads and writes

| What | Where |
|---|---|
| The project's plan | `~/Projects/<name>/PLAN.md` (sections listed in step 2) |
| Decision records | `~/Projects/<name>/docs/decisions/NNNN-<slug>.md` (full records; PLAN.md keeps the index) |
| Textbook | `~/Projects/ideas/textbook/` (chapters, concepts, glossary; see `references/textbook.md`) |
| Knowledge | `references/` in this skill: read the ones the project needs, when it needs them |
| Templates | `assets/`: project skill, AGENTS.md, decision record, hook |

The references are the knowledge Mason doesn't have yet. Read them, don't guess. Read each one
when its step comes up, not all of them at the start; they're long and most sessions touch two
or three.

| When | Read |
|---|---|
| Every session, before section 2 and whenever a decision is being made | `references/thinking-tools.md`: lenses by problem shape, trap lenses, overplanning signals and script, the late-idea rule |
| Section 3 (kind and bar), and again for sections 9 to 11 | `references/project-types.md` (what this kind needs, what breaks), `references/production-bar.md` (the 14 items, sized) |
| Section 9, and section 8 if the project touches private data | `references/security.md`: levels 0–3, the threat model, controls, data classes |
| Section 10 | `references/testing.md`: kinds, per-project table, break-it pass, when enough is enough |
| Section 13, and step 6 (build kit) | `references/build-plan.md`: roles, sizing, models and effort, checkpoints |
| After any section is decided, and step 6 | `references/textbook.md`: chapter and concept page format |
| The gate (step 7) | `references/gate.md`, and `assets/audit-prompt.md` for the readers |
| Audit mode (step 8) | all of them except `textbook.md` |

## 1. Pick the project and open

- `/scope <name>`: open `~/Projects/<name>/PLAN.md`.
- `/scope` alone: list projects whose PLAN.md status is IDEA or PLANNING
  (`grep -l "^Status: \(IDEA\|PLANNING\)" ~/Projects/*/PLAN.md`), one line each with the
  "Where we left off" date, and ask which one.
- `/scope <name> gate`: the pre-build gate on a SCOPED project, see step 7.
- `/scope <name> check`: audit mode, see step 8.
- No PLAN.md (an idea that skipped /ideas): offer to make one first using the layout in the
  `ideas` skill.

Say which model you're on. Scoping runs on **Fable 5.1**: the scope is where the one-way doors
get decided, and that's where the strongest model earns its cost. If you're not on it, say so
once and let Mason decide whether to restart; you can't switch yourself.

Read the whole PLAN.md, CHANGELOG.md, `docs/decisions/` if it exists, and the project's textbook
chapter if it exists. Then tell Mason in two or three lines where it stands and what's next.

- **First scope session** (Status is IDEA, or the plan has no scope sections yet, however old it
  is): the next step is always section 1, whatever "Where we left off" says. Carry anything useful
  from `## What we figured out` into the sections as they come up; don't re-ask what /ideas
  already settled. Rewrite the Status line to the current form
  (`Status: PLANNING. Scoping with /scope (started <date>). No code until Mason says build.`);
  older plans say "PLANNING ONLY" and mean the same thing.
- **Later sessions:** start where "Where we left off" says. Don't re-open decided sections unless
  he asks, or unless a later section shows an earlier decision was wrong, in which case say so.

**Look before you ask.** Anything you can find out yourself, find out: what's on the machine
(ports in use, what's installed, how the existing apps are run), how his other projects in
`~/Projects` solved the same thing, what the references say. Then ask Mason only what only he
knows: what he wants, how he'll use it, what he'll pay, what he's willing to maintain. Questions
you could have answered with a `grep` cost him attention and teach him nothing.

## 2. What the scope covers

Each becomes a section in PLAN.md. The first three come first, because everything else depends on
them. After that, go in whatever order fits the project, and skip what doesn't apply.

1. **The problem.** What's wrong today, in one paragraph, and the finished picture: what Mason
   (or the user) is doing on the day it works. Work backwards from that picture, not forwards
   from a login screen.
2. **Problems inside the project.** Decompose: list the separate problems the project has to
   solve (usually four to eight). For each, name its shape and pick one or two lenses from
   `thinking-tools.md`. Don't run every lens on every problem. This list drives the rest of the
   scope, and it's the part most people skip.
3. **Kind and bar.** Which project kind(s) in `project-types.md` this is, which security level in
   `security.md`, and therefore which production bar from `production-bar.md`. Say it in a few
   lines. Everything after this is measured against it.
4. **What it does.** Must-haves for phase 1 vs. Later. Use Pareto (the twenty percent that
   carries the value) to pick, and the tracer bullet (one action, one visible result, every
   layer touched once) to find phase 1's core. Later ideas are parked, not lost.
5. **Who uses it, where.** Mason only, family, public? Phone, desktop, car, tailnet port?
6. **What it won't do.** The edges, said out loud.
7. **How it works.** Plain language: the moving parts and how they talk. The connections are the
   architecture, and most expensive bugs live in the connections, so spend the time there. Mark
   it "Claude's proposal, not decided" until Mason agrees.
8. **Hard rules.** Privacy (the never-view rules in `~/.claude/CLAUDE.md`), data that never
   leaves the machine, costs that are off limits, anything the project must never do.
9. **Security.** From `security.md`: the level, a short threat model (what's worth protecting,
   who'd come for it, how they'd get in, what we do about it), and the specific controls.
10. **Testing and breaking it.** From `testing.md`: which kinds of tests, which safety behaviour
    gets its test written first, the break-it list, what Mason tests by hand on the real device.
11. **Running it.** From `production-bar.md`: how it starts, restarts, logs, says it's healthy,
    backs up and restores its data, and how someone else sets it up from the README.
12. **Hard parts and risks.** Pre-mortem: assume it failed, why? Plan ahead only for risks that
    are both likely and expensive to undo later (data, security, the core architecture, anything
    others already use). Let the rest play out. Say which bucket each risk is in.
13. **Build plan.** From `build-plan.md`: the agent roles, sized to this project; which models and
    effort per kind of step; checkpoints and what Mason sees at each; the late-idea rule; what
    Mason does himself (device tests, sign-ins, money).
14. **Phases and done.** Phase 1 = the tracer bullet plus what makes it safe to use. "Done" for
    phase 1 is a checklist Mason can run: what he does, what he sees, the numbers that must be
    met. Later phases are one line each; their details are decided when they start.
15. **What this shows.** Two or three lines: what a hiring manager or reviewer sees in this
    project (the skills, the decisions, the production bar) and where in the repo they'd see it.

## 3. How to run a section

- **One section at a time.** Give your proposal in a few lines with the tradeoff in plain
  language, then let Mason decide. Ask at most one or two questions at once.
- **Propose, don't survey.** Lead with the option you'd pick and why; the others go in the
  decision record. A list of four choices with no recommendation is work handed back to him.
- **Mason steers by asking questions.** Follow his lead. He thinks by asking; answer what he
  asked, then come back to the section.
- **Best practices by default, and teach them.** Every proposal follows the practices for this
  kind of project. Name the practice, say why it exists, using this project as the example. The
  scope is how Mason learns them; the textbook is how he keeps them.
- **Flag it when his idea goes against one.** Name the practice, what goes wrong without it, the
  better way. Then he decides. If he keeps his way, it's recorded as his choice with the practice
  it skips.
- **Talk straight.** No praise without a reason you can point at. If a plan is weak, say where
  and why before saying what's good. Mason has asked for this and makes better decisions when he
  gets it. A plan that's actually sound earns a plain "this is sound, here's why" at the end, and
  that assurance is worth something only because you'd have said otherwise.
- **Flag overplanning, every time you see it.** The signals and the rule are in
  `thinking-tools.md`. When you flag it, say what's happening, why it costs him, and what to do
  instead (usually: default it, mark it tunable, or move it to a later phase). Reversibility is
  the rule: decide fast on anything cheap to undo, slowly on the one-way doors.
- **Unanimity isn't proof.** If every angle agrees, say so, and name the blind spot they might
  share. That's what the cross-vendor reviewer in the build plan is for.
- **Stop when he's had enough.** Don't push to finish in one sitting.

## 4. Record everything

- **PLAN.md layout.** Once scoping starts, PLAN.md has this shape, in this order. Add headings as
  sections get decided; don't create fifteen empty ones on day one.
  ```
  # <Display Name> — plan
  Status: PLANNING. Scoping with /scope (started <date>). No code until Mason says build.
  ## The idea (Mason, <date>)            <- never edited
  ## What we figured out                  <- from /ideas; fold into the sections below, then remove
  ## Scope
  ### 1. The problem ... ### 15. What this shows   (numbered as in step 2; skipped ones say why)
  ## Decisions                            <- index: one line per record in docs/decisions/
  ## Open questions
  ## Later                                <- parked features and late ideas
  ## Where we left off (<date>)
  ```
  A section is decided when PLAN.md says what was decided and the record exists; a proposal that
  Mason hasn't agreed to stays marked "Claude's proposal, not decided".
- **Decision records.** Every real decision gets its own file in `docs/decisions/` using
  `assets/decision-template.md` (create the folder and its README from `assets/decisions-readme.md`
  the first time). Context, options considered, the decision, why, what it costs. Mark who decided.
  When two lenses pointed different ways, both views go in. These records are the portfolio: a
  reader on GitHub should see how Mason thinks, not just what got built.
- **PLAN.md keeps the index.** `## Decisions` is one line per record: number, title, date, who.
  Undecided items live in `## Open questions`. Parked features in `## Later`.
- **"The idea" is never touched.** Mason's words stay as written.
- **Textbook, after each section.** Not mid-conversation; the talk stays about decisions. When a
  section is decided, add the notes to the project's chapter, update or create the concept pages
  it used, and add new terms to the glossary. Format and rules are in `references/textbook.md`.

## 5. Save every session

Before the chat ends (or when he stops):

1. Update `## Where we left off (<date>)`: what got decided, what's next.
2. `Status:` becomes `PLANNING` once scoping has started (from IDEA).
3. New project version: bump minor (v0.1.0 → v0.2.0), CHANGELOG.md entry under
   `<!-- NEXT VERSION GOES HERE -->` (date, what was decided in plain English, "Restore this if:"),
   commit, annotated tag.
4. Commit the textbook: `git -C ~/Projects/ideas commit -am "textbook: <project> (<sections>)"`.
5. Update the project's memory line in `MEMORY.md` (and its memory file): version, date, next step.

## 6. When the scope is done

When every section that applies is decided and Mason agrees:

1. **Verdict, one paragraph, honest.** Is this plan sound? Where is it still thin? What's the one
   risk you'd watch? If it's sound, say so plainly; that's the assurance he's asked for.
2. **Create the build kit** in the project (still no app code):
   - `AGENTS.md` from `assets/agents-template.md`, filled from the scope (rules, code rules, safety
     rules, testing). `CLAUDE.md` that imports it and lists the Claude-specific bits.
   - `CLAUDE.local.md` (untracked) for Mason's private context and machine rules.
   - `.claude/settings.json` + `.claude/hooks/reload.sh` from `assets/reload-hook/`, so a
     summarised chat re-reads the files.
   - `docs/build-log.md` (empty, with the header), `docs/decisions/` if not yet there.
   - **The project skill** at `~/Projects/<name>/skill/SKILL.md` from
     `assets/project-skill-template.md`, filled with this project's build plan (roles, models,
     effort, checkpoint contents, device checks), symlinked into `~/.claude/skills/<name>`.
     This is the XO Mason talks to during the build. The skill-creator skill is for improving it
     later, not for making it.
   - `.gitignore` covering CLAUDE.local.md and anything the hard rules say stays private. Ignore
     private things by folder or exact name, not by file type: a blanket `*.png` also blocks the
     app's icon.
   Rules for the kit, learned the hard way:
   - **One source of truth.** The skill points at PLAN.md for checkpoints, spike questions and the
     done checklist; it doesn't restate them. Two copies drift the moment step 0 changes the plan.
   - **Same numbers everywhere.** AGENTS.md's safety rules keep PLAN.md section 8's numbering. If
     the list needs to change, change the plan first, then AGENTS.md, then anything that cites a
     rule by number (CLAUDE.local.md).
   - **Rules, not spec.** AGENTS.md holds what every agent must obey on every step. Test cases,
     magic strings and step details live in PLAN.md section 10 or the step report.
   - **No private names in tracked files.** Hard-rule examples say "private legal, medical and
     family matters", never the name of a private project, claim or person. Check every tracked
     file against the PRIVATE memories before the first push; history is never rewritten.
   - **Commands are copy-ready.** No `<effort>` placeholders inside a command block; put the real
     values in, and the rule for choosing them beside it.
   - **Touch only this project.** Never remove or change another project's skill link, files or
     memory, even if this project replaces it. Say what should happen to the old one; Mason does it.
3. Set `Status: SCOPED (gate pending). Run /scope <name> gate in a fresh chat before building.`
4. Save (step 5), and finish the textbook chapter's "What I'd say in an interview" section.
5. Say so in one line, with the gate as the next step. Building is a separate step he starts
   himself, after the gate.

## 7. The gate: `/scope <name> gate`

Two fresh readers from two vendors audit the finished scope and its kit before any code exists;
their findings are sorted, the real ones fixed, and the scope is audited once more. Two rounds,
hard stop. The procedure, the Codex command, the three bins and the pass rule are in
`references/gate.md`; follow it exactly. The chat that wrote the scope doesn't run the gate:
it would be grading its own work. When the gate passes, the Status becomes
`SCOPED. Ready to build when Mason says build (cd ~/Projects/<name> && claude, then /<name>).`

## 8. Audit mode: `/scope <name> check`

For a project that's already scoped or building. Read its PLAN.md, AGENTS.md, CHANGELOG.md,
`docs/decisions/`, `docs/build-log.md`, README, and the repo itself (tests folder, `.claude/`,
service files, `.gitignore`): the production bar's test is "could a stranger reading the repo see
it's met", so the repo is evidence, not just the plan. Then read every reference except
`textbook.md` and hold the project against them:

- For each of the fifteen sections above: present and decided, thin, or missing. One line each.
  A section counts as present if its content is decided anywhere in PLAN.md or the decision
  records, whatever heading it sits under; older plans don't use these headings.
- Production bar for its kind: which items are met, planned, or absent.
- Security level and whether the controls match it.
- Testing: what's covered, what the break-it list is missing.
- Build plan: right-sized, too heavy, or too light for this project, and why.
- Overplanning: anything decided that should have been a default or a later-phase call.
- **Verdict:** a letter grade on this rubric, the three things to fix first, and what's
  genuinely strong, in that order. No smoke.

  | Grade | Means |
  |---|---|
  | A | Every applicable section decided; bar items met or planned with the plan visible in the repo; controls match the security level; tests at the stage's bar (SCOPED: kinds chosen, safety tests named, the one test command and the hook planned; BUILDING: written and running); build plan sized right. Nothing a senior engineer would send back at this stage. |
  | B | Sections present; at most three bar, security or testing items thin or missing, none of them a one-way door (data model, security model, anything others use). Ready to build with those three fixed first. |
  | C | The core (problem, what it does, how it works, phases) is decided but security or testing or running-it is missing or only in someone's head. Building now means retrofitting. |
  | D | A features list and a stack. No problem statement, bar, security or testing. |
  | F | No plan, or the plan breaks a hard rule in `~/.claude/CLAUDE.md`. |

  Name the grade, then the rubric line it matched and the evidence (file and section) for each
  claim. Verify before you write: a claim about the repo or its history (`grep`, `git log`) is
  checked, not inferred from the plan. One wrong finding costs the report its credibility. "The three things to fix first" are exactly three; more goes under "Also".

Write it to `~/Projects/<name>/docs/scope-check-<date>-<reader>.md` (reader: `claude` or `codex`;
add `-r2` for a second round), then offer to turn the fixes into scope sessions, or the gate if the
project is SCOPED. Don't change PLAN.md in audit mode.

## Don't

- Don't write code or set up the app. The build kit in step 6 is files and a skill, not code.
- Don't overwrite Mason's words in "The idea".
- Don't mark a proposal as decided until he says so.
- Don't lower the bar because a project is small or personal. Size the bar, don't skip it.
- Don't praise without evidence, and don't soften a real problem.
