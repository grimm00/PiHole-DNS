# ADR-002: Pi-hole Compose — Layer 0 baseline

**Status:** Accepted  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Context

**FR-2** specifies Pi-hole v6, published ports, `FTLCONF_*` variables, and persistence paths. Research Stages 0 and 2 aligned with the repo’s [`docker-compose.yml`](../../../../docker-compose.yml). The operator confirmed no intentional deltas for Layer 0. **Note:** Other stacks on the same Pi (e.g. OurFileServer) may use storage on an **external drive**; that does not, by itself, change Pi-hole’s Layer 0 bind mounts.

**Related:** [decision-interview.md §2](decision-interview.md#section-2)

---

## Decision

**Decision:** **Adopt the current [`docker-compose.yml`](../../../../docker-compose.yml) as the Layer 0 baseline** — Pi-hole **v6**-style `FTLCONF_*` variables, published host ports **53/tcp**, **53/udp**, **80/tcp**, password via **`.env`**, persistence via **`./etc-pihole`→`/etc/pihole`**, and **`./etc-dnsmasq.d`** with **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** as present in the file. **No** Layer 0 change to bind-mount paths or env names beyond what the repo already defines.

**Deferred:** Relocating Pi-hole volume directories to another disk or partition is **out of scope for Layer 0** unless a later **design** or **layer** decision explicitly changes it; keep distinct from file-server storage layout.

---

## Consequences

### Positive

- Single source of truth in repo; implementation and docs stay aligned with **C-1** (upstream Pi-hole Docker docs).
- Avoids premature volume-path complexity before Pi-hole is running.

### Negative

- If Pi-hole data must later move to bulk storage, that will be a **follow-on change** (compose paths, permissions, backup scope).

---

## Alternatives considered

### Customizing bind mounts for Layer 0 (e.g. external disk)

**Description:** Point `./etc-pihole` at paths on the same external partition used for the file server.

**Why not chosen now:** Operator has no required delta for Layer 0; mixing file-server disk layout with Pi-hole paths is a design decision best made when implementing or extending the stack, not as an implicit Layer 0 requirement.

---

## Decision rationale

Interview §2.1 accepts the researched baseline; §2.2 separates **file-server** external storage from **Pi-hole** repo-relative mounts for this phase. Satisfies **FR-2** without expanding scope.

---

## Requirements impact

- **FR-2:** Implementation and documentation match this ADR.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-2, C-1  
- [decision-interview.md](decision-interview.md)

---

**Last Updated:** 2026-04-18
