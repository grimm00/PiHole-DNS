# Research — Stage 2: Pi-hole on Docker Compose

**Layer:** 0 — Foundation  
**Status:** 🔴 Research  
**Created:** 2026-04-17  
**Exploration topic:** [Topic 2](../../explorations/layer-0-foundation/research-topics.md)

---

## Research question

What host and container settings avoid common failures (port **53** conflicts, firewall, volume layout) for Pi-hole on Raspberry Pi OS?

---

## Context

- Repo [`docker-compose.yml`](../../../../docker-compose.yml): `pihole/pihole`, bind mounts, `WEBPASSWORD` via `.env`.  
- First-time Pi-hole operator.

---

## Stage goals

- [ ] Map port 53/tcp/udp and 80; conflicts with `systemd-resolved` or other listeners.  
- [ ] Volume paths: `./etc-pihole`, `./etc-dnsmasq.d` — permissions and backup scope.  
- [ ] Firewall (nftables/iptables) references for Pi OS if applicable.

---

## Methodology

Pi-hole Docker documentation; Pi-hole discourse/wiki for Pi-specific issues; official image env vars.

**Sources**

- [ ] https://github.com/pi-hole/docker-pi-hole  
- [ ] Pi-hole docs  
- [ ] Web search: `pi-hole docker port 53` `systemd-resolved`  

---

## Findings

### Finding 1:

**Source:**

**Relevance:**

---

## Analysis

**Key insights**

- [ ]

---

## Recommendations

- [ ]

---

## Requirements discovered

- [ ]

---

## Next stage

**[Stage 3 — Safety & rollback](research-stage-3-safety-rollback.md)**

---

**Last Updated:** 2026-04-17
