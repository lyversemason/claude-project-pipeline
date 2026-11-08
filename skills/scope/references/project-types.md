# Project types: what each kind needs, and what goes wrong with it

A phone app for the family, a public website, a desktop plugin and an agent skill all need
different things, the way a youth team and a professional team need different seasons. Pick
the kind (often two) in step 3 of the scope, and let it drive the production bar, the security
level, the tests and the build plan. Examples are Mason's own projects so he can see the pattern.

Every kind gets the full bar in `production-bar.md`. This file is what's *extra* or *emphasised*
for each, and what usually breaks.

## Tailnet web app (phone or desktop browser)

*Examples:* CQ, Trivia Drive, baby-feed, RoomFit, MobileScan, Contractions, Desk Cam remote.

- **Access:** who is allowed in is decided by Tailscale identity (the `Tailscale-User-Login`
  header behind `tailscale serve`, or the whois API), not by "it's on the tailnet so it's fine".
  Family apps list the allowed accounts; owner-only apps allow one.
- **HTTPS** via `tailscale serve`, because Home Screen web apps and camera/mic access need it.
- **Home Screen install:** a web manifest, icons, a one-screen "Add to Home Screen" guide.
  Full-screen mode changes how gestures and the keyboard behave; test on the real phone.
- **Phone reality:** portrait and landscape, the keyboard covering half the screen, the phone
  locking mid-task, a dropped connection in the car. Each gets a planned behaviour.
- **Data:** a local database (SQLite is the default here) with nightly backup and a restore
  command. Family data (kids, health, feeds) never leaves the machine.
- **A port** in Mason's registry (10000 and up), written in the README.
- **Runs as** a systemd user service on the always-on desktop.
- *Usually breaks:* the iOS keyboard pushing the layout around; a second family member's account
  not being allowed; a backup that was never restored; the mic stopping when the phone locks.
- *Security level:* 1 for Mason-only, 2 if it stores family data, 3 if it acts on the machine.

## Public web app or static site

*Examples:* SoccerSessions, OfferLadder.

- **No secrets in anything the browser downloads.** If it needs a key, it needs a server.
- **Hosting** chosen and written down (GitHub Pages for static; the hosting decision is a
  one-way door for URLs people bookmark).
- **Accessibility** to WCAG AA: it's public, and it's what reviewers check first.
- **Dependencies:** pinned, scanned for known vulnerabilities (Dependabot or equivalent).
- **If there's a backend:** authentication (never home-made password storage; use a library
  or a provider), rate limiting, input validation on every route, CSRF protection, security
  headers, logs without personal data, a way to delete a user's data.
- **No tracking** by default; if analytics, say so on the page.
- *Usually breaks:* a demo database exposed to the internet; forms with no rate limit; a key
  committed "just for testing"; mobile layout never checked.
- *Security level:* 1 for static with no user data; 2 the moment it has accounts or stores
  anything from strangers.

## Desktop tool or Omarchy plugin

*Examples:* desk-mic, voice-memo, classic-united screensaver, the status line, claude-announce.

- **Installs alongside Omarchy and uninstalls cleanly.** Never edits Omarchy's own files; adds
  its own, and the uninstall removes exactly those.
