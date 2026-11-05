---
name: ideas
description: Talk through a new idea with Mason and find out if it's worth becoming a project. Use when the user types /ideas, says "I have an idea", "what do you think of this idea", or wants to bounce around a possible new project, app, tool or plugin. Stage 1 only (idea → project or not); scoping a project that already exists is /scope.
---

# Ideas

Stage 1 of Mason's project pipeline: **idea → is it worth anything → project or not.**
Stage 2 (writing the scope) is the `/scope` skill. Don't do scope work here.

Files:
- `~/Projects/ideas/log.md`: one line for every idea talked through, with its outcome.
- New projects go in `~/Projects/<name>/` (see "If it's a project").

## 1. Open

If Mason typed only `/ideas`, say exactly: **"Hey Mason, what's your idea?"** and wait.
If he already said the idea (`/ideas a thing that...`), skip the greeting and start talking about it.

Before you answer the idea itself, quietly check `log.md` and `ls ~/Projects` for something
similar. If there is a match, say so in one line ("You talked about something close to this on
2026-10-31: Hand Signals, it's a project in ~/Projects/hand-signals.") and ask whether this is
that one or a new one.

## 2. Talk it through (Mason leads)

Mason usually starts by asking questions and steering you toward where he's going. That's how
he finds out what he thinks.

- **Follow his lead.** Answer the question he asked, straight and short, then let him steer.
  Don't jump ahead to features, tech stacks, phases or building.
- Ask at most one or two questions at a time, only when you need them to understand the idea.
- Explain technical concepts in plain language (he's not a hand-coder; Army analogies land).
- Say what you actually think. If part of it is a bad idea, say so and why.
- No files, no folders, no code during this part.

## 3. Viability check

When the idea has a clear shape (or Mason asks "is this worth it?"), give an honest take,
short, on whatever applies:

- **Does it already exist?** Search the web if it might. If a free or cheap thing already does
  it well, say so plainly; using it may beat building it.
- **Can we build it here?** His setup: Omarchy desktop (always on), Tailscale for phone access,
  agents doing the build work.
- **Cost:** paid APIs, subscriptions, hardware.
- **The hard part:** the one thing most likely to sink it.
- **Rules it bumps into:** privacy (the never-view rules in ~/.claude/CLAUDE.md), private
  family/legal matters, anything his memory files mark as off limits.
- **Worth it?** Your verdict in one or two sentences: build it, park it, or drop it, and why.

Then let Mason decide.

## 4. Mason decides: drop, park, or project

Only Mason makes the call. Never create a project folder because the talk went well; wait until
he says it's a project ("yeah, I want to work on this", "make it a project").

### Drop or park

Add one line to the top of the list in `~/Projects/ideas/log.md` (format is in the file),
then commit it: `git -C ~/Projects/ideas commit -am "log: <short name> (<outcome>)"`.
That's all. No folder, no memory entry. Tell him in one line that it's logged.

- **Dropped:** not worth it.
- **Parked:** maybe later. Note what would bring it back ("when Mason has a job", "if X gets cheaper").

If Mason just wanders off the idea without deciding, ask once: "Drop it, park it, or keep going?"

### If it's a project

1. **Name:** suggest a short folder name (lowercase-with-dashes) and a display name; Mason confirms.
2. **Create `~/Projects/<name>/`** with:
   - `PLAN.md`:
     ```
     # <Display Name> — plan

     Status: IDEA. Scope not written yet (next: /scope <name>). No code until Mason says build.

     ## The idea (Mason, <date>)
     <the idea in Mason's own words and terms, as close to how he said it as you can>

     ## What we figured out
     <the viability check: exists already?, how it could work (Claude's proposal, not decided),
     cost, the hard part, rules it bumps into>

     ## Open questions
     <numbered list of what's still undecided>

     ## Where we left off (<date>)
     Idea captured with /ideas. Next: /scope <name>.
     ```
   - `CHANGELOG.md` with a `<!-- NEXT VERSION GOES HERE -->` line and a
     `## v0.1.0 — <date> — Idea captured` entry (what was captured, "Restore this if:").
   - `git init`, commit `v0.1.0: capture <Display Name> idea`, annotated tag `v0.1.0`.
3. **Log it:** add the line to `log.md` with outcome `project → ~/Projects/<name>`, and commit.
4. **Memory:** add a project memory file and a `MEMORY.md` line, like the other planning projects:
   `- [<Display Name>](<name>.md) — IDEA: <one line>; ~/Projects/<name> v0.1.0 (<date>); next = /scope; resume from PLAN.md "Where we left off"`
5. **Hand off:** ask "Want to start the scope now, or leave it for another day?" If now, load the
   `scope` skill and continue in this chat. If later, tell him: `/scope <name>` picks it up.

## Don't

- Don't write scope, features lists, phases or code here.
- Don't create folders or memory for dropped or parked ideas (the log line is enough).
- Don't decide for him. Give your honest verdict, then he picks.
