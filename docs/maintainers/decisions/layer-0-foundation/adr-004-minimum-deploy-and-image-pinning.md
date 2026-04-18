# ADR-004: Minimum deploy path and image pin/cache policy (Layer 0)

**Status:** Accepted  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-19  

---

## Context

**FR-4** requires documenting the minimum git + `.env` + compose path on the Pi. **NFR-1** requires pinning/caching images after verify; Stage 4 deferred registry/mise until triggers fire. The operator chose **digest pinning** for `pihole/pihole` (work-aligned habit), confirmed **deferral** of mise/ghcr/private registry for Layer 0, and placed operator docs under **`docs/`** with room to refine layout later.

**Related:** [decision-interview.md §4](decision-interview.md#section-4) · [research-stage-4-minimum-deploy.md](../../research/layer-0-foundation/research-stage-4-minimum-deploy.md)

---

## Decision

**Decision:**

1. **Image pin strategy:** After a successful deploy, pin **`pihole/pihole`** using an **image digest** (`image: pihole/pihole@sha256:…`) in Compose, matching operator practice from professional work. Prefer recording the digest in repo (and/or docs) so rebuilds do not silently re-resolve a moving tag.  
2. **mise / ghcr / private registry:** **Deferred** for Layer 0 unless Stage 4 triggers (multi-host, air-gap, team) apply.  
3. **Where to document minimum deploy:** Under **`docs/`**, consistent with operator preference. **Initial placement** aligns with **`docs/runbooks/`** (same area as Layer 0 procedures per ADR-003); the operator may **split or relocate** deploy vs rollback pages in a later iteration when the doc shape is clearer.  
4. **Local cache:** On rebuilds, prefer images already in the local Docker store per **NFR-1**; digest pinning supports reproducibility.

---

## Consequences

### Positive

- Reproducible deploys; digest matches supply-chain discipline from work.  
- No registry/mise overhead until needed.

### Negative

- Image updates require intentional digest bumps (see [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/)).

---

## Alternatives considered

### Date tag vs digest

**Description:** Pi-hole publishes date tags; digest is more immutable.

**Why digest:** Operator preference to build the habit used at work.

### Minimum deploy only in root README

**Description:** Single entrypoint for clones.

**Why docs/runbooks (initially):** Keeps long procedures next to rollback content; README should link to `docs/runbooks/`.

---

## Decision rationale

Supports **FR-4**, **NFR-1**, and **Track A**; matches decision interview §4.

---

## Requirements impact

- **FR-4**, **NFR-1:** Documentation and Compose `image:` evolve per this ADR.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-4, NFR-1  
- [decision-interview.md](decision-interview.md)  
- [roadmap.md](../../../../roadmap.md) — Track A

---

**Last Updated:** 2026-04-19
