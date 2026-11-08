# The production bar: what "ready to ship" means here

Every project Mason scopes is scoped as if it ships, because the point of each one is the
portfolio and the resume. "Production-grade" is not one fixed list; it's a bar that scales with
what the project is and who it could hurt. This file is the bar. `project-types.md` says which
items matter most for each kind of project.

The test for every item: **could a stranger reading the repo on GitHub see that it's met,
without running the code?** That's what a hiring manager does. Tests, a README, decision
records, a changelog and a settings file are visible. "It works on Mason's machine" is not.

## The bar

Each item: what it means, why it exists, what it looks like at Mason's scale.

1. **It runs without you.** Starts when the machine starts, restarts when it crashes, doesn't
   need a terminal left open. *Why:* software that needs babysitting isn't shipped, it's
   running. *Here:* a systemd user service (or timer for scheduled jobs) with `Restart=on-failure`;
   for anything that controls the machine, a watchdog as well.

2. **It tells you when it's broken.** Logs with levels (what happened, how bad), errors that
   surface somewhere a human looks, a health check that says alive or not. No secrets or
   personal data in logs. *Why:* the alternative is finding out from the user. *Here:* journald
   via the systemd service, a `/health` route or a `status` command, a health light in any UI.
   Anything the family depends on (CQ, baby-feed) alerts Mason when it's down.

3. **Data is safe.** Automatic backups, and a restore that has actually been tried once. Upgrades
   never lose data: schema changes go through migrations. *Why:* data is the one-way door; code
   can be rewritten, a lost month of a baby's feeds can't. *Here:* the nightly backup pattern
   already used for CQ (and the T7 drive), a documented restore command, migrations as numbered
   files.

4. **Security at the right level.** See `security.md`: pick the level (0 to 3), write the short
   threat model, apply that level's controls. *Why:* the level is what makes the bar fit a
   two-line CLI and a remote control equally. *Here:* most tailnet apps are level 1; anything
   that acts on the machine or touches the kids' data is level 3.

5. **Tests, run automatically.** See `testing.md`. Safety behaviour gets its test written first;
   the tracer path has an end-to-end test; tests run before every save (a git hook or CI), and a
   step that fails them is not saved. *Why:* tests are how agents know they didn't break
   yesterday's work, and the most visible proof of care in a repo. *Here:* the language's standard
   test runner, a `make test` or `npm test` that runs everything, a pre-commit hook.

6. **Someone else can set it up.** A README that covers what it is, install, configure, run,
   update, uninstall, and troubleshoot. A settings file with sensible defaults. Nothing hard-coded
   to Mason's machine (usernames, home paths, ports, device names). A license. *Why:* the
   portfolio reader installs it, or imagines installing it. *Here:* `settings.toml` or `.env`
   with a committed example; an `install` script; the port registered in the README (Mason's
   tailnet ports run 10000 and up).

7. **Versioned and recoverable.** Semantic versions, a CHANGELOG with "Restore this if:", an
   annotated tag per version, never rewritten history. *Why:* every working state is one command
   away. This is already Mason's rule for every tool. *Here:* `vX.Y.Z` tags, `CHANGELOG.md`.

8. **Decisions are written down.** One record per real decision in `docs/decisions/`: context,
   options, choice, why, cost. *Why:* this is how a reader sees how Mason thinks, and how an agent
   three months from now knows why the code is the way it is. *Here:* the template in this
   skill's `assets/`.

9. **Usable on the real device.** For anything with a screen: readable contrast, touch targets
   big enough for thumbs, works in portrait and landscape if it's a phone app, sane behaviour when
   the network drops, keyboard access on desktop. *Why:* accessibility basics are also the basics
   of a UI that works when you're tired, in the car, or holding a baby. *Here:* WCAG AA contrast,
   44 px touch targets, tested on the actual iPhone before a phase is "done".

10. **The one number that matters is measured.** Every project has a number that decides whether
    it's good: tap-to-screen delay for a remote, time-to-first-question for a game, seconds to
    log a feed. Name it in the scope, measure it in phase 1, record it. *Why:* "feels fast" is not
    a portfolio claim; "87 ms on Wi-Fi" is. *Here:* a scorecard file like Full Nelson's.

11. **Cost is known and capped.** What it costs per month (APIs, subscriptions, hardware), and a
    hard stop so a bug can't run up a bill. *Why:* Mason has no income right now and a runaway
    API loop is a real risk with AI features. *Here:* spend limits set at the provider, a
    per-day cap in the app, a cost line in the README.

12. **Privacy is inventoried.** A list of what personal data the project holds, where it lives,
    what (if anything) leaves the machine and to whom. *Why:* the never-view rules in
    `~/.claude/CLAUDE.md` and the kids' data are hard rules, and "I think nothing leaves" is not
    an inventory. *Here:* a short `docs/privacy.md` or a README section.

13. **The repo is clean.** No secrets or personal information in any tracked file or in history.
    A `.gitignore` that covers local config. A secret scan before anything goes public. *Why:*
    one leaked key in history follows the repo forever. *Here:* `gitleaks` or equivalent before
    the first public push; private context in `CLAUDE.local.md`, untracked.

14. **Dependencies are deliberate.** Every outside library has a reason (a decision record for
    anything non-obvious), pinned versions, and a plan for updates. Prefer the standard library.
    *Why:* each dependency is code you didn't write, can't fully read, and must keep updating.
    *Here:* a lockfile committed; a line in the README on how to update.

## Scaling the bar

The bar scales by stakes, not by how much Mason likes the project.

| Size | What it is | Everything above, plus the emphasis |
|---|---|---|
| **Small** | A CLI, a skill, a one-person tool with no network and no personal data | README, tests for the core path, versions, decisions for the non-obvious. Security level 0. Items 1 to 3 may not apply; say so in the scope rather than skipping silently. |
| **Medium** | A tailnet app for Mason or the family; a desktop tool; a scheduled job | All items. Security level 1 (2 if it stores family data). Backups tried. Health visible. Phone-tested. |
| **Large** | Public, installable by strangers, controls the machine, handles others' data or money | All items at full strength. Security level 2 or 3 with a written threat model. Break-it pass. Cross-vendor review. Clean-install test on a fresh machine or VM. Secret scan of history before going public. |

When a project is small, the scope still names every item and says "not applicable because X"
where it isn't. That sentence is itself proof of judgement.

## What usually gets skipped, and why it shouldn't be

- **The restore test.** Everyone has backups; few have restored one. A backup that's never been
  restored is a hope.
- **The README's uninstall section.** It proves the install is understood.
- **The health check.** Cheap to add, and it's the difference between "down for a week" and
  "down for an hour".
- **Running tests automatically.** Tests that must be remembered get forgotten; a hook never
  forgets.
- **The privacy inventory.** It's a ten-minute job and the only way to be sure the hard rules
  hold.
