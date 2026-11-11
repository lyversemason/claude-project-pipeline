# Testing: what kinds, how much, and the break-it pass

Mason is all about testing and redundancy, and would rather overspend on breaking things than
underspend. That instinct is right; the job of this file is to aim it. Tests cost build time
and every one of them has to earn its place by catching something real.

## Why tests matter more with agents

A human programmer remembers what they built last week. A fresh builder agent doesn't; it has
the files and the tests. Tests are how an agent knows it didn't break yesterday's work, and the
only check that doesn't depend on anyone's memory. They are also the most visible proof of care
in a public repo.

## The kinds, in plain language

Picture a pyramid: many small fast tests at the bottom, a few slow whole-system tests at the top.

1. **Unit tests** (the parts). One function, one behaviour, milliseconds. "Given this input, this
   output." Lots of them; they run on every save.
2. **Integration tests** (the connections). Two parts talking: the app and its database, the
   phone message and the desktop handler, the service and Hyprland. Fewer, slower. This is where
   the expensive bugs live, so this layer gets more attention than its count suggests.
3. **End-to-end tests** (the whole). The tracer path from user action to visible result, run
   against the real thing or a faithful stand-in (a desktop browser pretending to be a phone).
   A handful. One for the phase 1 "done" path at minimum.
4. **Contract tests.** When two sides exchange messages (phone and desktop, app and API), the
   message list is written down and both sides are tested against the same list. Catches the
   "I changed the field name" bug.
5. **Safety tests, written first.** For anything that must never happen (the wrong user gets in,
   a stale command fires, data is lost on upgrade, the screen is recorded), the test exists before
   the code. Writing it first forces the behaviour to be defined, and makes it impossible to
   forget.
6. **Regression tests.** Every bug that's found becomes a test, so it can't come back. This is
   how the break-it pass turns into permanent value.
7. **Performance measurements.** The one number that matters, measured by a script, recorded in a
   scorecard, compared to a target. Not a test that passes or fails every time, but a number that
   must not drift.
8. **Real-device checks ("test like you fly").** A checklist Mason runs by hand on the actual
   phone, car, or TV at each checkpoint: things no emulator can prove (the iPhone keyboard, cell
   signal, Bluetooth in the car). Written as numbered steps with the expected result.

## What each kind of project needs

| Kind | Emphasis |
|---|---|
| Tailnet web app | Integration (app ↔ database), end-to-end on the tracer path, phone checklist, backup restore test |
| Public web app | All of the above plus security tests (wrong user, rate limit, injection strings), accessibility checks, dependency scan |
| Desktop tool / plugin | Integration with Hyprland commands, "survives a reboot" check, uninstall leaves nothing, muted audio |
| CLI / skill | Unit tests on the core, eval prompts for skills, a sandbox so tests never touch real files |
| Background job | Idempotency (run twice, nothing doubles), resume-after-crash, test mode that stops before the irreversible step |
| Data pipeline | Dedupe, schema validation, resume from checkpoint, a known-good sample compared byte for byte |
| Game | Save/load round-trip, content validation, repetition rules, latency measurement, muted audio |
| AI-powered | Eval set before every prompt change, cost cap test (the loop stops), timeout and bad-answer handling |
| Remote control | Safety tests first and most; contract tests; stale-command tests; owner-only on every route; full break-it pass |

## The break-it pass (the breaker's job)

Mason would be good at this job, and in the build plan it's a role: a fresh agent whose only
task is to break the thing, at every checkpoint, and fully before launch. Aim it by risk: break
the login before the colour picker. Every break found becomes a regression test.

The list, by category. Pick what applies to the project and write it into the scope so the
breaker has a target:

- **Bad input:** empty, huge, negative, wrong type, Unicode and emoji, quotes and semicolons,
  `../` in a filename, a 10 MB string in a name field.
- **Bad timing:** two users at once; the same button tapped twice fast; a command arriving after
  the thing it refers to is gone; the clock wrong; a request during a restart.
- **Bad network:** connection dropped mid-action; very slow; the server down and coming back;
  Tailscale restarting; the phone switching Wi-Fi to cell.
- **Bad state:** the database missing, read-only, or from the previous version; a half-finished
  upgrade; the settings file corrupt; the disk full.
- **Bad actor:** a different Tailscale account; no identity header at all; a forged header; a
  replayed command; a request to a route that shouldn't exist.
- **Bad luck:** the process killed mid-write; the machine rebooted mid-task; the backup
  destination unplugged; the process frozen, not killed (`SIGSTOP`), so its watchdog sees nothing;
  a failure halfway through a multi-step change (the second of three steps fails); the state
  file unwritable (disk full, read-only) right when the safety net needs it; a screen, device or
  mount that was there at start-up gone.
- **Bad human:** the phone locked mid-recording; the app closed and reopened; the browser's back
  button; rotating the phone mid-drag.

For level 3 projects, add: **does every safety net still win** after each of the above?

## Redundancy: where it pays and where it's waste

Redundancy pays for anything irreversible or safety-related: a snapshot fallback when video
fails, a watchdog on the service, a second copy of the backup, "fail closed" on identity.

It's waste when it duplicates a check that can't fail differently (two tests of the same
function), or when it protects something cheap to redo. Mason's rule of thumb: double-check
anything that touches data, security or the user's safety; single-check the rest and let the
regression tests grow as bugs are found.

## Automation: tests run themselves

- A single command runs everything (`make test`, `npm test`, `go test ./...`).
- A git pre-commit hook (or CI) runs it; a step that fails tests is not saved. This is in every
  AGENTS.md this skill generates.
- Style robots (linters, formatters, type checkers) run with the tests. They're not AI; they're
  rule-checkers, and they catch the bloat and slop Mason worries about.
- Browser and audio tests run muted (the desk TV rule). Real-device checks are a checklist,
  not automated.
- Tests never touch real data. Each project names its sandbox (a test database, a test folder,
  a `test_mode` flag) in the scope.

## When is enough?

Stop adding tests for a step when: the safety behaviour is covered first-to-last; the tracer
path has an end-to-end test; each connection has an integration test; and the break-it list for
this step has been run. Don't chase a coverage percentage; chase the list. A hundred unit tests
on a part and none on its connections is the common way to feel safe and not be.
