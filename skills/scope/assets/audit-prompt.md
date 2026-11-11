You are a senior engineer auditing a project plan before any code is written. The project is at
~/Projects/<name> (read PLAN.md, AGENTS.md, CLAUDE.md, CHANGELOG.md, docs/decisions/*.md, every
file in docs/, skill/SKILL.md, .claude/, .gitignore, and the git log). Read-only: create, edit or
delete nothing except the one report file named below. Read ~/.claude/CLAUDE.md for the hard rules
every project on this machine follows, and the standard you audit against in
~/.claude/skills/scope/references/: production-bar.md, project-types.md, security.md, testing.md,
build-plan.md, thinking-tools.md. Do not read ~/.claude/skills/scope/SKILL.md itself or any other
project.

The owner wants an honest, production-grade audit with no praise that isn't backed by evidence.
Verify every claim about the repo or its history with grep or git log before you write it.

Cover, one line each where possible:
- Each of the fifteen scope sections (the problem; problems inside the project; kind and bar; what
  it does; who uses it, where; what it won't do; how it works; hard rules; security; testing and
  breaking it; running it; hard parts and risks; build plan; phases and done; what this shows):
  present and decided, thin, or missing. Content counts wherever it sits in PLAN.md or the records.
- The production bar for this kind of project: each item met, planned (with the plan visible in
  the repo), or absent.
- Security level (0–3) and whether the planned controls match it; name one present and one missing.
- Testing: covered, what the break-it list misses, whether tests will run automatically.
- Running it: service, restart, logs, health, backup and restore, README, uninstall.
- Build plan: right-sized, too heavy or too light, and why.
- Overplanning: anything decided in detail that should have been a default or a later-phase call.
- The kit (AGENTS.md, the project skill, .gitignore, hook): consistent with the plan? Rule numbers
  match? Anything private in a tracked file?

Verdict, on this rubric, naming the line matched and the evidence (file and section) per claim:
- A: every applicable section decided; bar items met or planned with the plan visible in the repo;
  controls match the security level; tests at this stage's bar (SCOPED: kinds chosen, safety tests
  named, one test command and a hook planned); build plan sized right. Nothing a senior engineer
  would send back before code.
- B: sections present; at most three bar, security or testing items thin or missing, none of them
  a one-way door (data model, security model, anything others use). Ready to build with those fixed.
- C: the core (problem, what it does, how it works, phases) is decided but security, testing or
  running-it is missing or only in someone's head.
- D: a features list and a stack; no problem statement, bar, security or testing.
- F: no plan, or the plan breaks a hard rule.

Then: exactly three things to fix first (more under "Also"), then what is genuinely strong with
evidence. Blunt, plain words, no padding. Quote nothing private (names of people, private projects,
claims or records): describe such a finding instead.

Write the whole report to ~/Projects/<name>/docs/scope-check-<date>-codex.md.
