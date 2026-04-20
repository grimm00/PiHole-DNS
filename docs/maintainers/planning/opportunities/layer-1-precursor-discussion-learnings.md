# Learnings — Layer 1 precursor (discussion, 2026-04-19)

**Project:** PiHole-DNS  
**Scope:** Post–[reflection](../features/layer-0-foundation/reflections/reflection-post-layer0-v0.1.0-2026-04-19.md) discussion — material that belongs in **opportunities / exploration**, not duplicated in the reflection file  
**Status:** Captured for `/explore layer-1-usable` and Layer 1 design  
**Last updated:** 2026-04-19  

---

## Overview

The [post–v0.1.0 reflection](../features/layer-0-foundation/reflections/reflection-post-layer0-v0.1.0-2026-04-19.md) already records **naming** (apex + subdomains), **reverse proxy**, **TLS**, and **port clarity** (53 vs 80/443). This document holds **adjacent** threads from the same period: **SSH vs application auth**, **recovery when passwords are off**, and **how to structure runbooks vs Layer 1** without inventing unbounded “Layer 0.5.”

---

## SSH: password authentication off — what “fallback” means

**Intent:** Prefer **public-key authentication only** for SSH (`PasswordAuthentication no`), not a second network password as “backup.”

**Replacement for password login (recovery, not online fallback):**

- **Local console** — keyboard/monitor or serial where applicable.
- **Offline recovery** — mount boot media on another machine and fix `authorized_keys` / `sshd_config`.
- **Break-glass key** — spare key pair stored offline; rarely used day-to-day.
- **Multiple `authorized_keys`** — several devices/people so one lost laptop does not lock the house.

**Template / doc implication:** Runbooks and Layer 1 design should list **recovery paths** explicitly when password SSH is disabled; “fallback” is **out-of-band**, not “re-enable passwords on LAN.”

---

## Two surfaces: Pi-hole web UI vs SSH

**Rough distinction:**

- **SSH** — general **operating-system** remote access (shell, often privilege escalation). High ceiling if misused.
- **Pi-hole web UI** — **application-scoped** (DNS/lists/settings), not arbitrary Unix commands.

**Nuance:** The UI is “scoped” but **DNS control is still high impact** on the network (redirects, blocking, visibility). A **strong unique password** (or later tighter controls) for the web UI can coexist with **key-only SSH**; the threat models and ergonomics differ.

**Doc implication:** Avoid conflating “harden SSH” with “Pi-hole admin auth” in a single sentence; cross-link both in operator access sections.

---

## Runbooks vs layers: ad hoc, “0.5,” or Layer 1 as usability story

**Ad hoc runbook edits:** Good for **small, local** fixes (wrong step, one missing command). Weak as the **only** strategy for cross-cutting topics (SSH recovery, naming, TLS story) — risks inconsistent narratives across files.

**“Layer 0.5”:** Only useful as a **tight, time-boxed** polish milestone with a **clear stop**; otherwise it becomes a junk drawer and duplicates what Layer 1 task groups can express.

**Layer 1 as umbrella:** **Usable day-to-day** can include **names, access, proxy/TLS, maintenance, and runbooks** — provided the **implementation plan slices** deliverables (task groups / milestones) so “usability” does not become one undefined blob.

**Suggested direction:** Fold **operator access, security baseline, and runbook alignment** into **Layer 1** with explicit groups; keep **ad hoc** edits for typos and one-off discoveries between planned passes.

---

## Suggested follow-ups

| Follow-up | Where |
|-----------|--------|
| `/explore layer-1-usable` | Themes: SSH baseline + recovery, Pi-hole admin posture, runbook suite under same “operator experience” story |
| Layer 1 design | **Operator access (current vs desired)** + **recovery** when key-only SSH is assumed |
| Runbooks | When touching minimum deploy / SSH, add **recovery** subsection or link once shape is fixed |

---

## Related

- [Reflection post–Layer 0 v0.1.0](../features/layer-0-foundation/reflections/reflection-post-layer0-v0.1.0-2026-04-19.md) — naming, proxy, TLS (primary capture for that slice)
- [Post-cycle design retrospective](../features/layer-0-foundation/notes-post-cycle-design-retrospective.md) — design vs runbook ordering
- [Layer 0 — Foundation learnings](layer-0-foundation-learnings.md) — workflow and tooling from delivery

---

**Last updated:** 2026-04-19
