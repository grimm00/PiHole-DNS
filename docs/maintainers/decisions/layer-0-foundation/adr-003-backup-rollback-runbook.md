# ADR-003: Backup scope and rollback runbook (Layer 0)

**Status:** Accepted  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-19  

---

## Context

**FR-3** requires a minimal operator runbook: what to back up, when, rollback order, optional factory reset. Research Stage 3 defined content; the operator chose **where documentation lives** and elevated **Teleporter** from optional to **required** for this household’s process.

**Related:** [decision-interview.md §3](decision-interview.md#section-3) · [research-stage-3-safety-rollback.md](../../research/layer-0-foundation/research-stage-3-safety-rollback.md)

---

## Decision

**Decision:**

1. **Location:** Layer 0 backup/rollback documentation is authored under **`docs/runbooks/`** (see [docs/runbooks/README.md](../../../runbooks/README.md)).  
2. **Teleporter:** **Required** in the operator’s process—not optional only. Pi-hole **Teleporter** export/restore is part of the documented procedure alongside volume backup of **`./etc-pihole`** (and **`./etc-dnsmasq.d`** if customized), per **FR-3** research ordering (client DNS revert → compose → restore).  
3. **Beyond FR-3:** No extra scheduling or family-facing steps for Layer 0; ideas may be captured in later cycles.

---

## Consequences

### Positive

- Clear home for runbooks separate from maintainer-only research.  
- Stronger recovery story when settings need to move or rebuild quickly (Teleporter + volumes).

### Negative

- Slightly more operator ceremony than “volumes only”; Teleporter must be kept in sync with reality when config changes.

---

## Alternatives considered

### Teleporter optional vs required

**Description:** FR-3 allows Teleporter as optional; volumes alone can satisfy minimal backup.

**Why required was chosen:** Operator preference to align household practice with a portable export and work habits.

### Runbook only in root `README.md`

**Description:** Single-file discovery for new readers.

**Why not chosen:** Operator prefers a dedicated **`docs/runbooks/`** area; README can still link here.

---

## Decision rationale

Aligns with **FR-3**, **Track D**, and decision interview §3. Implementation work: add concrete runbook page(s) under `docs/runbooks/` fulfilling FR-3 content.

---

## Requirements impact

- **FR-3:** Documentation structure and Teleporter emphasis match this ADR.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-3  
- [decision-interview.md](decision-interview.md)

---

**Last Updated:** 2026-04-19
