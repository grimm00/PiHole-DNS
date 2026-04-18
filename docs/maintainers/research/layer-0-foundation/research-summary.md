# Research summary — Layer 0 — Foundation

**Purpose:** Cross-stage synthesis for Layer 0 research.  
**Status:** ✅ Research complete (all stages conducted — **consolidate** before decisions)  
**Created:** 2026-04-17  
**Last Updated:** 2026-04-17  

---

## Overview

Research runs in **stages** (see [hub README](README.md)). Stage 0 is the **prior art / existing patterns** opening; Stages 1–4 align with the exploration topics.

| Stage | Document | Status |
|-------|----------|--------|
| 0 | [research-stage-0-prior-art.md](research-stage-0-prior-art.md) | ✅ |
| 1 | [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md) | ✅ |
| 2 | [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md) | ✅ |
| 3 | [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md) | ✅ |
| 4 | [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md) | ✅ |

---

## Key findings

### Stage 0: Prior art & existing patterns

- **OurFileServer:** Compose + bind mounts pattern; adapt secret handling.  
- **Official `pihole/pihole`:** Adopt image/docs; v6 env (`FTLCONF_*`); dnsmasq mount may need `FTLCONF_misc_etc_dnsmasq_d`.  
- **Community:** Port 53 / systemd-resolved — inform Stage 2; verify on target OS.

**Source:** [research-stage-0-prior-art.md](research-stage-0-prior-art.md)

### Stage 1: Stable addressing

- **DHCP reservation** vs **manual static** on Pi: both valid; **Ethernet** MAC / NM profile; Bookworm uses **NetworkManager**.  
- **Layer 0 done** checklist: ping, IP stable after reboot, Pi-hole web UI, one opt-in client DNS + rollback.

**Source:** [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md)

### Stage 2: Pi-hole Compose

- **`FTLCONF_dns_listeningMode: 'ALL'`**, **`FTLCONF_misc_etc_dnsmasq_d`**, password env; **`etc-pihole`** persistence.  
- Pi OS **port 53** diagnosis vs Ubuntu **`resolved`**; firewall if enabled.

**Source:** [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md)

### Stage 3: Safety, rollback, household risk

- **Client DNS revert** first; backup **`./etc-pihole`**; **Teleporter** optional; compose **down/restore/up**.

**Source:** [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md)

### Stage 4: Minimum deploy (Track A)

- **Git + `.env` + `docker compose`** suffices for Layer 0; **mise/ghcr** deferred until triggers (multi-host, air-gap, team).  
- **Pin** with **date tag or digest** after first good deploy; **local cache** satisfies much of NFR-2 without a registry.  
- **README** documents the minimum deploy path (**FR-4**).

**Source:** [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md)

---

## Key insights

- [x] Homelab pattern is consistent (Compose + volumes); Pi-hole adds DNS/port semantics and v6 env naming.  
- [x] Stable IPv4 is a hard prerequisite for client DNS targeting.  
- [x] Operational safety prioritizes **client revert** and **volume backup**.  
- [x] **Track A** minimum path is intentionally **light**; supply-chain hardening scales with NFR-2 and later layers.

---

## Recommendations

- [x] Run **`/research layer-0-foundation --consolidate`**, then **`/decision layer-0-foundation --from-research`**.  
- [x] Pin **`pihole/pihole`** in Compose after a verified deploy.

---

## Requirements

See [requirements.md](requirements.md).

- **FR-1 … FR-4**, **NFR-1**, **NFR-2**, **C-1**, **A-1 … A-5**

---

## Next steps

1. **`/research layer-0-foundation --consolidate`**  
2. **`/decision layer-0-foundation --from-research`**

---

**Last Updated:** 2026-04-17
