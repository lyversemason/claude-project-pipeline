# Security: levels, a plain-language threat model, and the controls

"Secure" means different things for a file formatter and a phone app that can type on the
desktop. This file turns that into a level, a short written threat model, and a list of
controls per level. The scope's security section uses all three.

## Pick the level

Ask, in order: Can it act on the machine, money, or the kids' data? Can strangers reach it?
Does it hold personal data? Is it on a network at all?

| Level | When | Example |
|---|---|---|
| **0** | Local only, no network, no personal data | A CLI that formats files; a skill that writes a plan |
| **1** | Tailnet only, owner or family, personal data of the household | Most of Mason's apps: RoomFit, Trivia Drive, Contractions |
| **2** | Reachable by strangers, or holds other people's data, or sends on Mason's behalf | A public site with accounts; the Cameron mail desk; CQ (family social data) |
| **3** | Can act on the machine, spend money, or touches children's, legal or medical data | Full Nelson, Hand Signals, Gary (Infinite Campus + school attendance record), family-records apps |

When in doubt, go up a level. Going up costs a few controls; going down costs an incident.

## Write the threat model (ten minutes, plain words)

Four short lists in the scope's security section. This is what security people call threat
modelling; it's inversion applied to one question: how would someone misuse this?

1. **What's worth protecting.** The assets: the kids' data, Mason's accounts, control of the
   desktop, the family's photos, the API keys, Mason's reputation if a public repo leaks.
2. **Who'd come for it.** The actors: a stranger scanning the internet; a stolen or borrowed
   phone; a bug acting as an attacker (the most common one); an agent with too much access;
   a family member tapping the wrong button.
3. **How they'd get in.** Entry points: every route the app answers, every file it reads,
   every command it runs with user input, every outside service it trusts.
4. **What we do about it.** The controls from the level below, mapped to the entry points.

Then one line: **the worst thing that could happen.** If that line is "someone else types on
Mason's desktop" or "a child's school record goes to a third party", the project is level 3,
whatever the earlier answers said.

## Controls by level

Each level includes everything from the levels below.

