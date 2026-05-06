# Research: Compose stack — OurFileServer (Layer 1 — Usable)

**Status:** 🔴 Not Started  
**Created:** 2026-05-05  
**Exploration topic:** Candidate topic 5 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

How should OurFileServer (or equivalent) be colocated beside Pi-hole in the same Compose stack (networking, volumes, ordering), and what ordering (DNS-first vs full stack merge) best manages blast radius and rollback?

---

## Context

- Roadmap Layer 1 outcome includes a file server in the same stack.  
- Colocating services introduces new failure modes and port/proxy conflicts.

---

## Topic goals

- [ ] Identify the minimal “same stack” integration approach.  
- [ ] Decide staging/ordering for delivery (names first vs stack merge).  
- [ ] Enumerate key colocation risks (resources, port conflicts, rollback).

---

## Methodology

_Fill during conduct._

**Sources (checklist)**

- [ ] Existing OurFileServer deployment habits and docs  
- [ ] Docker Compose colocation patterns on Raspberry Pi  
- [ ] This repo’s rollback and backup posture from Layer 0

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

