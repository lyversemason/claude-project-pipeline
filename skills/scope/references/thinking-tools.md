# Thinking tools: lenses for problems, and when to stop planning

Mason plans soccer seasons from expertise: he knows what goes in. He doesn't have that yet for
software, so this file is the expertise, written down. Use it in two places: step 2 of the scope
(problems inside the project) and any time a section gets stuck.

## The order of operations

1. **Define the problem** in one paragraph. What's wrong today, for whom, how often. If it can't
   be said plainly, the project isn't ready to scope.
2. **Picture the finish.** What is the user doing on the day it works? Work backwards from there.
3. **Decompose.** List the separate problems inside the project. A phone remote for a desktop is
   really: get a picture to the phone, get touches back, keep strangers out, put the desktop back
   when the phone leaves, install it on another machine. Each is its own problem with its own
   shape.
4. **Pick lenses by shape** (table below), one or two per problem. Not all of them. Running every
   lens on every problem is analysis paralysis and it's the most common way a planner wastes a
   week.
5. **Decide and record.** If two lenses point different ways, both views go into the decision
   record with why one won. If every lens agrees, say so, and name the blind spot they might share.

## Lenses

Each lens: what it is, the question it asks, when it fits, when it doesn't, and its soccer twin
(because that's how Mason already knows it).

**Working backwards.** Start from the finished outcome and ask what must exist for it to be
true, repeatedly, until you reach the first thing to build. Question: *"On the day this works,
what is the user doing? What has to be true for that?"* Fits: deciding what to build at all.
Doesn't fit: problems where the outcome is already obvious. Twin: planning a season from the
cup final backwards.

**Constraints first.** Name what can't move before any solution: privacy rules, no paid
services, Mason's time, the devices he owns. Question: *"What are we not allowed to change?"*
Fits: the start of every scope. Doesn't fit: nothing; it's always cheap. Twin: the players you
actually have.

**Prior art.** How do existing products solve this, and what are they *not* doing? Question:
*"Who has solved this? What did they optimise for, and what did that cost them?"* Fits: anything
other people have built (most things). Doesn't fit: genuinely new combinations, where it
becomes first principles. Twin: scouting the opposition. Mason's Moonlight move (years tuned for
game streaming means years not tuned for text) is prior art plus inversion.

**First principles.** Strip to what must physically be true and rebuild from there. Question:
*"If nothing existed, what would have to happen for this to work?"* Fits: when prior art doesn't
fit or carries assumptions we don't share. Doesn't fit: solved problems; reinventing a web
server is not first principles, it's waste. Twin: coaching a position from how the body moves,
not from drills you were taught.

**Options with tradeoffs.** Write two or three ways to do it, each with what it costs, pick one,
record why. Question: *"What are the real alternatives, and what does each give up?"* Fits: any
decision that's hard to undo. Doesn't fit: cheap, reversible choices; just default those. Twin:
choosing a formation for this opponent. In software the record is an Architecture Decision
Record; Mason keeps full ones in `docs/decisions/`.

**Reversibility (one-way and two-way doors).** Decide fast on anything cheap to undo; decide
slowly on the few things that aren't. Question: *"If this is wrong, what does fixing it cost
in a month?"* Fits: every decision, as a sorter. The one-way doors in Mason's projects are
nearly always: the data model (stored records must be migrated or lost), anything other people
already use (URLs, bookmarks, accounts, message formats), the security model (everything else
assumes it), and the main language or platform. Everything else is a two-way door, including
most "which library" and every tunable number. Twin: a substitution is reversible, a transfer
isn't.

**Inversion.** Instead of asking how to succeed, list what would guarantee failure and avoid
it, or list what won't work until only what might work is left. Question: *"How would we make
sure this fails?"* Fits: stuck problems, risk sections, security. Doesn't fit: as the only lens,
because it finds dangers, not opportunities. Twin: "what loses us this game?" before "what wins
it?". Related: **survivorship bias**, the WWII bomber story (Abraham Wald). The planes that came
back showed where hits were survivable; the armour belonged where the hits weren't. Ask what
evidence you *aren't* seeing because it didn't survive.

**Pre-mortem.** Assume the project failed a year from now, and write the story of why.
Question: *"It's 2027 and this didn't work. What happened?"* Fits: the hard parts and risks
section, once per project. Doesn't fit: repeated use; one honest pass beats five anxious ones.
Twin: the halftime talk you'd give if you were losing.

**Threat modelling.** Inversion applied to security, formally: what's worth protecting, who'd
come for it, how they'd get in, what stops them. Question: *"What's the worst thing someone
could do with this, and how?"* Fits: anything on a network or touching personal data. Details
in `security.md`. Twin: set-piece defending; you plan for the specific attacks you'll face.

**Decomposition.** Break the project into separate problems that can be solved and tested on
their own. Question: *"What are the distinct jobs here, and where does one end and the next
begin?"* Fits: everything; it's the most-used idea in software. Doesn't fit: nothing, but
decomposing too finely makes connection problems. Twin: fitness, technical, tactical, and the
subcategories under each.

