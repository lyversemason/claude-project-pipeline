# Claude project pipeline: /ideas and /scope

Two [Claude Code skills](https://code.claude.com/docs/en/skills) I use to take a
new idea from "is this even worth building?" to a scope that's ready to build. I designed the
workflow and the rules; Claude Code wrote the skill files under my direction. They're the
actual files I run, with my name and paths left in.

- **`/ideas`** (stage 1): talk an idea through, get an honest viability check, then decide:
  drop it, park it, or make it a project.
- **`/scope`** (stage 2): write the scope one section at a time, to a production-grade bar
  sized to the project, until it's ready to build. Then it creates the project's build kit:
  `AGENTS.md`, decision records, a reload hook, and the project's own build skill.
  `/scope <project> check` audits an existing scope and grades it against the same bar.

Neither skill writes app code. Building is a separate step I start myself.

## Why two stages

The usual way an AI-assisted project goes wrong is building too early: a good conversation
turns into folders and code before anyone asked whether the thing should exist. Splitting the
work keeps each step honest:

1. `/ideas` only answers "is it worth it?" Does something free already do it? What will it
   cost? What's the one hard part most likely to sink it? Does it bump into a privacy rule?
   Claude gives a verdict (build, park or drop) and I make the call.
2. `/scope` only answers "what exactly is it, and what does it take to ship it?" Fifteen
   sections: the problem, the separate problems inside it, what kind of project it is and
   which bar applies, must-haves vs. later, who uses it where, what it won't do, how it works,
   hard rules, security, testing, running it, risks, the build plan (which agents do what, with
   which models), phases and "done", and what the project shows a reviewer.

## Design choices

- **I decide; the agent advises.** The skill never creates a project because the talk went
  well. It waits until I say "make it a project", and it never marks a proposal as decided
  until I agree.
- **Follow my lead.** I think out loud by asking questions, so the skill answers what I asked,
  briefly, asks at most one or two questions at a time and doesn't jump ahead to tech stacks.
- **Honest verdicts.** If an idea is bad, or already exists, it says so and why.
- **Everything is scoped as if it ships.** Whether a project is ever deployed is decided later;
  the scope always meets the production bar for its kind (`references/production-bar.md`),
  sized small, medium or large, never skipped. The skill carries the domain knowledge I don't
  have yet: what each kind of project needs (`project-types.md`), security levels and a
  plain-language threat model (`security.md`), what tests it needs and how to try to break it
  (`testing.md`), and how to set up the agents that build it (`build-plan.md`).
- **Problems inside the project come first.** Before features, the scope decomposes the project
  into its separate problems and picks one or two thinking lenses for each by its shape
  (inversion, survivorship bias, reversibility, tracer bullet, pre-mortem, and so on;
  `references/thinking-tools.md`). Not every lens on everything.
- **Best practices, explained.** `/scope` proposes best practices by default and explains
  why each one exists using the project at hand. If I suggest something that goes against one,
  it has to tell me what goes wrong and the better way; I still make the call.
- **Overplanning gets flagged every time.** The rule is reversibility: slow decisions for
  one-way doors (data model, security model, anything others already use), defaults for
  everything else. Late ideas during a build are said, not discussed; the build skill triages them.
- **Full decision records.** Every real decision is a file in `docs/decisions/` with the options,
  the choice, why, and what it costs. The plan keeps the index. That's the part of a repo that
  shows how someone thinks.
- **Honest grading.** The audit mode grades a scope A to F on a visible rubric, with the three
  fixes first and the evidence named. My global rules ban praise without a reason.
- **State lives in plain files, not in the chat.** Each project gets a `PLAN.md` with my
  original idea in my own words (never overwritten), decisions, open questions and a
  "Where we left off" section, so any new chat can pick it up. Every idea, even a dropped
  one, gets one line in a log.
- **Every session is a version.** Scoping sessions bump the version, add a changelog entry
  with a "Restore this if" line, and tag it in git, so nothing decided is ever lost.
- **Privacy is checked up front,** against the never-view rules I keep in my global
  `~/.claude/CLAUDE.md`.

## Use them

Copy `skills/ideas` and `skills/scope` into `~/.claude/skills/`, then type `/ideas` or
`/scope <project>` in Claude Code. They assume projects live in `~/Projects/<name>/`, the
idea log in `~/Projects/ideas/log.md`, and a private study guide in `~/Projects/ideas/textbook/`
(the scope writes a chapter per project; the textbook itself isn't in this repo). Change the
paths, the greeting and the name to yours.

`skills/scope/evals/` holds the test cases I run against the skill with Claude's skill-creator:
one audits an existing scope, one opens a fresh one. The skills' home repo is private (it holds
my idea log and the textbook), so version notes live in the commit messages here.

## License

MIT
