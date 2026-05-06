# Research: Upstream parity (Track A) — OurFileServer + GitOps-lite (Layer 1 — Usable)

**Status:** 🔴 Not Started  
**Created:** 2026-05-05  
**Exploration topic:** Candidate topic 6 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

How should image/env/volume and GitOps-lite habits match existing OurFileServer patterns while honoring this repo’s Layer 0 image pinning/digest policy (Track A)?

---

## Context

- Track A emphasizes “repo as source of truth,” avoiding SSH drift, and pinning images by digest/date tag.  
- OurFileServer’s existing deployment habits matter to reduce cognitive load and avoid needless divergence.

---

## Topic goals

- [ ] Identify any conventions that should be shared across services in this stack.  
- [ ] Decide how image pinning updates should be executed and documented for Layer 1.  
- [ ] Define how secrets/env flow should work across both services.

---

## Methodology

_Fill during conduct._

**Sources (checklist)**

- [ ] OurFileServer repo docs / Compose patterns  
- [ ] This repo’s Layer 0 minimum deploy + digest pin runbook  
- [ ] Any tooling decisions that reduce operator effort (without overbuilding)

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