**Tracer bullet.** Build the thinnest path from user action to visible result that touches
every layer once, then thicken it. Question: *"What's the smallest thing that proves every
connection works?"* Fits: defining phase 1. Doesn't fit: as a definition of "done"; a tracer
bullet proves the path, it isn't the product. Twin: one rehearsed pattern of play, start to
finish, before the whole game plan.

**Systems thinking (the whole is greater than the sum).** The connections between parts matter
more than the parts. In software the connections are the architecture: how pieces talk, where
data lives, what each piece assumes about the others. Question: *"Where do the parts meet, and
what does each assume about the other?"* Fits: the "how it works" section. Doesn't fit: polishing
a single part. Twin: eleven average players who move as a unit beat eleven stars who don't.

**Bottleneck thinking.** Find the one constraint that limits the whole and fix only that;
improving anything else is wasted until the bottleneck moves. Question: *"What's the one thing
that, until solved, nothing else matters?"* Fits: prioritising risks and phases; the spike in
Full Nelson (video quality) was this. Doesn't fit: once the bottleneck moves, re-ask. Twin: no
point working on finishing if the team can't keep the ball.

**Pareto (80/20).** A fifth of the features carry most of the value. Question: *"Which few
things would the user miss on day one, and which wouldn't they notice?"* Fits: must-haves vs.
Later. Doesn't fit: safety and security, which are not features to trim. Twin: the two set
pieces that score most of the goals.

**Marginal gains.** Once it works, improve every part a little; the total jumps. Question:
*"What's measurably slow, heavy, or clumsy, and by how much?"* Fits: after phase 1 works, with
numbers. Doesn't fit: before anything works; it's how people polish parts of a thing that
doesn't run. Twin: British Cycling. Note the pairing: marginal gains improves the parts, systems
thinking improves the connections. You need both; order matters.

**Explain it back.** If the design can't be explained in plain words, it isn't understood yet.
Question: *"How would Mason explain this to a hiring manager in two minutes?"* Fits: the end of
every section; it's also what the textbook is for. Doesn't fit: nothing. Twin: a player who can
explain the shape can play it.

## Which lenses for which shape

| The problem looks like | Use |
|---|---|
| We don't know what to build | Working backwards, constraints first, prior art |
| We know what, not how | Prior art, first principles, options with tradeoffs |
| What could go wrong | Inversion, pre-mortem, threat modelling |
| It's too big | Decomposition, tracer bullet, bottleneck |
| The pieces don't fit together | Systems thinking, options with tradeoffs |
| It works, make it better | Marginal gains, Pareto, bottleneck |
| We can't choose | Reversibility first (is it even a slow decision?), then options with tradeoffs |
| Everyone agrees too easily | Inversion, survivorship bias, a reviewer from a different vendor |

## Lenses that are traps here

- **Brainstorming for volume.** Produces Later lists, not decisions. Capture the idea in one
  line and move on; triage later.
- **Big design up front.** Deciding everything before building, when half the decisions will be
  wrong anyway. The scope decides phase 1 in detail and later phases in one line each.
- **Designing for scale you don't have.** Facebook's architecture for a family app. The right
  version: *design* the one-way doors (data model, IDs, message formats) so they could hold ten
  times the load; *build* for the load you have.
- **Consensus as proof.** Fifty angles agreeing may share one blind spot.
- **Sunk cost.** "We already decided" is a reason to check the decision record, not a reason to
  keep the decision.
- **Analogy from the wrong domain.** Soccer twins help Mason learn; they don't settle technical
  questions.

## Overplanning: the signals and what to say

Mason has asked to be told when he's overplanning, and why, and what's at risk. Watch for:

- Debating a number that will be tuned with real data (timeouts, speeds, budgets, limits).
- Designing phase 2 or 3 in the detail phase 1 gets.
- Spending time on a two-way door: a choice that could be changed in an afternoon.
- Re-opening a decided section without new information.
- The decisions list growing while the phase 1 definition hasn't changed in an hour.
- New features arriving faster than problems are getting solved (the dopamine of ideas).

When you see one, say it plainly, in this shape: *"This is overplanning. [What's happening.] It
costs you [time / a build that never starts / decisions made without the information the build
would give you]. The move is [default it and mark it tunable / one line in Later / decide when
that phase starts]."* Then let him decide. Don't flag the same thing twice in a session.

The rule behind every flag is **reversibility**: plan ahead for what's expensive to undo (the
one-way doors above, plus the production bar items for data, security and setup) and let
everything else play out and be fixed when it's real. Redoing code with agents is cheap. Redoing
stored data, other people's habits, or a security model is not.

## Late ideas during a build (the pillar problem)

Mason worries about the architect who wants a pillar after the concrete's poured, and about
breaking the builders' focus. The rule, written into every build plan:

- **Always say the idea, immediately, in one sentence.** Never discuss it mid-build.
- The project's XO sorts it with the one-way-door test: does it touch the data model, something
  others already use, the security model, or the core architecture? Then stop and decide now,
  because waiting is what makes it a pillar. Otherwise it goes on the Later list and is triaged at
  the next checkpoint.
- Saying it costs a minute. Not saying it is how pillars end up on poured concrete.
