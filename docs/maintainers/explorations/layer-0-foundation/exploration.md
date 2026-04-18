# Exploration: Layer 0 — Foundation (MVP)

**Status:** ✅ Scoped to Layer 0; research **Stages 0–4** complete; [requirements](../../research/layer-0-foundation/requirements.md) **Final**  
**Created:** 2026-04-17  
**Sources:** [Roadmap](../../../roadmap.md) (Layer 0 — Foundation); [pihole-dns-from-seed](../pihole-dns-from-seed/exploration.md)

---

## Scope

**In scope**

- Stable IP story for the Pi (DHCP reservation vs static configuration on Pi OS).  
- Pi-hole running via this repo’s [`docker-compose.yml`](../../../../docker-compose.yml): ports, volumes, secrets (e.g. `FTLCONF_webserver_api_password` via `.env`), host firewall / port 53 conflicts.  
- Proof that **one device** uses Pi-hole for DNS **by choice** (not router-wide).  
- Minimal **safety / rollback** posture for this layer: what to back up, what to do when DNS is wrong (Track D, L0-only slice).  
- **Smallest viable** deploy-from-repo story (Track A): enough GitOps-lite that the Pi matches the repo (no one-off edits that drift from git) without overbuilding registry/mise before Compose works.

**Out of scope** (defer to roadmap / later explorations)

- Local service names (`*.home`), OurFileServer merge, observability stack, wrapper app, K3s.

**Environment note:** Pi is on **Ethernet** (wired LAN). Opt-in **clients** may be Wi‑Fi (e.g. Steam Deck) as long as they reach the Pi’s LAN IP.

---

## Themes

### Theme 1: Stable addressing on the LAN

**From the roadmap:** Layer 0 needs a **stable** way to reach the Pi before DNS clients can point at it reliably.

**Leave for research:** Router DHCP reservation vs static IP on the Pi; validation checklist (“Layer 0 done”); **Ethernet** MAC / `nmcli` profile for the wired interface.

---

### Theme 2: Pi-hole in Docker Compose on Raspberry Pi OS

**From the roadmap:** Pi-hole runs in Compose with persistent config and predictable ports.

**Leave for research:** Official Pi-hole + Docker guidance; volume layout; port 53/80 and conflicts with `systemd-resolved` or other listeners; v6 **`FTLCONF_*`** env handling.

---

### Theme 3: Household safety and rollback (L0)

**From Track D:** Conservative rollout; family not on Pi-hole until you opt devices in deliberately.

**Leave for research:** What to back up before changes; how to revert client DNS; firewall commands/docs references for Pi OS.

---

### Theme 4: Minimum deploy path from repo (Track A, L0)

**From Track A:** Repo is source of truth; avoid undrifted one-off edits on the Pi.

**Leave for research:** Practical minimum (e.g. `git pull` + `docker compose up`) vs image pull from registry for this phase; where secrets live.

---

## Key questions

1. What is the **smallest verifiable** “Layer 0 complete” checklist on a typical home LAN?  
2. How should the Pi get a **stable address** on **Ethernet** (DHCP reservation vs host static)?  
3. What Compose/host settings **must** hold for Pi-hole to serve DNS and admin UI reliably on Pi OS?  
4. What **backup / rollback** steps match conservative household risk?  
5. What is the **minimum** repo-to-Pi workflow for Layer 0 without front-loading registry/mise?

---

## Spike determination

| Topic | Risk | Spike first? | Rationale |
|-------|------|----------------|-----------|
| LAN addressing / DHCP | Medium–high | Consider | Wrong network config blocks everything downstream |
| Port 53 / firewall / resolved conflicts | Medium–high | Consider | Common failure mode for first-time Pi-hole on Linux |
| Full GitOps + ghcr + mise | Medium | No | Defer past “Compose + DNS works” unless blocking |

---

## Next steps

1. [Layer 0 ADRs](../../decisions/layer-0-foundation/README.md) **Accepted** — implement [runbooks](../../../runbooks/README.md) and deploy steps.  
2. Update [roadmap](../../../roadmap.md) Layer 0 status when MVP criteria are met.

---

**Last Updated:** 2026-04-19
