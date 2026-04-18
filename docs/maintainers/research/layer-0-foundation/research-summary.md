# Research summary — Layer 0 — Foundation

**Purpose:** Cross-stage synthesis for Layer 0 research.  
**Status:** 🔴 Research (partial — Stages 0–2 done)  
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
| 3 | [research-stage-3-safety-rollback.md](research-stage-3-safety-rollback.md) | 🔴 |
| 4 | [research-stage-4-minimum-deploy.md](research-stage-4-minimum-deploy.md) | 🔴 |

---

## Key findings

### Stage 0: Prior art & existing patterns

- **OurFileServer:** Compose + bind mounts pattern; adapt secret handling.  
- **Official `pihole/pihole`:** Adopt image/docs; v6 env (`FTLCONF_*`); dnsmasq mount may need `FTLCONF_misc_etc_dnsmasq_d`.  
- **Community:** Port 53 / systemd-resolved — inform Stage 2; verify on target OS.

**Source:** [research-stage-0-prior-art.md](research-stage-0-prior-art.md)

### Stage 1: Stable addressing

- **DHCP reservation** vs **manual static** on Pi: both valid; reservation often lower friction if router supports it; use the **Ethernet** MAC / wired NetworkManager profile; Bookworm uses **NetworkManager** (`nmtui` / `nmcli`), not `dhcpcd.conf`.  
- **Layer 0 done** checklist: ping, IP stable after reboot, then (with Pi-hole) web UI + one opt-in client DNS + rollback path.

**Source:** [research-stage-1-stable-addressing.md](research-stage-1-stable-addressing.md)

### Stage 2: Pi-hole Compose

- **Bridge networking:** **`FTLCONF_dns_listeningMode: 'ALL'`** with published **53**; **v6** password via **`FTLCONF_webserver_api_password`** (or file secret).  
- **`etc-dnsmasq.d`:** mount requires **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** on v6; primary state in **`etc-pihole/`**.  
- **Pi OS Bookworm:** unlike many Ubuntu installs, **`systemd-resolved`** stub on **127.0.0.53** is often **not** the first suspect — verify **`ss`/lsof**; watch **NetworkManager + Docker** host DNS quirks.  
- **Firewall:** if **ufw**/nft enabled, allow **53/80** from LAN; default Pi OS often has no host firewall.

**Source:** [research-stage-2-pihole-compose.md](research-stage-2-pihole-compose.md)

---

## Key insights

- [x] Homelab pattern is consistent (Compose + volumes); Pi-hole adds DNS/port semantics and v6 env naming.  
- [x] Stable IPv4 is a hard prerequisite for client DNS targeting; Bookworm networking stack must match docs used on the Pi.  
- [x] Pi-hole v6 **`FTLCONF_*`** and **`etc-dnsmasq.d`** flag are mandatory alignment points for this repo’s Compose.

---

## Recommendations

- [x] Prefer router **DHCP reservation** when possible; else **nmcli/nmtui** static on the **wired** connection (e.g. `eth0`).  
- [x] Keep Compose aligned with **FR-2** (listening mode, dnsmasq flag, password env).  
- [ ] Complete **Stages 3–4**.

---

## Requirements

See [requirements.md](requirements.md).

- Stage 0: **NFR-1**, **C-1**, **A-1**  
- Stage 1: **FR-1**, **A-2**  
- Stage 2: **FR-2**, **A-3**  
- **NFR-2** (image pin/cache): Stage 4  

---

## Next steps

1. Conduct **Stages 3–4** (safety/rollback, minimum deploy).  
2. `/research layer-0-foundation --consolidate` before decisions.

---

**Last Updated:** 2026-04-17
