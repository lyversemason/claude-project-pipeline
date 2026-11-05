---
name: scope
description: Write the scope for one of Mason's planned projects, section by section, until it's ready to build. Use when the user types /scope (optionally with a project name), says "let's scope <project>", "pick up the plan for <project>", or wants to work out what a planned project will and won't do before building. Stage 2 after /ideas.
---

# Scope

Stage 2 of Mason's project pipeline: **project idea → a scope he agrees to → ready to build.**
Stage 1 (is the idea even worth it?) is `/ideas`. Building is neither skill: no code here.

## 1. Pick the project

- `/scope <name>`: open `~/Projects/<name>/PLAN.md`.
- `/scope` alone: list the projects in `~/Projects` whose PLAN.md status is IDEA or PLANNING
  (`grep -l "^Status: \(IDEA\|PLANNING\)" ~/Projects/*/PLAN.md`), one line each with its
  "Where we left off" date, and ask which one.
- If the project has no PLAN.md (an idea that skipped /ideas), offer to make one first using the
  layout in the `ideas` skill.

Read the whole PLAN.md and CHANGELOG.md, then tell Mason in two or three lines where it stands and
what's next (from "Where we left off"). Start there.

## 2. What the scope covers

Work through these, one at a time, in whatever order makes sense for the project. Skip any that
don't apply. Each becomes a section in PLAN.md.

1. **What it does:** the must-haves for the first version vs. "later" ideas (park them in a
   Later list so they aren't lost).
2. **Who uses it, where:** Mason only, family, public? Phone, desktop, car, tailnet port?
3. **What it won't do:** the edges, said out loud.
4. **How it works (high level):** plain language, the moving parts and how they talk. Mark it
   "Claude's proposal, not decided" until Mason agrees.
5. **Hard rules:** privacy (the never-view rules in ~/.claude/CLAUDE.md),
   private data that must not leave the machine, costs that are off limits.
6. **Hard parts / risks:** what's most likely to go wrong and the plan for it.
7. **Phases:** phase 1 = the smallest thing he'd actually use. Later phases after.
8. **Done looks like:** how we'll know phase 1 works (what Mason does, what he sees).

## 3. How to run it

- One section at a time. Give your proposal in a few lines, with the tradeoff in plain language,
  then let Mason decide. Ask at most one or two questions at once.
- Mason can steer by asking questions, same as in /ideas. Follow his lead.
- **Best practices by default, and teach them.** Every proposal follows best coding practices
  for this kind of project (security, testing, structure, data safety, accessibility, whatever
  applies). Say which practice you're following and *why* it exists, in plain language, using
  this project as the example. The scope is also how Mason learns them.
- **Flag it when Mason's idea goes against one.** You must tell him: name the practice, what
  goes wrong without it, and the better way. Then he decides. If he still wants his way, write
  it in Decisions as his choice, with the practice it skips.
- Write decisions into PLAN.md as they're made (`## Decisions (<date>)`), keep undecided items in
  `## Open questions`, and keep his original "The idea" section untouched.
- Stop when he's had enough; don't push to finish in one sitting.

## 4. Save every session

Before the chat ends (or when he stops):

1. Update `## Where we left off (<date>)`: what got decided, what's next.
2. Change `Status:` to `PLANNING` once scoping has started (from IDEA).
3. New version: bump the minor version (v0.1.0 → v0.2.0), add a CHANGELOG.md entry under
   `<!-- NEXT VERSION GOES HERE -->` (date, what was decided in plain English, "Restore this if:"),
   commit, annotated tag.
4. Update the project's memory line in `MEMORY.md` (and its memory file): version, date, next step.

## 5. When the scope is done

When every section that applies is decided and Mason agrees, set
`Status: SCOPED. Ready to build when Mason says build.` and say so in one line. Building is a
separate step he starts himself.

## Don't

- Don't write code or set up the app.
- Don't overwrite Mason's words in "The idea".
- Don't mark a proposal as decided until he says so.
