# Research topics — Meta — Ops Factory

**Status:** 🟡 Initial — refine before `/research`  
**Created:** 2026-05-05  
**Exploration:** [exploration.md](exploration.md)

---

## Topic 1 — Runbook contract

**Question:** What must every runbook include (sections/links/invariants) so procedures stay executable and don’t duplicate design truths?

**Context:** The Layer 0 retrospective note calls out access path, storage/paths, and split of concerns; those should become repeatable runbook expectations, not one-off prose.

**Priority:** High

---

## Topic 2 — Maintenance cadence checklist

**Question:** What is a safe, low-touch cadence (monthly/quarterly) and what is the concrete checklist (backup → update → verify → rollback trigger)?

**Context:** Two weeks of stable opt-in DNS suggests Layer 0 baseline is solid; cadence turns “silent drift” into intentional engagement.

**Priority:** High

---

## Topic 3 — Operator model doc surface

**Question:** Where should the canonical “operator model” live (and what belongs there vs runbooks vs ADRs) to avoid truth-in-two-places?

**Context:** The repo already has multiple doc surfaces (`docs/runbooks`, `docs/maintainers/...`); choosing the wrong home increases drift.

**Priority:** Medium

---

## Topic 4 — Skills/commands alignment to repo structure

**Question:** How should skills and conventions be shaped so they operate correctly with this repo’s `docs/maintainers/` layout (without importing dev-infra service-first assumptions)?

**Context:** dev-infra has moved to `.claude/skills` and `admin/services/...`; PiHole-DNS is single-service and already stable; adopt only what reduces friction.

**Priority:** Medium

---

## Next step

When ready:

```
/research meta-ops-factory --from-explore meta-ops-factory
```

---

**Last updated:** 2026-05-05