### Level 0
- No secrets in the repo (there shouldn't be any to leak, but check).
- Input that comes from files or arguments is treated as data, not instructions: no building
  shell commands from it, no `eval`.

### Level 1
- **Identity, not location.** Being on the tailnet is not permission. Check the Tailscale
  identity on every request (the login header behind `tailscale serve`, or the whois API)
  against an allow-list of accounts.
- **HTTPS** everywhere (tailscale serve gives it for free).
- **Secrets in files at mode 600** or a secret store, read at start, never logged, never echoed
  into a chat, never committed. A committed `.env.example` with placeholders.
- **Input validation** on every route and form: type, length, allowed values. Database queries
  are parameterised, never built from strings (this is what SQL injection is).
- **Least privilege:** the service runs as Mason's user, not root; it can reach only the
  folders it needs; it doesn't run as a shell with user input.
- **Backups** encrypted if they leave the machine (the T7 drive is fine; cloud is not, for
  family data, without encryption).
- **Logs without personal data:** who did what, not what they said.
- **Dependencies pinned** and checked for known vulnerabilities before a release.
- **Privacy inventory** (production bar item 12).

### Level 2
- **Authentication by a library or provider**, never home-made: passkeys, OAuth, or a
  well-known library's password hashing (argon2 or bcrypt). Rolling your own is the single most
  common fatal mistake.
- **Sessions** that expire, are revocable, and are bound to HTTPS-only, HttpOnly cookies.
- **Rate limiting** on login, forms, and anything that sends mail or costs money.
- **CSRF protection** on state-changing forms; **CORS** locked to the app's own origin.
- **Security headers:** Content-Security-Policy, X-Content-Type-Options, frame protection,
  Referrer-Policy. (The names matter less than having them; a library sets them in one line.)
- **Upload handling:** size limits, type checks, stored outside the web root, never executed.
- **A way to delete a person's data** on request, and a short privacy note on the page.
- **Dependency scanning automated** (Dependabot or equivalent) and a release checklist.
- **Incident plan, three lines:** how to take it offline, how to rotate every secret, who to
  tell.

### Level 3
- **Verify identity on every single request**, not once at connection; refuse on any doubt
  (fail closed). On a tailnet, identity comes from asking tailscaled who the peer is (`tailscale
  whois`, or the local API), not from trusting an HTTP header: a header is a string anyone on the
  wire can write. "Only the paired phone" needs something only that phone holds (a stored device
  secret from pairing); a passkey proves the person, and Apple syncs passkeys across all the
  person's devices. A "tailnet rule" limiting a port to one device is an ACL policy edit in the
  admin console, with the port and device named; write the exact rule into the scope.
- **The process boundary is not a security boundary.** A 0600 local socket stops other users, not
  another process running as the same user. If "nothing else can inject input" is a rule, say
  what enforces it (peer credentials on the socket, a separate user for the service, or a
  statement that same-user processes are trusted and why).
- **Every time-based rule names its clock.** "Dropped if older than 1 s" needs to say whose
  clock, what happens when the phone's and the desk's disagree, and which way it fails (drop
  everything is safe; let late orders through is not).
- **Allow-lists for actions**, not deny-lists: the set of things the remote side may do is
  enumerated; everything else is refused.
- **Kill switch** reachable without the thing that's broken.
- **Audit log** of every action taken: who, what, when, from where. No content.
- **Stale or replayed commands are dropped:** sequence numbers and send times on every order;
  late orders never fire.
- **No recording** of screen, camera or mic content unless that is the explicit purpose, under
  the never-view rules.
- **Separation of the dangerous part:** the piece that can act on the machine is as small as
  possible, with its own tests, and nothing else runs with its permissions.
- **Written threat model** reviewed by a second model (the cross-vendor reviewer) before phase 1
  is "done".
- **`/security-review`** at every checkpoint, and a **break-it pass** aimed at the controls above
  before launch.
- **Children's, legal and medical data** never leaves the machine, never goes to a model provider
  without an explicit, recorded decision by Mason, and is never linked to another app (the rule that
  keeps family records out of the social app).

## Common mistakes, in plain language

These are the usual ways small apps get hurt (the industry's list is called the OWASP Top Ten).
Check each against the project's entry points.

- **Injection:** user text ends up inside a command or query. Fix: parameterised queries, no
  shell from user input.
- **Broken access control:** the check happens on the login page but not on the data routes.
  Fix: check identity and permission on every route, in one shared place.
- **Secrets in the repo or logs.** Fix: files at 600, a secret scan, never log request bodies.
- **Trusting the client:** the phone says "I'm the owner" and the server believes it. Fix: the
  server checks identity itself.
- **No rate limit:** a script tries a million passwords, or a bug sends a thousand emails. Fix:
  limits on anything that costs or risks.
- **Old dependencies with known holes.** Fix: pin, scan, update on a schedule.
- **Too much permission:** the service runs as root or can read the whole home folder. Fix:
  least privilege.
- **Verbose errors:** stack traces shown to users leak paths and versions. Fix: plain errors
  outside, detail in logs.
- **Unsafe uploads and file paths:** `../../etc/passwd`. Fix: validate names, store by generated
  id.
- **Actions without confirmation or undo** for irreversible things (delete, send, pay). Fix:
  confirm, soft-delete, test mode.

## Data classes (for the privacy inventory)

- **Public:** fine on GitHub.
- **Personal:** Mason's own info, schedules, goals. Stays on the machine or encrypted off it.
- **Private, hard rule:** children, custody, legal, medical, desk recordings, anything a memory
  file marks PRIVATE. Never leaves the machine, never to a model provider without a recorded
  decision, never linked across apps.

The scope names which classes the project holds and where each lives.
