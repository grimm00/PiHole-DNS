# Research: Safety when colocating (Track D) — file server + Pi-hole (Layer 1 — Usable)

**Status:** 🔴 Not Started  
**Created:** 2026-05-05  
**Exploration topic:** Candidate topic 7 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

How do backup and rollback extend when a file server shares the Pi with Pi-hole, and what safeguards keep household risk bounded (Track D)?

---

## Context

- Layer 0 emphasized conservative rollout and rollback.  
- Adding another service introduces more persistent data, more ports, and more “what if this breaks?” paths.

---

## Topic goals

- [ ] Define backup scope and restore invariants across services.  
- [ ] Define rollback triggers and “safe recovery” steps when DNS or files misbehave.  
- [ ] Ensure the operator can revert without deep re-triage.

---

## Methodology

_Fill during conduct._

**Sources (checklist)**

- [ ] Layer 0 runbooks and backup posture  
- [ ] OurFileServer data persistence and restore story  
- [ ] Household safety constraints and acceptable downtime expectations

---

## Findings

_TBD_

---

## Analysis

_TBD_

---

## Recommendations

_TBD_

---

## Requirements discovered

_TBD_

---

## Next steps

- Run research-conduct for this topic; extract requirements into [`requirements.md`](requirements.md).

