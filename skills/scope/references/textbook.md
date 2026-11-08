# The textbook: how the study guide is written

Mason builds fast with agents and the knowledge doesn't stick the way it would if he'd typed
every line and run every search. The textbook is the fix: a structured study guide at
`~/Projects/ideas/textbook/` that every /scope session adds to, so he can go back, read, and
walk into an interview able to explain how and why he designed what he built.

It is private (the ideas repo has no public remote; the public copy of the skills never includes
it). It's written for Mason to read, in plain words, not for an agent to parse.

## Layout

```
textbook/
├── README.md            index: chapters, concepts, glossary, how to read it
├── chapters/
│   └── <project>.md     one per project, sections mirror the scope
├── concepts/
│   └── <concept>.md     one per idea, with every project it appeared in
└── glossary.md          terms, one line each, pointing at concept pages and chapters
```

## When to write

After a section is **decided**, not during the conversation. The talk stays about decisions;
the notes come after, in the same commit as the PLAN.md change. At the end of a session, make
sure the chapter has everything decided that day. The chapter's "What I'd say in an interview"
section is written when the scope is done, and updated at build checkpoints if the project
skill is asked to.

## The chapter (one per project)

```markdown
# <Project>: how it was scoped

Started: <date>. Status: <PLANNING | SCOPED | BUILDING | SHIPPED>.
Kind: <project kinds>. Security level: <n>. Size: <small | medium | large>.

## The problem, in one paragraph
## Problems inside the project
<each problem: its shape, the lens used, what the lens showed>
## What it does and doesn't, and why
## How it works
<the moving parts and the connections, as Mason would draw them on a whiteboard>
## Security
<the level, the threat model in four lines, the controls and why each>
## Testing
<what's tested how, and the break-it list>
## Decisions and why
<the ones worth remembering, with the reasoning; link to docs/decisions/ for the rest>
## Where a lens disagreed with another
<rare, valuable: what pointed which way, what won, why>
## Practices learned here
<each: the practice, why it exists, how it applied to this project; link to concepts/>
## Mistakes and overplanning caught
<what was flagged, what it would have cost, what was done instead>
## What I'd say in an interview
<two or three paragraphs in Mason's voice: the problem, the design, the hard call, the result>
```

Keep every entry short. Notes, not essays. A chapter is something Mason reads in fifteen minutes
the night before an interview.

## Concept pages (one per idea)

A concept is any practice, lens, pattern or term that came up: *fail closed*, *tracer bullet*,
*idempotent*, *threat model*, *systemd user service*, *one-way door*. Create the page the first
time it's used; add to it every time after.

```markdown
# <Concept>

**In one line:** <what it is>
**Why it exists:** <the problem it prevents, plain words>
**How to spot when it's needed:** <the signal>
**Soccer twin** (if there's a good one): <...>

## Where it showed up
- <project> (<date>): <how it applied, one or two lines> → chapters/<project>.md
- <project> (<date>): ...

## How I'd explain it
<two or three sentences in Mason's voice>
```

The "where it showed up" list is the point: when a concept has four entries, Mason knows it's
core, and he has four worked examples of it from his own projects.

## Glossary

One line per term, alphabetical: `**term**: plain definition → concepts/<page>.md (used in:
<project>, <project>)`. Add a term the first time it's used in a scope. If a term has a
concept page, the glossary line points at it; if it's just a word (JSON, systemd, WebSocket), the
line is the whole entry.

## Writing rules

- Plain words first, the technical term second, in bold, so he learns the vocabulary without
  being stopped by it: "the service restarts itself when it crashes (a **watchdog**)".
- Every "what" has a "why". A note that says what was done without why is a changelog, not a
  textbook.
- Use Mason's own projects as the examples, and soccer when it genuinely helps.
- Never praise. The textbook records what was learned, including what was flagged.
- The "explain it back" test: if the interview paragraph couldn't be said out loud in two
  minutes, shorten it.

## README.md

Keep the index current: a table of chapters (project, status, date), the concept list with the
count of projects each appears in (sorted by count, so the recurring ones rise), and a link to
the glossary. Regenerate the counts when a concept page changes.
