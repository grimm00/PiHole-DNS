# Research topics — Layer 0 — Foundation

**Status:** ✅ Ready for research  
**Created:** 2026-04-17  
**Exploration:** [exploration.md](exploration.md)  
**Roadmap:** [Layer 0 — Foundation](../../../roadmap.md)

---

## Topics

### Topic 1: Stable addressing and “Layer 0 done”

**Question:** How should the Pi obtain a **stable** address (DHCP reservation vs static config on Pi OS), and what **objective checks** prove Layer 0 is complete?

**Context:** Wi‑Fi only; static reachability required before client DNS can target the Pi; per-device opt-in (not router-wide).

**Priority:** High

**Suggested approach:** Router and Pi OS docs; write a minimal checklist (ping, Pi-hole web UI, one client resolving through Pi-hole); note test machine (e.g. Steam Deck) vs Pi roles.

---

### Topic 2: Pi-hole on Docker Compose — ports, firewall, persistence

**Question:** What host and container settings avoid common failures (port **53** conflicts, firewall, volume layout) for Pi-hole on Raspberry Pi OS?

**Context:** [`docker-compose.yml`](../../../../docker-compose.yml); first-time Pi-hole; `WEBPASSWORD` via `.env`.

**Priority:** High

**Suggested approach:** Pi-hole Docker docs; Pi OS firewall references; define backup scope for `./etc-pihole` and `./etc-dnsmasq.d` mounts.

---

### Topic 3: Safety, rollback, and household risk (L0)

**Question:** What **backup**, **rollback**, and **client fallback** steps are enough for a conservative home rollout?

**Context:** Track D; operator learning OS/network skills; family impact if DNS breaks.

**Priority:** Medium

**Suggested approach:** Short runbook: revert DNS on test device; restore volumes or reinstall Compose; when to stop and use router DNS again.

---

### Topic 4: Minimum deploy path from repo (Track A)

**Question:** What is the **smallest** workflow from this repo to a running stack on the Pi **without** requiring registry/mise until Compose + DNS are proven?

**Context:** GitOps-lite target; Layer 0 should not depend on full pipeline.

**Priority:** Medium

**Suggested approach:** Document `git pull` + `docker compose up -d` (or equivalent); when ghcr/mise become worthwhile; secret handling for `.env`.

---

## Deferred (not Layer 0)

See [seed research topics](../pihole-dns-from-seed/research-topics.md) for Layers 1–3, observability, and CI — pick up after Layer 0 exits.

---

## Research workflow

1. Complete Topics **1–2** before heavy implementation.  
2. Use `/research layer-0-foundation --from-explore layer-0-foundation` (or project layout) to produce requirements and decision inputs.  
3. Feed findings into ADRs; link from [roadmap](../../../roadmap.md).

---

**Last Updated:** 2026-04-17
