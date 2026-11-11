# The gate: two blind audits before the first line of code

Run on a project whose Status is `SCOPED (gate pending)` (or any SCOPED project Mason asks
about). Fresh chat, never the one that wrote the scope. Cost: about ten minutes of agent time
and one Codex run per round; two rounds at most.

## Why it exists
A scope written over several sessions by one model carries that model's blind spots and its own
inconsistencies (two records describing the same mechanism two ways). Reviewers at build
checkpoints catch these in code, which is the expensive place. Two readers from two vendors, with
no memory of the scoping chat, catch them on paper. "Unanimity isn't proof": if both readers
miss the same thing, at least they missed it independently.

## Round 1
1. Open PLAN.md, the kit and `docs/`. If a report for this plan version already exists
   (`docs/scope-check-<date>-<reader>.md`, dated on or after the last scope commit), reuse it
   instead of re-running that reader.
2. **Claude reader.** A fresh agent (`subagent_type: general-purpose`, `model: fable`,
   `effort: xhigh`) given the skill path and the task `/scope <name> check`, read-only, told to
   write its report to `docs/scope-check-<date>-claude.md` and nothing else. It must not be told
   anything about the scope beyond the project path.
3. **Codex reader.** From the project folder, in the same turn:
   ```
   codex exec -s read-only -C ~/Projects/bigfatboy -m gpt-6-astra -c model_reasoning_effort="xhigh" \
     -o ~/Projects/bigfatboy/docs/scope-check-2026-11-10-codex.md \
     "$(sed 's|<name>|bigfatboy|g; s|<date>|2026-11-10|g' ~/.claude/skills/scope/assets/audit-prompt.md)"
   ```
   (shown filled in for bigfatboy; put the real project name and today's date in all three places)
   Astra at its highest effort (if the CLI refuses `xhigh`, use the highest it accepts and say
   so); `gpt-6.1-sol` if Astra is limited. The prompt file carries the same rubric and checklist
   the Claude reader uses, so the grades compare. Codex reads the references itself (the prompt
   points at them).
4. **Merge.** One list, duplicates joined (say when both readers found it), each item in one bin:
   - **Bin 1, fix now:** a one-way door (data model, security model, anything others use, core
     architecture, the contract) or a hole in a safety path. Also anything private in a tracked
     file.
   - **Bin 2, the build answers it:** needs code or a measurement. Becomes a named step 0
     question, a break-it item, or a safety test, written into PLAN.md sections 10 or 13.
   - **Bin 3, later or declined:** a nit, a taste call, or a finding you disagree with. Goes to
     `## Later` or is declined with one line saying why.
   Write the list to `docs/scope-gate-<date>.md` with the bins and both grades, and show Mason the
   bins on one screen. He may move items between bins. That's his one job in the gate.
5. **Fix pass.** Bin 1 items are scope work: run them as sections (step 3 rules apply), amend the
   decision records (an `## Amended <date>` block; never rewrite), update PLAN.md, update
   AGENTS.md and the project skill if they're affected. Bin 2 items are written into the plan.
   Save as a minor version (step 5).

## Round 2
Same two readers, fresh again, on the fixed plan; reports as `-r2`. Pass = **no bin 1 item open**.
A new bin 1 finding in round 2 is fixed in the same way, once. Then stop, whatever the grade.

## The verdict
Append to `docs/scope-gate-<date>.md`: both grades per round, what was fixed, what went to the
build, what's still open (if anything) and the risk of building with it open. If nothing in bin 1
is open: Status becomes `SCOPED. Ready to build when Mason says build (...)`. If something is:
Status stays `SCOPED (gate pending)` and Mason decides: one more round, or build with the risk
recorded as his decision (a record in `docs/decisions/`, Decided by: Mason).

Then the textbook: the gate's findings go in the chapter's "Mistakes and overplanning caught", and
any new concept (clock skew, process boundary) gets a page. Commit the textbook.

## Rules
- Readers are blind: fresh context, project path only, no summary of the scope and no hints.
- Grades are on the audit rubric in SKILL.md step 8; a reader without the rubric isn't comparable.
- Two rounds, then stop. "Until it gets an A" is a stall machine, and some findings can only be
  settled by the spike.
- Don't rewrite records, don't lower the bar to pass, don't drop a bin 1 item to bin 3 to pass.
- Reports are tracked files. Before writing one, check it quotes nothing private (names of private
  projects, people, claims); describe the finding instead ("a tracked file names private matters").
