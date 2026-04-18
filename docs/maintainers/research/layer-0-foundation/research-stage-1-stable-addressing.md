# Research — Stage 1: Stable addressing & “Layer 0 done”

**Layer:** 0 — Foundation  
**Status:** ✅ Complete  
**Created:** 2026-04-17  
**Completed:** 2026-04-17  
**Exploration topic:** [Topic 1](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

How should the Pi obtain a **stable** address (DHCP reservation vs static config on Pi OS), and what **objective checks** prove Layer 0 is complete?

---

## Context

- **Pi on Ethernet** (wired LAN). Use the **Ethernet interface’s MAC** for DHCP reservations (on Raspberry Pi OS this is commonly `eth0`; confirm with `ip link` / `nmcli`).  
- Per-device opt-in DNS; not router-wide until confidence exists.  
- **Test clients** (e.g. Steam Deck) may be Wi‑Fi; they must still reach the Pi’s **LAN IP** on the same subnet.

---

## Stage goals

- [x] Compare DHCP reservation vs static IP on the Pi for this environment.  
- [x] Define a minimal **Layer 0 done** checklist (reachability, Pi-hole UI, DNS on one client).  
- [x] Note **wired (Ethernet)** stability expectations vs wireless clients.

---

## Methodology

Router documentation (generic); Raspberry Pi OS **Bookworm** networking (replaces `dhcpcd` with **NetworkManager** per [community consensus](https://raspberrypi.stackexchange.com/questions/144886/how-to-set-up-a-static-ip-on-raspberry-pi-5-with-raspbian-dhcpcd-conf-missing) and [Pi blog coverage](https://www.jeffgeerling.com/blog/2024/set-static-ip-address-nmtui-on-raspberry-pi-os-12-bookworm/)); web search on DHCP reservation vs manual static for home servers.

**Sources**

- [x] Raspberry Pi OS Bookworm / `nmcli` / `nmtui`  
- [x] General DHCP reservation vs static IP guidance  
- [x] Pi-hole client configuration expectations ([docs](https://docs.pi-hole.net/))

---

## Findings

### Finding 1: DHCP reservation vs static configuration on the Pi

**Summary**

| Approach | How it works | Pros | Cons |
|----------|----------------|------|------|
| **DHCP reservation** (router) | Router ties the Pi’s **Ethernet MAC** to a fixed LAN IP from the DHCP pool. | Single place to manage IPs; fewer typos on device; Pi still uses normal DHCP client — good defaults for gateway/DNS from router during setup. | Depends on router UI and reliability; if DHCP/lease db resets, address could change unless reservation reapplied; Pi must use DHCP on that interface (not manual static on device). |
| **Manual static on the Pi** | Configure **IPv4 manual** on the **wired** connection (Bookworm: **NetworkManager** via `nmtui` or `nmcli`; profile usually bound to `eth0` or “Wired connection”). | Works even if router has no reservation feature; predictable if subnet/mask/gateway correct. | Easy to misconfigure (wrong gateway, duplicate IP, wrong subnet); SSH session drops if you change IP live; you must coordinate an IP **outside** or **inside** DHCP range per your design. |

**Source:** Industry summaries (e.g. [network-switch.com DHCP vs static](https://network-switch.com/ms/blogs/networking/dhcp-vs-static-ip)); homelab practice.

**Relevance:** For a **single home server** Pi, **DHCP reservation is often the lowest-friction** path if the router supports it. **Manual static on the Pi** is appropriate when the router cannot reserve, or you want the Pi fully self-describing. **Either** yields a stable IP for DNS clients **if** the chosen address is unique and persistent.

---

### Finding 2: Raspberry Pi OS Bookworm and Ethernet static addressing

**Summary:** On **Raspberry Pi OS Bookworm**, legacy **`/etc/dhcpcd.conf`** guidance is **obsolete** for default images; **NetworkManager** controls interfaces. Typical approaches for **wired** Ethernet:

- **Interactive:** `sudo nmtui` → select the **Ethernet** / wired connection → IPv4 **Manual** → address/CIDR, gateway, DNS → apply; then restart NetworkManager or bounce the connection ([Jeff Geerling](https://www.jeffgeerling.com/blog/2024/set-static-ip-address-nmtui-on-raspberry-pi-os-12-bookworm/)).
- **CLI:** `nmcli connection modify '<wired-profile>' ipv4.method manual ipv4.addresses '192.168.x.y/24' ipv4.gateway '192.168.x.1' ipv4.dns ...` then `nmcli connection down/up` the profile (see [gist example](https://gist.github.com/hivian/590b44885940aa927e3bfcd388615a49)).

**Caution:** Changing IPv4 over SSH **drops the session** if the new address is wrong or unreachable—use console, `screen`, or plan IP carefully.

**Source:** [Raspberry Pi Stack Exchange — Pi 5 / dhcpcd missing](https://raspberrypi.stackexchange.com/questions/144886/how-to-set-up-a-static-ip-on-raspberry-pi-5-with-raspbian-dhcpcd-conf-missing); [Jeff Geerling — nmtui Bookworm](https://www.jeffgeerling.com/blog/2024/set-static-ip-address-nmtui-on-raspberry-pi-os-12-bookworm/).

**Relevance:** Stage 1 implementation on the **actual** Pi must use **Bookworm-appropriate** tools (`nmcli`/`nmtui`), not outdated `dhcpcd.conf` tutorials unless `dhcpcd` was explicitly restored.

---

### Finding 3: Ethernet on the Pi vs wireless test clients

- **Pi (server):** **Ethernet** avoids Wi‑Fi–specific jitter and drops for the DNS host; link is typically stable for homelab DNS.  
- **Clients:** Opt-in devices (e.g. Steam Deck on Wi‑Fi) are fine; ensure they can reach the Pi’s **same-LAN IPv4** (routing/firewall).  
- **Cable/link:** Note physical connection in runbook (which port, working link).

**Source:** General networking practice.

**Relevance:** Stage 1 framing: **stable IP on the wired Pi**; client wireless vs wired does not change the checklist as long as L3 reachability holds.

---

## Analysis

**Key insights**

- [x] **Stable IP** is a prerequisite for “point DNS at Pi-hole”; reservation vs manual static is a **policy choice** constrained by router capabilities and operator comfort with NetworkManager.  
- [x] **Bookworm** ⇒ verify networking stack on the real Pi before following pre-2023 guides.  
- [x] **Layer 0 “done”** is about **verifiable** checks, not a particular addressing religion.

---

## Recommendations

- [x] **Prefer DHCP reservation** on the home router **if** it supports MAC-based reservation for the Pi’s **Ethernet MAC** and you can document the reserved IP — lowest error rate for many homelabs.  
- [x] **Otherwise** use **NetworkManager static IPv4** on the **wired** connection (e.g. `eth0` profile) with correct **CIDR, gateway, and DNS** (during setup, DNS on the Pi can still point upstream until Pi-hole is ready—avoid circular dependency per Pi-hole [host DNS docs](https://docs.pi-hole.net/docker/tips-and-tricks/)).  
- [x] Record the chosen IP in **this repo** (e.g. private notes or `.env.example` comments), not only on the router.

---

## Layer 0 done — minimal checklist

Use this to prove **Stage 1 + later Pi-hole** readiness from a **test client** (e.g. Steam Deck):

| # | Check | Pass criteria |
|---|--------|----------------|
| 1 | **Reachability** | `ping <Pi_IP>` succeeds consistently on LAN. |
| 2 | **Stability** | After Pi **reboot**, same IPv4 as documented (reservation held or static persisted). |
| 3 | **Pi-hole web** | Browser: `http://<Pi_IP>/admin/` loads (after Pi-hole container is up — may combine with Stage 2). |
| 4 | **Opt-in DNS** | On **one** client only: set DNS to `<Pi_IP>`; confirm resolution (e.g. `dig`/`nslookup` to a known domain) and Pi-hole sees queries in its UI. |
| 5 | **Rollback** | Document how to revert that client to prior DNS (router DHCP or previous servers). |

Items 3–4 assume Stage 2 (Compose) is complete; Stage 1 can complete **1–2** before Pi-hole exists.

---

## Requirements discovered

See [requirements.md](requirements.md): **FR-1**, **A-2**.

---

## Next stage

**[Stage 2 — Pi-hole Compose](research-stage-2-pihole-compose.md)**

---

**Last Updated:** 2026-04-17
