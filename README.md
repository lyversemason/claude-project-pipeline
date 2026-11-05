# Claude project pipeline: /ideas and /scope

Two [Claude Code skills](https://code.claude.com/docs/en/skills) I use to take a
new idea from "is this even worth building?" to a scope that's ready to build. I designed the
workflow and the rules; Claude Code wrote the skill files under my direction. They're the
actual files I run, with my name and paths left in.

- **`/ideas`** (stage 1): talk an idea through, get an honest viability check, then decide:
  drop it, park it, or make it a project.
- **`/scope`** (stage 2): work out what a project will and won't do, one section at a time,
  until it's ready to build.

Neither skill writes code. Building is a separate step I start myself.

## Why two stages

The usual way an AI-assisted project goes wrong is building too early: a good conversation
turns into folders and code before anyone asked whether the thing should exist. Splitting the
work keeps each step honest:

1. `/ideas` only answers "is it worth it?" Does something free already do it? What will it
   cost? What's the one hard part most likely to sink it? Does it bump into a privacy rule?
   Claude gives a verdict (build, park or drop) and I make the call.
2. `/scope` only answers "what exactly is it?" Must-haves vs. later, who uses it and where,
   what it won't do, the moving parts, hard rules, risks, phases, and what "done" looks like
   for phase 1.

## Design choices

- **I decide; the agent advises.** The skill never creates a project because the talk went
  well. It waits until I say "make it a project", and it never marks a proposal as decided
  until I agree.
- **Follow my lead.** I think out loud by asking questions, so the skill answers what I asked,
  briefly, asks at most one or two questions at a time and doesn't jump ahead to tech stacks.
- **Honest verdicts.** If an idea is bad, or already exists, it says so and why.
- **Best practices, explained.** `/scope` proposes best coding practices by default and explains
  why each one exists using the project at hand. If I suggest something that goes against one,
  it has to tell me what goes wrong and the better way; I still make the call.
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
`/scope <project>` in Claude Code. They assume projects live in `~/Projects/<name>/` and the
idea log in `~/Projects/ideas/log.md`; change the paths, the greeting and the name to yours.

## License

MIT
