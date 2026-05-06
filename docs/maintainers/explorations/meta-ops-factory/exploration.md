# Exploration: Meta — Ops Factory

**Status:** 🟡 Themes captured — research pending  
**Created:** 2026-05-05  

---

## What we’re exploring

Treat **operator experience** as a maintained “product,” where:

- `docs/runbooks/` are the **shipped interface** you execute under stress
- maintainer docs define the **factory** that produces those runbooks (cadence, templates, invariants, verification)

This is meta work: it should reduce cognitive load and prevent “truth in five places,” especially as the stack grows beyond Pi-hole.

---

## Scope

**In scope**

- A **maintenance cadence** that increases engagement without increasing babysitting.
- A **runbook contract** (what every runbook must state) so operator docs stay consistent.
- An **operator model** for this homelab: access, discovery, storage/persistence, backup/restore, and break-glass paths.
- Repo structure conventions that keep the above easy to find and update.

**Out of scope**

- Adding new runtime capabilities to Pi-hole DNS (belongs in vertical layers, e.g. Layer 1).
- Observability stack design (Layer 2+), except where it intersects with “what do I check weekly/monthly?”

---

## Themes

### Theme 1: Runbooks as product; meta as factory

- Runbooks are the “UI” for operators: they must be executable, low-ambiguity, and resilient to context loss.
- Meta work defines a **production line**: templates, contracts, and review discipline that keep runbooks correct.
- Avoid “truth in two places”: meta artifacts should specify invariants and link out; runbooks carry procedures.

### Theme 2: Maintenance cadence as engagement without babysitting

- Cadence creates a controlled update window (reduces surprise breakage, increases confidence).
- “DNS-first appliance” posture: default to low-touch; engage intentionally on a schedule.
- Cadence should align with safety constraints (Track D): backups before updates, fast rollback.

### Theme 3: Operator model (access, discovery, storage)

Grounded in the Layer 0 retrospective prompts:

- **Access path**: SSH posture vs web UI surface; break-glass recovery when passwords are off.
- **Discovery ladder**: name/reservation → router → scan/analyzer → break-glass.
- **Storage and paths**: what is persistent (host bind mounts / volumes), where backups live, restore invariants.

### Theme 4: Repo conventions that support the factory

- Keep “maintainer surfaces” coherent: explorations/research/decisions/planning/runbooks.
- Skills/commands should match the repo’s directory shape (avoid tools that assume `admin/services/...` when the repo uses `docs/maintainers/...`).
- Prefer small, linkable docs over sprawling omnibus pages.

---

## Key questions

1. What is the minimum **runbook contract** (required sections/links) that prevents drift and duplication?
2. What cadence is “enough” for engagement and safety (monthly vs quarterly), and what is the exact checklist?
3. What is the canonical “operator model” doc surface (and what must be duplicated vs linked)?
4. Which invariants must be decided once (storage paths, backup scope, recovery) so layers don’t re-learn them?
5. What is the smallest meta structure that helps today without importing dev-infra’s multi-service overhead?

---

## Spike determination

| Topic | Risk | Spike first? | Rationale |
|-------|------|--------------|-----------|
| Maintenance cadence checklist | Low | No | Can iterate safely; easiest to validate by doing |
| Runbook contract/template | Medium | No | Needs taste + iteration; not a hard-to-pivot decision |
| Operator model doc surface | Medium | Consider | Cross-cuts many docs; risk of duplication if wrong home |

---

## Related context (existing repo artifacts)

- **Roadmap tracks**: `docs/roadmap.md` (Tracks A/C/D)  
- **Retrospective prompts**: `docs/maintainers/planning/features/layer-0-foundation/notes-post-cycle-design-retrospective.md`  
- **Layer 1 exploration**: `docs/maintainers/explorations/layer-1-usable/` (operator experience themes belong there only when they are layer-scoped; this meta topic keeps them cross-layer)

---

**Last updated:** 2026-05-05
