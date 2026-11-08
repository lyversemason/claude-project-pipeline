# Decision records

One file per real decision, so anyone (person or agent, now or in a year) can see what was chosen,
what else was on the table, and why. These records are also the clearest view of how this project
was thought through: a reader who never runs the code can follow the reasoning here.

Name them `NNNN-short-name.md`, numbered in order. Copy `0000-template.md`.

- Decisions the owner makes (what the user sees or does, money, privacy and security, anything hard
  to undo) are marked **Owner approved** with the date.
- Small agent decisions (inside-the-code "how", easy to change) are marked **Agent decision** and
  listed in the next checkpoint report so the owner can veto.
- A decision that replaces an older one says so (`Replaced by NNNN`) in the old file; nothing is
  deleted.

`PLAN.md → Decisions` is the index: one line per record.
