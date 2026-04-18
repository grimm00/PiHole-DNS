# Research — Stage 0: Prior art & existing patterns

**Layer:** 0 — Foundation  
**Status:** ✅ Complete  
**Created:** 2026-04-17  
**Completed:** 2026-04-17  

---

## Purpose (customary opening)

Before answering “how we should configure the Pi,” this stage inventories **what already works**: patterns from **your own repos**, **official** Pi-hole / Docker guidance, and **widely used** homelab approaches. Outcome: deliberate **adopt / adapt / inform** choices instead of accidental greenfield.

Aligned with the dev-infra idea of an **existing solutions audit** (see improvement *Prior Art / Existing Solutions Audit* in dev-infra).

---

## Research question

What **existing implementations, images, and patterns** are most relevant to Layer 0, and what should we adopt, adapt, or treat as reference only?

---

## Stage goals

- [x] Summarize **OurFileServer** (or sibling homelab) patterns: Compose style, secrets, deploy from git, host networking assumptions.  
- [x] Confirm **official Pi-hole Docker** image expectations and community foot-guns.  
- [x] Skim **popular** Pi-hole + Raspberry Pi + Docker writeups for recurring patterns (not as truth, as signal).  
- [x] Record **verdicts** for each bucket: Adopt / Adapt patterns / Inform only / Not applicable.

---

## Methodology

