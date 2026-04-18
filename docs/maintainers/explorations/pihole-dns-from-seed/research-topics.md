# Research topics — PiHole-DNS from seed

**Status:** ✅ Ready for research  
**Created:** 2026-04-17  
**Exploration:** [exploration.md](exploration.md)  
**Roadmap:** [Project roadmap](../../../roadmap.md) — layers and horizontal tracks (prioritize Layer 0 topics first)

---

## Topics

### Topic 1: Layer 0 — static addressing and validation

**Question:** How should the Pi obtain a **stable** address (DHCP reservation vs static config), and what objective checks prove Layer 0 is complete?

**Context:** Seed flags static IP as prerequisite; Pi is on Wi‑Fi only (Ethernet not connected); operator wants per-device DNS first.

**Priority:** High

**Suggested approach:** Router/docs survey for reservation vs static; document a minimal checklist (resolve, web UI, one client using Pi-hole as DNS); note Deck-vs-Pi test responsibilities.

---

### Topic 2: Pi-hole on Docker Compose — ports, firewall, persistence

**Question:** What host and container settings avoid the common foot-guns (port 53 conflicts, firewall, volume layout) for Pi-hole on Raspberry Pi OS?

**Context:** [`docker-compose.yml`](../../../../docker-compose.yml) exists; first-time Pi-hole user; limited systemd/firewall depth.

**Priority:** High

**Suggested approach:** Official docs + Compose patterns; list Pi OS firewall tools; define backup scope for mounted config.

---

### Topic 3: Observability roadmap (post–Layer 0)

**Question:** What metrics and surfaces give **meaningful engagement** without committing to a full stack before Layer 2?

**Context:** Dual desire: Pi-hole analytics and platform health; wrapper/dashboard is Layer 3.

**Priority:** Medium

**Suggested approach:** Inventory Pi-hole built-ins vs add-ons; skim lightweight monitoring options suitable for Pi 5; separate “nice for solo operator” from “must have.”

---

### Topic 4: GitOps-lite minimum path

**Question:** When does **image pull / mise** (or equivalent) pay off versus simpler deploy flows, and what secrets/layout does ghcr (or similar) imply?

**Context:** Target model is repo as SoT and Pi consuming artifacts; Layer 0 may not need full pipeline.

**Priority:** Medium

**Suggested approach:** Phase the deploy story (manual → scripted → registry); align with solo homelab constraints.

---

### Topic 5: Layer 1+ — OurFileServer and local DNS

**Question:** How should **local records** and **stack unification** with OurFileServer be sequenced to limit blast radius?

**Context:** Layer 1 combines `files.home` / `pihole.home` style names and Compose colocation.

**Priority:** Medium (after Layer 0 path is clear)

**Suggested approach:** Compare “DNS only first” vs “Compose merge first”; dependency on Theme 1–2.

---

### Topic 6: Workflow fit — CI, branch rules, dev-infra feedback

**Question:** What **minimal CI** and doc conventions prove the pipeline without pretending this is a Node/Python app?

**Context:** Feature/fix branch expectations; Sourcery; exploration under `docs/maintainers/explorations/`; dogfooding seed → explore.

**Priority:** Medium-Low

**Suggested approach:** `docker compose config`, markdown checks, or other zero/low-dependency gates; list feedback items for dev-infra template.

---

## Research workflow

1. Pick topics by **priority** (1–2 first unless blocked).  
2. Produce requirements/decision inputs per project research layout.  
3. If research surfaces **new upstream themes**, amend this exploration or add a short addendum (avoid reintroducing a heavy conduct pass).

---

**Last Updated:** 2026-04-17
