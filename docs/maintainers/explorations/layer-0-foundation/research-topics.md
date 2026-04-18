# Research topics — Layer 0 — Foundation

**Status:** ✅ Ready for research  
**Created:** 2026-04-17  
**Exploration:** [exploration.md](exploration.md)  
**Roadmap:** [Layer 0 — Foundation](../../../roadmap.md)

---

## Research stages (repo layout)

Research is scaffolded under [`docs/maintainers/research/layer-0-foundation/`](../../research/layer-0-foundation/README.md) using **stages**: **Stage 0** is the customary *prior art & existing patterns* opening; **Stages 1–4** match the topics below.

### Stage 0 (customary opening — prior art)

**Question:** What existing implementations and patterns (OurFileServer, official Pi-hole Docker, homelab references) should inform Layer 0, and what are the adopt / adapt / inform verdicts?

**Priority:** High (do before or in parallel with Stage 1)

**Document:** [research-stage-0-prior-art.md](../../research/layer-0-foundation/research-stage-0-prior-art.md)

---

## Topics (Stages 1–4)

### Topic 1 — Stage 1: Stable addressing and “Layer 0 done”

**Question:** How should the Pi obtain a **stable** address (DHCP reservation vs static config on Pi OS), and what **objective checks** prove Layer 0 is complete?

**Context:** Pi on **Ethernet**; static reachability required before client DNS can target the Pi; per-device opt-in (not router-wide). Test clients may be wireless.

**Priority:** High

**Suggested approach:** Router and Pi OS docs; write a minimal checklist (ping, Pi-hole web UI, one client resolving through Pi-hole); note test machine (e.g. Steam Deck) vs Pi roles.

**Research:** ✅ [research-stage-1-stable-addressing.md](../../research/layer-0-foundation/research-stage-1-stable-addressing.md)

---

### Topic 2 — Stage 2: Pi-hole on Docker Compose — ports, firewall, persistence

**Question:** What host and container settings avoid common failures (port **53** conflicts, firewall, volume layout) for Pi-hole on Raspberry Pi OS?

**Context:** [`docker-compose.yml`](../../../../docker-compose.yml); first-time Pi-hole; `WEBPASSWORD` via `.env`.

**Priority:** High

**Suggested approach:** Pi-hole Docker docs; Pi OS firewall references; define backup scope for `./etc-pihole` and `./etc-dnsmasq.d` mounts.

---

### Topic 3 — Stage 3: Safety, rollback, and household risk (L0)

**Question:** What **backup**, **rollback**, and **client fallback** steps are enough for a conservative home rollout?

**Context:** Track D; operator learning OS/network skills; family impact if DNS breaks.

**Priority:** Medium

**Suggested approach:** Short runbook: revert DNS on test device; restore volumes or reinstall Compose; when to stop and use router DNS again.

---

### Topic 4 — Stage 4: Minimum deploy path from repo (Track A)

**Question:** What is the **smallest** workflow from this repo to a running stack on the Pi **without** requiring registry/mise until Compose + DNS are proven?

**Context:** GitOps-lite target; Layer 0 should not depend on full pipeline.

**Priority:** Medium

**Suggested approach:** Document `git pull` + `docker compose up -d` (or equivalent); when ghcr/mise become worthwhile; secret handling for `.env`. **Image policy:** after first pull from a public tag, move toward **pinned tags/digests** and **prefer cached images** (local Docker store or private registry) on rebuild—**same pattern for every base image** in the repo (see Stage 4 doc + NFR-2).

---

## Deferred (not Layer 0)

See [seed research topics](../pihole-dns-from-seed/research-topics.md) for Layers 1–3, observability, and CI — pick up after Layer 0 exits.

---

## Research workflow

1. Conduct **Stage 0** (prior art), then **Stages 1–2** before heavy implementation.  
2. Complete Stages 3–4; update [requirements.md](../../research/layer-0-foundation/requirements.md).  
3. Feed findings into ADRs; link from [roadmap](../../../roadmap.md).

---

**Last Updated:** 2026-04-17
