# Post-cycle note — design vs transition plan (Layer 0)

**When:** After this Layer 0 implementation cycle is finished (tasks complete or explicitly deferred).

**Why:** Some operator-specific “how” (access path, storage layout, concrete paths) is easier to lock in **during design** than to retrofit via generic transition-plan tasks or thin runbook stubs. This file is a **reminder to run a short retrospective**, not a requirement to redesign Layer 0 before closing it.

---

## What to pull out

Use these prompts to decide what should have lived in **pre-implementation design** (or a small design addendum) next time:

1. **Access path** — How does an operator reach the Pi from the machine they use daily (SSH, VPN, LAN-only)? Was that explicit in design, or only while authoring tasks/runbooks?

2. **Storage and paths** — Where backups live, how Compose volumes map to host paths, and what must survive restore. Names and invariants belong in design; runbooks then spell steps.

3. **Operator ergonomics** — Commands, prompts, and failure modes specific to this deployment. Generic requirements text does not replace a short “operator workflow” section in design.

4. **Split of concerns** — **Requirements / ADRs** state what must be true; **design** describes how the stack sits in *your* environment before implementation; **transition plan** orders deliverables; **runbooks** are executable procedures. Note where content drifted (e.g. too much only in task text, too little in design).

---

## Outcome

Optionally add a one-page design addendum or tighten `design-layer-0.md` in a later cycle. Do not block Layer 0 closure on a full rewrite unless maintainers choose to.
