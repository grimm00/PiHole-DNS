# Roadmap — PiHole-DNS

**Purpose:** Canonical, amendable map of what the project is building, in what order, and what is still open. The [root README](../README.md) keeps a one-screen summary; this file holds nuance and cross-cutting tracks.

**Status:** 🟡 Active — Layer 0 in progress  
**Last updated:** 2026-04-17  

**Sources:** [`start.md`](../start.md) (interview), exploration [`pihole-dns-from-seed`](maintainers/explorations/pihole-dns-from-seed/README.md).

---

## How to use this document

- **Vertical layers** (0–3) are the **delivery sequence**: each layer can run its own explore → research → decision cycle without re-litigating the whole project.
- **Horizontal tracks** span layers: record decisions once (ADRs, runbooks) so later cycles **inherit** instead of re-exploring the same concerns.
- When scope or ordering changes, **update this file** and bump the README table if needed.

---

## At a glance

| Layer | Name | Focus | Status |
|-------|------|--------|--------|
| 0 | **Foundation (MVP)** | Stable addressing, Pi-hole in Compose, DNS for at least one opt-in device | 🟡 Current |
| 1 | **Usable** | Local DNS names (`files.home`, `pihole.home`), OurFileServer in the same Compose stack | Planned |
| 2 | **Observable** | Platform monitoring + Pi-hole analytics beyond stock admin | Planned |
| 3 | **Application** | Custom wrapper app / dashboard tying the stack together | Future |
| — | **K3s migration** | Move from Compose to K3s when it pays off | Future |

---

## Vertical layers

### Layer 0 — Foundation (MVP)

**Outcome:** Pi has a **stable** address; Pi-hole runs in Docker Compose; at least one device uses Pi-hole for DNS **by choice** (not router-wide until confidence exists).

**Context:** Pi is on **Ethernet** (wired LAN). First-time Pi-hole operator; **conservative** rollout so household DNS is not put at risk. Opt-in DNS clients may be Wi‑Fi or wired.

**Typical research / decisions:** DHCP reservation vs static IP; Pi OS networking; minimal “Layer 0 done” checklist; Compose ports, firewall, and volume layout for Pi-hole.

**Exploration (scoped):** [`layer-0-foundation`](maintainers/explorations/layer-0-foundation/README.md) — research topics and spikes for this layer only.

**Research:** [`layer-0-foundation`](maintainers/research/layer-0-foundation/README.md) — staged research (Stage 0 = prior art opening; Stages 1–4 = exploration topics).

---

### Layer 1 — Usable

**Outcome:** Human-friendly local names for services; **OurFileServer** (or equivalent) runs in the **same** Compose stack as Pi-hole where it makes sense.

**Typical research / decisions:** Ordering DNS-only work vs stack merge; blast radius when colocating services; alignment with existing [OurFileServer](https://github.com/grimm00/OurFileServer) deployment habits.

---

### Layer 2 — Observable

**Outcome:** **Engagement** beyond install day — Pi-hole analytics plus **platform** health (containers, CPU, memory, uptime) at a depth that matches a solo operator.

**Typical research / decisions:** What to instrument first; Pi-hole built-ins vs add-ons; lightweight agents suitable for Raspberry Pi 5.

---

### Layer 3 — Application

**Outcome:** A **wrapper application** (dashboard / control surface) that ties Pi-hole, services, and observability into one place.

**Typical research / decisions:** Boundaries vs Pi-hole admin; repo and deployable shape; relationship to Layer 2 data.

---

### Future — K3s migration

**Outcome:** Move from Docker Compose to **K3s** (or similar) when learning goals and complexity justify it — not a Layer 0–3 requirement.

---

## Horizontal tracks (cross-cutting)

These are **not** separate “layers”: they apply across the roadmap. Work here should be **explicit in ADRs or ops docs** so vertical layers do not silently re-open the same topics.

| Track | Intent | Mainly touches | Open / inherited |
|-------|--------|----------------|------------------|
| **A — Deployment & GitOps-lite** | Repo as source of truth; Pi consumes defined artifacts; avoid SSH-and-edit drift; optional registry (e.g. ghcr.io) and tooling (e.g. mise) when they earn their keep. **Image policy:** pin by **date tag or digest** after first pull; prefer **locally cached** or **private-registry** copies on rebuild; same rule for **all** base images in the stack (see Layer 0 Stage 4 research). | All layers; **minimal path** for L0 | Secret handling (`WEBPASSWORD`, tokens); when registry/mise kick in vs plain `git pull`; parity with OurFileServer patterns; NFR-2 in `research/layer-0-foundation/requirements.md` |
| **B — Observability & engagement** | Stay engaged after setup: Pi-hole metrics + platform signals; bridge from “toy” to “habit.” | L2–L3 strongest; **intent** from L0 | Minimum viable metrics after L0; what ships in L2 vs the wrapper in L3 |
| **C — Workflow, CI, and engineering practice** | Feature branches, PRs, AI review; infra-appropriate CI; explore/research/decision under `docs/maintainers/`; seed → roadmap dogfooding for dev-infra. | All layers | Minimal CI gates for this repo; what feedback goes upstream to dev-infra |
| **D — Household safety & operations** | Per-device opt-in, rollback, backups, failure modes; grow OS/network skills without turning every layer into a networking course. | All layers; **tone** set in L0 | Backup scope for Pi-hole config; rollback when DNS is wrong; firewall/port 53 pitfalls |

---

## Open questions (for research)

Derived from the seed exploration; answers should land in research docs and ADRs, not only here.

1. Smallest **verifiable** Layer 0 definition (checklist + tests) on a typical home LAN?
2. After Layer 0, what observability slice is **worth doing first** vs waiting for Layer 2?
3. **Minimum viable GitOps-lite** from this repo to the Pi without overbuilding before Compose + DNS are proven?
4. How to **order and scope** Layers 1–3 so OurFileServer integration and wrapper work do not collide?
5. What **CI / docs** shape fits an infra-heavy repo without fake “app” checks?
6. What **safeguards** (backup, rollback, per-device fallback) match **family-risk** constraints?

---

## Risk & time-boxed spikes

| Area | Risk | Spike when |
|------|------|------------|
| Static IP / LAN addressing | Medium–high | Before betting work on wrong network assumptions |
| Compose + Pi-hole + host firewall / port 53 | Medium–high | If DNS or UI fails mysteriously on the Pi |
| Registry + mise deploy | Medium | After L0 path is credible |
| Observability stack | Medium | Usually research + small experiments first |

---

## Related artifacts

| Artifact | Role |
|----------|------|
| [`start.md`](../start.md) | Original interview seed |
| [`docs/maintainers/explorations/pihole-dns-from-seed/`](maintainers/explorations/pihole-dns-from-seed/README.md) | Seed exploration that informed this roadmap |
| [`docs/maintainers/explorations/layer-0-foundation/`](maintainers/explorations/layer-0-foundation/README.md) | Layer 0 scoped exploration (current delivery focus) |
| [`docs/maintainers/research/layer-0-foundation/`](maintainers/research/layer-0-foundation/README.md) | Layer 0 staged research (Stage 0 = prior art) |
| [`docs/maintainers/research/`](maintainers/research/README.md) | Research hub (all topics) |
| [`docs/maintainers/decisions/`](maintainers/decisions/README.md) | ADRs |

---

**Next:** Layer 0 research and implementation; amend this file when a layer’s scope or status changes.
