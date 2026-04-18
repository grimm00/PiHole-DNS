# Research — Stage 2: Pi-hole on Docker Compose

**Layer:** 0 — Foundation  
**Status:** ✅ Complete  
**Created:** 2026-04-17  
**Completed:** 2026-04-17  
**Exploration topic:** [Topic 2](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

What host and container settings avoid common failures (port **53** conflicts, firewall, volume layout) for Pi-hole on Raspberry Pi OS?

---

## Context

- Repo [`docker-compose.yml`](../../../../docker-compose.yml): `pihole/pihole`, bind mounts, admin password via `.env`.  
- First-time Pi-hole operator; Pi-hole **v6** images (`pihole/pihole:latest` post-[2024.07.0](https://docs.pi-hole.net/docker/upgrading/v5-v6/)).

---

## Stage goals

- [x] Map port 53/tcp/udp and 80; conflicts with `systemd-resolved` or other listeners.  
- [x] Volume paths: `./etc-pihole`, `./etc-dnsmasq.d` — permissions, v6 behavior, backup scope.  
- [x] Firewall (nftables/ufw) references for Pi OS if applicable.

---

## Methodology

Official [Pi-hole Docker](https://docs.pi-hole.net/docker/) and [configuration](https://docs.pi-hole.net/docker/configuration/) docs; [docker-pi-hole](https://github.com/pi-hole/docker-pi-hole) example Compose; [v5→v6 upgrade](https://docs.pi-hole.net/docker/upgrading/v5-v6/); web search on Raspberry Pi OS Bookworm vs `systemd-resolved`; Jeff Geerling / forums on Bookworm + Docker + DNS.

**Sources**

- [x] [docs.pi-hole.net — Docker configuration](https://docs.pi-hole.net/docker/configuration/)  
- [x] [docs.pi-hole.net — Tips and tricks](https://docs.pi-hole.net/docker/tips-and-tricks/) (host DNS / port conflicts)  
- [x] [Pi-hole Docker — upgrading v5 to v6](https://docs.pi-hole.net/docker/upgrading/v5-v6/)  
- [x] Raspberry Pi forums / Geerling — Bookworm networking (no `systemd-resolved` by default)

---

## Findings

### Finding 1: Published ports and bridge networking (Compose defaults)

**Summary**

- Upstream expects **53/tcp**, **53/udp**, and **80/tcp** at minimum for DNS + HTTP admin; **443/tcp** is in the official `docker run` example for HTTPS admin ([configuration](https://docs.pi-hole.net/docker/configuration/)). This repo maps **53** and **80** only for Layer 0 — acceptable if HTTPS for the web UI is deferred.  
- With Docker’s default **bridge** network (not `--network host`), FTL must listen appropriately: set **`FTLCONF_dns_listeningMode: 'ALL'`** (case-insensitive) so DNS answers for the published ports ([upstream example](https://github.com/pi-hole/docker-pi-hole), [PR #1741](https://github.com/pi-hole/docker-pi-hole/pull/1741)).  
- **`--network host`** is an alternative to `-p` (mutually exclusive); not required for basic LAN DNS + web on a dedicated Pi.

**Source:** [Pi-hole Docker configuration](https://docs.pi-hole.net/docker/configuration/); [docker-pi-hole README](https://github.com/pi-hole/docker-pi-hole).

**Relevance:** Compose must include **`FTLCONF_dns_listeningMode`** for typical bridge deployments; omitting it is a common “DNS works oddly or not from LAN” foot-gun.

---

### Finding 2: Port 53 on the host — `systemd-resolved` vs Raspberry Pi OS Bookworm

**Summary**

- On **many Ubuntu/Debian desktop** installs, **`systemd-resolved`** listens on **`127.0.0.53:53`**, which conflicts with binding **host** port 53 for Pi-hole. Official [tips and tricks](https://docs.pi-hole.net/docker/tips-and-tricks/) document **`DNSStubListener=no`** and **`/etc/resolv.conf`** handling for that case.  
- **Raspberry Pi OS Bookworm** (typical Pi 5 image) commonly uses **NetworkManager** and **does not enable `systemd-resolved`** in the same way as stock Ubuntu; community threads note Pi OS is **not** Ubuntu’s resolved stack ([Raspberry Pi forums](https://forums.raspberrypi.com/viewtopic.php?t=378067)).  
- **Still verify on the real Pi:** `ss -lunp | grep ':53'` or `sudo lsof -i :53` before blaming “resolved.” Another process (dnsmasq, bind, second Pi-hole test) could hold **53**.  
- **Separate issue — host DNS after Docker on Bookworm:** Some users report **host** name resolution breaking when Docker alters **NetworkManager** / resolver behavior; fixes are **NM- and `resolv.conf`-related**, not Pi-hole container port publishing ([Jeff Geerling, 2024](https://jeffgeerling.com/blog/2024/resolving-temporary-failure-name-resolution-on-pi-os-12-bookworm)). Distinguish **“container won’t bind 53”** vs **“Pi can’t resolve while container runs.”**

**Source:** [Pi-hole tips and tricks](https://docs.pi-hole.net/docker/tips-and-tricks/); [Raspberry Pi forums — Bookworm vs systemd-resolved](https://forums.raspberrypi.com/viewtopic.php?t=378067); [Geerling — name resolution on Pi OS 12](https://jeffgeerling.com/blog/2024/resolving-temporary-failure-name-resolution-on-pi-os-12-bookworm).

**Relevance:** Stage 0’s “resolved spike” applies strongly to **Ubuntu-like** hosts; on **Pi OS**, prioritize **empirical** port checks and **NM/Docker DNS** interactions.

---

### Finding 3: Volumes — `/etc/pihole` and `/etc/dnsmasq.d` under Pi-hole v6

**Summary**

- **`./etc-pihole:/etc/pihole`** — Primary persistence: gravity DBs, `pihole.toml`-backed config, lists. **Backup scope for Layer 0:** treat **`etc-pihole/`** (repo-relative on the Pi) as the Pi-hole state to protect before destructive changes.  
- **Pi-hole v6** does **not** read **`/etc/dnsmasq.d/`** by default. To use the repo’s **`./etc-dnsmasq.d:/etc/dnsmasq.d`** mount, set **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** ([v5→v6](https://docs.pi-hole.net/docker/upgrading/v5-v6/), [configuration](https://docs.pi-hole.net/docker/configuration/)).  
- Alternative for a few lines: **`FTLCONF_misc_dnsmasq_lines`** without a dnsmasq.d mount.  
- **Permissions:** Image defaults **`PIHOLE_UID` / `PIHOLE_GID`** (often 1000) to align with host user if needed; first run may create files as container user — avoid root-only host dirs that the `pihole` user cannot write.

**Source:** [Pi-hole v5→v6 Docker](https://docs.pi-hole.net/docker/upgrading/v5-v6/); [configuration](https://docs.pi-hole.net/docker/configuration/).

**Relevance:** Keeping **`etc-dnsmasq.d`** in Compose without **`FTLCONF_misc_etc_dnsmasq_d`** is ineffective on v6; either set the env or drop the mount for minimal Layer 0.

---

### Finding 4: Firewall on Raspberry Pi OS

**Summary**

- Default Pi OS images often have **no** host firewall enabled; risk appears when **ufw** or **nftables** is added.  
- If **ufw** is active, allow DNS and web from the LAN, e.g. `sudo ufw allow from 192.168.50.0/24 to any port 53 proto tcp` (and **udp**), plus **80** — adjust subnet to match the home LAN ([Pi-hole docs](https://docs.pi-hole.net/) defer to distro firewall docs).  
- **Docker** publishes ports by inserting **iptables/nft** rules**;** overly aggressive **INPUT** policies can still block **LAN→host** before Docker rules apply — verify **`ufw status`** and Docker’s chains if connections fail only from remote clients.

**Source:** General Linux firewall practice; Pi-hole assumes host ports reach the container.

**Relevance:** Document **“if you enable ufw, punch holes for 53/80”** in runbooks; not a default Pi OS hurdle.

---

### Finding 5: Capabilities (`cap_add`)

**Summary**

- Official Compose example includes **`cap_add: NET_ADMIN`** (and optionally **`SYS_TIME`**, **`SYS_NICE`**) for **DHCP** / **NTP** scenarios ([docker-pi-hole](https://github.com/pi-hole/docker-pi-hole)).  
- For **DNS + web only** (no Pi-hole DHCP), **`NET_ADMIN`** is often **omitted** in minimal setups; image notes capabilities for FTL ([configuration — Note on Capabilities](https://docs.pi-hole.net/docker/configuration/)).  
- **Layer 0:** DHCP not required — **`NET_ADMIN`** optional; add when enabling Pi-hole DHCP or following upstream one-to-one.

**Source:** [Pi-hole Docker configuration — capabilities](https://docs.pi-hole.net/docker/configuration/).

**Relevance:** Avoid over-privileging; add **`cap_add`** when features demand it.

---

## Analysis

**Key insights**

- [x] **v6 Compose** is **`FTLCONF_*`-driven**; **`WEBPASSWORD`** alone is legacy — use **`FTLCONF_webserver_api_password`** (or **`WEBPASSWORD_FILE`**) per [docs](https://docs.pi-hole.net/docker/configuration/).  
- [x] **Bridge mode** ⇒ **`FTLCONF_dns_listeningMode: 'ALL'`** is the documented default alignment for published **53**.  
- [x] **`etc-dnsmasq.d`** mount ⇒ **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** or the mount is pointless on v6.  
- [x] **Pi OS Bookworm** ≠ Ubuntu **resolved** story — **measure** port **53** and **NM** if issues arise.

---

## Recommendations

- [x] Update Compose to set **`FTLCONF_dns_listeningMode: 'ALL'`**, **`FTLCONF_misc_etc_dnsmasq_d: 'true'`** while **`etc-dnsmasq.d`** is mounted, and **`FTLCONF_webserver_api_password`** from **`.env`** (replace **`WEBPASSWORD`** in comments).  
- [x] On first failure to bind **53**, run **`ss -lunp 'sport = :53'`** on the Pi; consult Pi-hole **tips** for **resolved** only if **`127.0.0.53:53`** appears.  
- [x] Treat **`etc-pihole/`** as the **primary backup** artifact for Pi-hole state; **`etc-dnsmasq.d/`** only if custom snippets are used.

---

## Requirements discovered

See [requirements.md](requirements.md): **FR-2**, **A-3**; reinforces **NFR-1**, **C-1**.

---

## Next stage

**[Stage 3 — Safety & rollback](research-stage-3-safety-rollback.md)**

---

**Last Updated:** 2026-04-17