- **Keybindings** registered the Omarchy way, with descriptions (they show up in tools like
  Full Nelson's palette).
- **Survives updates:** Hyprland and Omarchy change; the tool checks what it depends on at start
  and fails with a clear message, not a silent death.
- **Settings file** with defaults; no hard-coded paths or monitor names.
- **Privacy:** if it touches the webcam, mic or screen, the never-view rules apply to agents
  testing it; write how.
- **Added to** `~/Projects/omarchy-setup` (tools.txt) once installable, so the desktop migration
  rebuilds it.
- *Usually breaks:* a Hyprland version bump changing a command's output; the tool assuming one
  monitor; audio tests playing through the desk TV (tests must be muted).
- *Security level:* 0 or 1; 3 if it can be triggered remotely or acts on input from outside.

## CLI tool or agent skill

*Examples:* /ideas, /scope, /jobs-mason, Handicapped George, Gary's `gary` command.

- **Help text and exit codes:** `--help` says what it does; non-zero exit on failure so agents
  and scripts can tell.
- **Idempotent** where possible: running it twice does no harm.
- **Config file** over flags for anything that persists; flags for one-off overrides.
- **For skills:** the description decides whether it triggers, so it's written for triggering
  (pushy, with the phrases Mason uses); test prompts in `evals/`; references for knowledge the
  agent won't have; a workspace for test runs that never touches real data.
- **Versioned** like everything else, even though "it's just a markdown file".
- *Usually breaks:* the skill not triggering; a skill that writes to real files during a test;
  a CLI that prints success after failing.
- *Security level:* 0, unless it reads secrets (then: files at mode 600, never echoed, never
  copied into chat).

## Background service or scheduled job

*Examples:* Gary's daily Infinite Campus read, the nightly CQ backup, the Cameron Jobs mail
desk, Classic United's daily download.

- **A scheduler that survives reboots:** systemd timers, not a terminal with a `while` loop.
- **Idempotent and resumable:** if it dies halfway, the next run finishes the job without
  doubling anything (sending an email twice is the classic failure).
- **Retries with backoff** for network calls, and a stop after N failures that alerts Mason.
- **A test mode** that does everything except the irreversible step (send, delete, pay), and
  a dry-run flag.
- **Secrets** (Gmail app password, API keys) in files at mode 600 or a secret store, never in
  the repo or the unit file.
- **Rate limits and politeness** toward anything external (sites, APIs): it runs unattended, so
  a bug runs unattended too.
- **Logs** that answer "did it run last night and what did it do?" in one command.
- *Usually breaks:* the job silently not running for two weeks; a duplicate send; a changed
  website layout breaking a scraper with no alert.
- *Security level:* 1; 2 if it sends anything on Mason's behalf or handles others' data.

## Data pipeline or scraper

*Examples:* the job-search scans (Common Crawl, boards, feeds).

- **Provenance:** every record knows where and when it came from.
- **Dedupe** by a stable key, not by "looks the same".
- **Schema written down** and versioned; raw data kept separately from cleaned data so
  cleaning can be redone.
- **Resumable** from the last good point; long runs checkpoint.
- **Polite:** rate limits, a real user agent, respect for robots rules where they apply.
- *Usually breaks:* a source changing shape; duplicates; losing a week's run to one crash.
- *Security level:* 0 or 1, unless personal data is collected (then 2 and a privacy inventory).

## Game

*Examples:* Arcade Soccer, Trivia Drive.

- **Save state** that survives a crash and an update.
- **Input latency** measured (the one number); audio and video tests run muted.
- **Content pipeline:** questions, sprites, sounds live as data, versioned, with a check that
  rejects malformed content before it ships.
- **Fairness and repetition rules** (no repeated question per player) are tested, not hoped.
- *Usually breaks:* a content file edit crashing the game at load; a save format change losing
  progress; a sound test blasting the desk TV.
- *Security level:* 0 or 1.

## AI-powered app or agent

*Examples:* Gary, Handicapped George, the Trivia Drive host, Cameron's mail desk screeners.

- **Model choice with a fallback**, written down: which model, which effort, what happens when
  usage runs out or the provider is down.
- **Cost cap** per day and per run, enforced in code, plus the provider's spend limit.
- **Prompts are files**, versioned, not strings buried in code. A change to a prompt is a
  version.
- **An eval set:** a handful of inputs with expected outputs, run before a prompt change ships.
- **Timeouts and retries**, and a plan for a wrong or made-up answer (where a human checks,
  what's never automated).
- **Personal data in prompts:** what's sent to the provider is inventoried. Family data, the
  kids, legal and medical matters: decide explicitly and write it down.
- *Usually breaks:* a loop that burns a day's budget in an hour; a prompt edit that silently
  changes behaviour; a transcription of something that should never have been sent.
- *Security level:* 1 minimum; 2 or 3 depending on what data goes to the provider and what the
  agent can do (send mail, change files, act on the desktop).

## Remote control or device access

*Examples:* Full Nelson, Desk Cam remote, Hand Signals, the phone buttons for desk-mic.

- **Owner-only, verified every request**, not once at login.
- **Fail closed:** if identity can't be checked, refuse. If the connection drops, stop acting.
- **Kill switch** reachable without the thing that's broken (a desktop shortcut, a physical key).
- **Safety nets that always win:** put everything back, drop stale commands, never act late.
- **Never records** what it sees or hears unless that's the explicit purpose, and then under the
  never-view rules.
- **Audit trail** of what was done from where, without recording content.
- **Break-it pass before launch** and cross-vendor review; this kind is the biggest target.
- *Usually breaks:* a queued command firing after lag; the "who's connected" check only at
  startup; an agent testing it while the owner is using the desk.
- *Security level:* 3, always.

## When a project is two kinds

Most are. Full Nelson is a tailnet web app and a remote control; Gary is an AI agent and a
background service and a tailnet app. Take the union of the extras and the **highest** security
level among them. Say in the scope which kind drives which section.
