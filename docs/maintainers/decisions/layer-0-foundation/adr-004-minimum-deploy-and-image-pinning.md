# ADR-004: Minimum deploy path and image pin/cache policy (Layer 0)

**Status:** Proposed  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Context

**FR-4** requires documenting the minimum git + `.env` + compose path on the Pi. **NFR-1** requires pinning/caching images after verify; Stage 4 deferred registry/mise until triggers fire. This ADR records **where** the deploy doc lives and the **concrete pin strategy** for `pihole/pihole` after first good deploy.

**Related:** [decision-interview.md §4](decision-interview.md#section-4) · [research-stage-4-minimum-deploy.md](../../research/layer-0-foundation/research-stage-4-minimum-deploy.md)

---

## Decision

*[To be filled from decision interview §4.]*

**Decision:** *[e.g. Pin to digest recorded in compose after verify; mise/ghcr deferred.]*

---

## Consequences

### Positive

- *[TBD]*

### Negative

- *[TBD]*

---

## Alternatives considered

*[e.g. Date tag vs digest; doc location — from interview.]*

---

## Decision rationale

*[From interview + FR-4 + NFR-1 + Track A]*

---

## Requirements impact

- **FR-4**, **NFR-1:** Docs and `image:` line evolve per this ADR.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-4, NFR-1  
- [decision-interview.md](decision-interview.md)  
- [roadmap.md](../../../../roadmap.md) — Track A

---

**Last Updated:** 2026-04-18
