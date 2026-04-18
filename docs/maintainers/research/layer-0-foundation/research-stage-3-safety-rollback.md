# Research — Stage 3: Safety, rollback & household risk

**Layer:** 0 — Foundation  
**Status:** ✅ Complete  
**Created:** 2026-04-17  
**Completed:** 2026-04-17  
**Exploration topic:** [Topic 3](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

What **backup**, **rollback**, and **client fallback** steps are enough for a conservative home rollout?

---

## Context

Track D (roadmap); operator building OS/network skills; **per-device opt-in** so the household is not globally on Pi-hole until you choose; family impact if DNS breaks for opted-in clients.

---

## Stage goals

- [x] Define minimum backup for Pi-hole config volumes.  
- [x] Short rollback path: wrong DNS, broken Pi-hole, “use router DNS again.”  
- [x] Per-device revert steps for the test client.

---

## Methodology

Pi-hole [Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) (compose lifecycle); bind-mount persistence (Stage 2); homelab practice for single-host stacks; web search on Teleporter vs full directory backup.

**Sources**

- [x] [Pi-hole — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/)  
- [x] Pi-hole Teleporter / `pihole -a -t` (CLI and web UI)  
- [x] General bind-mount backup patterns for Compose

---

## Findings

### Finding 1: What to back up (Layer 0 scope)

**Summary**

- **Primary state:** The host directory bind-mounted to **`/etc/pihole`** (this repo: **`./etc-pihole`**) holds **`pihole.toml`**, gravity/FTL databases, lists, and related files — this is the **must-preserve** artifact across container replacements ([Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/)).  
- **Optional:** **`./etc-dnsmasq.d`** if you add custom snippets (with **`FTLCONF_misc_etc_dnsmasq_d`** per Stage 2).  
- **Teleporter** (`pihole -a -t` or **Settings → Teleporter** in the web UI) exports a **portable `.tar.gz`** of Pi-hole settings suitable for migrate/restore; operators often schedule it to a path under **`/etc/pihole`** that is on the bind mount so the file lands on the host ([community patterns](https://www.devwithimagination.com/2023/07/26/backing-up-docker-services/)). It complements but does not replace knowing where **`./etc-pihole`** lives on disk for a **full** copy.  
- **Before risky operations** (image major upgrade, experimental compose edits, v5→v6 migration on an existing install): copy **`./etc-pihole`** (tar/rsync) to another disk or machine; Pi-hole docs stress reading release notes and preserving volumes for Docker upgrades ([upgrading](https://docs.pi-hole.net/docker/upgrading/)).

**Source:** [docs.pi-hole.net — Docker upgrading](https://docs.pi-hole.net/docker/upgrading/); Pi-hole Teleporter documentation; homelab writeups.

**Relevance:** Layer 0 “minimum backup” = **know the host path**, **copy before change**, optional **Teleporter** for a small portable artifact.

---

### Finding 2: Rollback paths (ordered — fastest first)

**Summary**

1. **Client fallback (no Pi change):** On each **opt-in** device, set DNS back to **automatic / router DNS** or your previous resolvers (e.g. ISP or public DNS). This immediately restores browsing for that device if Pi-hole is wrong or down — aligns with **per-device opt-in** (Track D).  
2. **Stop broken service:** `docker compose down` in the repo directory on the Pi — host no longer publishes **53** (unless something else binds it); clients using Pi-hole IP will fail DNS until they revert (step 1) or Pi-hole is fixed.  
3. **Restore Pi-hole state:** With container **stopped**, replace **`./etc-pihole`** contents from a file copy or extract Teleporter restore via web UI after a fresh **`compose up`** if you prefer UI-driven restore — pattern: **down → restore data → up** per [Docker upgrading](https://docs.pi-hole.net/docker/upgrading/) (`docker compose down`, `pull` if upgrading image, `up -d`).  
4. **Nuclear:** Remove/rename **`./etc-pihole`** and **`./etc-dnsmasq.d`**, **`compose up`** again for a **factory-reset** Pi-hole (acceptable lab recovery; loses lists/settings).

**Source:** [Pi-hole Docker upgrading](https://docs.pi-hole.net/docker/upgrading/); operational practice.

**Relevance:** **Household safety** is mostly “never force router-wide DNS until confident”; **technical rollback** is volume restore + compose cycle.

---

### Finding 3: Household risk model (conservative Layer 0)

**Summary**

- Devices **not** pointed at Pi-hole **keep using** router DHCP DNS — they are unaffected by Pi-hole outages.  
- **Only opted-in clients** take risk from bad Pi-hole config or Pi downtime; that matches the seed interview (opt-in first).  
- **Communication:** If others share the network, a one-line “if the internet acts up on your phone, switch DNS back to automatic” reduces panic (social, not technical).

**Source:** Project exploration / roadmap Track D.

**Relevance:** No extra NFR for “router must support emergency bypass” beyond existing opt-in strategy.

---

### Finding 4: What Layer 0 does *not* require

**Summary**

- **Automated** off-site backup, **ZFS** snapshots, and **Watchtower**-style auto-updates are out of scope for minimum viable safety; Pi-hole upstream cautions against unattended image churn for Pi-hole ([docker-pi-hole README](https://github.com/pi-hole/docker-pi-hole) / community).  
- **Documented** manual backup before upgrades is enough for L0 credibility.

**Source:** Upstream “docker way” and homelab norms.

**Relevance:** Avoid scope creep in FR-3; optional hardening can be Layer 2+ / runbook appendix.

---

## Analysis

**Key insights**

- [x] **Fastest recovery** for users is **client DNS revert**, not SSH heroics.  
- [x] **Authoritative data** for Pi-hole is on disk at **`./etc-pihole`** — back it up before destructive work.  
- [x] **Compose lifecycle** (`down` / `pull` / `up`) is the supported upgrade/repair pattern in Docker.

---

## Recommendations

- [x] Add a **short runbook** (README or `docs/`) with: backup scope, Teleporter optional, client revert, `compose down` / restore / `up`.  
- [x] Keep **router DHCP DNS** unchanged for Layer 0 so the household default path stays safe.  
- [x] Before first **image upgrade**, copy **`etc-pihole/`** off the Pi once to establish a habit.

---

## Requirements discovered

See [requirements.md](requirements.md): **FR-3**, **A-4**.

---

## Next stage

**[Stage 4 — Minimum deploy path](research-stage-4-minimum-deploy.md)**

---

**Last Updated:** 2026-04-17