1. Review **[OurFileServer](https://github.com/grimm00/OurFileServer)** README and `docker-compose.yml` — note overlap with Pi-hole Compose.  
2. Read Pi-hole **official Docker** README and docs (`pihole/pihole`, [docs.pi-hole.net/docker](https://docs.pi-hole.net/docker/)).  
3. Web search: `pi-hole docker port 53 systemd-resolved` for recurring host conflicts.  
4. Compare with **this repo’s** [`docker-compose.yml`](../../../../docker-compose.yml).

---

## Findings — Existing solutions audit

### Finding A: Own repos & proven patterns

| Source | Overlap with Layer 0 | Fit assessment | Verdict |
|--------|----------------------|----------------|---------|
| [OurFileServer](https://github.com/grimm00/OurFileServer) `docker-compose.yml` | Same deployment class: **single-stack Compose on the Pi**, bind-mounted volumes for app data/config, `restart: unless-stopped`, published port to LAN. Uses `filebrowser/filebrowser:latest` with host path mounts (e.g. external drive under `/mnt/...`). | Pi-hole needs **53/80** instead of 8080→80, but the **operational pattern** (compose file in repo, pull/up on device) matches. Secrets appear inline in that compose in places — **prefer `.env` / secrets** for Pi-hole admin password (adapt). | **Adapt patterns** |

**Notes:**

- **Adopt:** “One `docker compose up -d` stack per concern,” persistent volumes beside the compose file, explicit `container_name`.  
- **Do not copy blindly:** avoid committing long-lived secrets in tracked YAML; Pi-hole docs recommend `FTLCONF_webserver_api_password` / `${VAR}` / `WEBPASSWORD_FILE` ([configuration](https://docs.pi-hole.net/docker/configuration/)).  
- Layer 1 roadmap explicitly contemplates **colocating** with this stack — keep Compose boundaries clear (ports, volumes) when merging.

---

### Finding B: Official / upstream

| Source | Overlap with Layer 0 | Fit assessment | Verdict |
|--------|----------------------|----------------|---------|
| `pihole/pihole` (Docker Hub / [GitHub](https://github.com/pi-hole/docker-pi-hole)) | **The** supported path for Pi-hole in Docker: publish **53/tcp+udp**, **80** (and **443** in upstream quick start). Persist **`/etc/pihole`**. Use **`latest`** or date tags per [versioning docs](https://docs.pi-hole.net/docker/). | Matches this repo’s image choice. Current **Pi-hole v6** images expect **`FTLCONF_*`** env vars; **`WEBPASSWORD` → `FTLCONF_webserver_api_password`** ([v5→v6](https://docs.pi-hole.net/docker/upgrading/v5-v6/)). Bridge mode commonly needs **`FTLCONF_dns_listeningMode: 'ALL'`**. Optional **`cap_add`** (e.g. `NET_ADMIN`) for DHCP — not required for basic DNS + web. | **Adopt** (image + docs); **adapt** our Compose comments/env to v6 |
| [Pi-hole Docker docs](https://docs.pi-hole.net/docker/) — *Tips and tricks* | Host **port 53** and **80/443** conflicts; **systemd-resolved** stub on 127.0.0.53 (common on **Ubuntu/Fedora**); workaround: `DNSStubListener=no` + correct **`resolv.conf`** symlink per docs — **Raspberry Pi OS** may differ; verify on target OS in Stage 2. | Essential reference for Stage 2 spikes if bind fails. | **Adopt** as primary troubleshooting source |

**Notes:**

- This repo’s compose mounts **`./etc-dnsmasq.d:/etc/dnsmasq.d`**. For Pi-hole **v6**, extra dnsmasq files often require **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** if that mount is kept ([configuration](https://docs.pi-hole.net/docker/configuration/)). Stage 2 should confirm whether the mount is needed at Layer 0 or can wait.  
- Upstream quick start includes **443**; this repo maps **80** only for MVP — acceptable if HTTPS admin not required initially.

---

### Finding C: Community / homelab (reference only)

| Source | Overlap with Layer 0 | Fit assessment | Verdict |
|--------|----------------------|----------------|---------|
| [Pi-hole docs — Tips and tricks — systemd-resolved](https://docs.pi-hole.net/docker/tips-and-tricks/) | Explains **port 53 already in use** on many Linux desktops/servers. | **Inform** host prep; validate on Pi OS rather than assuming Ubuntu. | **Inform** |
| Ask Ubuntu / Stack Exchange threads on **Pi-hole Docker + port 53** | Recurring **`listen tcp ... :53: address already in use`**; often **`systemd-resolved`**. | Confirms **spike-worthy** if `docker compose up` fails on 53. | **Inform** |
| Generic “Pi-hole Raspberry Pi Docker” blogs | Variable quality; many duplicate official compose snippets. | Use only after official docs; good for “what people trip on” (Wi‑Fi, power, SD wear). | **Inform** (low weight) |

**Notes:**

- Prefer **official docs and GitHub issues** over random tutorials when behavior disagrees.

---

## Analysis

**Key insights**

- [x] **Single homelab pattern:** OurFileServer and Pi-hole both fit “Compose on Pi, bind mounts, restart policy” — Pi-hole adds **privileged ports** and **DNS semantics**, not a different deployment religion.  
- [x] **v6 config drift:** `pihole/pihole:latest` is **v6**-based; compose env should use **`FTLCONF_webserver_api_password`** (or file-based secret), not legacy `WEBPASSWORD` alone — align before first production `up`.  
- [x] **dnsmasq.d mount:** Official v6 path often treats `/etc/dnsmasq.d` as optional; if we keep the mount, we likely need **`FTLCONF_misc_etc_dnsmasq_d`** or drop the mount for minimal Layer 0.  
- [x] **Host port 53:** Documented heavily for **systemd-resolved**; Raspberry Pi OS may use a different resolver stack — treat **Stage 2** as the place to prove bind behavior on the **actual** Pi image.

---

## Recommendations

- [x] **Adopt** `pihole/pihole` official image, published DNS + web ports, persisted `/etc/pihole`, and Pi-hole documentation as the first line of debugging.  
- [x] **Adapt** OurFileServer-style workflow: repo checkout + `docker compose up -d`, but **move admin password to v6 env** (and `.env` / secret file) before relying on the stack.  
- [x] **Schedule** a short **Stage 2** check: `lsof`/listening on **:53** on the Pi before declaring compose “done.”  
- [x] **Defer** registry/ghcr/mise to Stage 4 — official and prior-art consensus supports **git + compose** for initial bring-up.

---

## Requirements discovered

Captured in [requirements.md](requirements.md) as **FR-2** (v6 + Compose), **C-1**, **A-1** (see file). Summary:

- Align Compose env with **Pi-hole v6** (`FTLCONF_webserver_api_password` or secret file).  
- Treat **Pi-hole Docker docs** as normative for port conflicts and upgrades.  
- **Validate** dnsmasq volume + `FTLCONF_misc_etc_dnsmasq_d` pairing or simplify mount.

---

## Next stage

Proceed to **[Stage 1 — Stable addressing](research-stage-1-stable-addressing.md)**.

---

**Last Updated:** 2026-04-17
