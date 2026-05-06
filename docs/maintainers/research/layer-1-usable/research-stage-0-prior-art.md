# Research — Stage 0: Prior art & existing patterns (Layer 1 — Usable)

**Layer:** 1 — Usable  
**Status:** ✅ Complete  
**Created:** 2026-05-05  
**Completed:** 2026-05-05  
**Exploration context:** [`layer-1-usable`](../../explorations/layer-1-usable/README.md)

---

## Research question

What existing implementations and patterns (in this repo, OurFileServer, and common homelab practice) should inform Layer 1 so we can adopt the simplest viable approach for naming, proxy/TLS, operator access, and service colocation?

---

## Context

Layer 0 has been stable for real-world use. Layer 1 expands scope (local names, optional reverse proxy/TLS, and a file server in the same stack). Stage 0 is meant to **reduce reinvention** and anchor decisions to practices that are already known to work.

---

## Stage goals

- [x] Capture “adopt / adapt / avoid” for local naming strategies (`*.home`, subdomains, record location).  
- [x] Capture prior art for reverse proxy + LAN TLS (including “HTTP-first then TLS” staging).  
- [x] Capture operator access baseline patterns (SSH posture, recovery) that are appropriate for a homelab Pi.  
- [x] Capture prior art for colocating services in one Compose stack on a Pi (resource/port concerns, rollback).  
- [x] Identify any conventions from OurFileServer that should be treated as “upstream” for this repo (Track A parity).

---

## Methodology

Stage 0 should be fast and pragmatic:

- Read existing docs in this repo that already encode working patterns (Layer 0 research + ADRs + runbooks).  
- Review the OurFileServer repo’s deployment habits (Compose layout, env/secrets, volumes, update workflow).  
- Use targeted web research only to fill gaps (proxy choice comparisons, LAN TLS trust options, Pi-hole behind proxy caveats).

**Sources (checklist)**

- [ ] Layer 0 research and ADRs (this repo)  
- [ ] Layer 0 runbooks (this repo)  
- [ ] OurFileServer repo docs / Compose examples  
- [x] Pi-hole docs relevant to local DNS records and reverse proxies  
- [x] Reverse proxy docs / examples (Caddy / Traefik; homelab comparisons)  
- [x] LAN TLS trust model references (`home.arpa`, internal CA / local trust)

**Queries executed (web)**

- `Pi-hole local DNS records CNAME A record local domain home.arpa configuration`  
- `RFC 8375 home.arpa residential domain recommended over .home or .local`  
- `Caddy reverse proxy Pi-hole admin interface /admin local network TLS internal CA`  
- `Traefik vs Caddy vs Nginx reverse proxy homelab docker compose Raspberry Pi TLS local domains`  
- `Pi-hole custom.list local DNS record order /etc/pihole/custom.list /etc/dnsmasq.d priority`  
- `Pi-hole docker reverse proxy /admin redirect base URL path issues`  
- `OpenSSH disable password authentication recovery console authorized_keys break glass key best practice`

---

## Findings

### Finding 1: Prefer `home.arpa` (RFC 8375) over `.home`; don’t confuse `.local`

**Summary**

- RFC 8375 designates **`home.arpa.`** as the special-use domain for residential networks and explicitly replaces earlier `.home` guidance due to collisions and leakage concerns.

**Source:** RFC 8375 (`https://rfc-editor.org/rfc/rfc8375.txt`)  
**Relevance:** Informs Layer 1 naming defaults: if you want a standards-backed “home domain,” prefer `home.arpa` rather than inventing `.home` or relying on `.local` (mDNS).

---

### Finding 2: Pi-hole supports local A/CNAME records via UI and on-disk files; precedence matters

**Summary**

- Local DNS records can be managed via Pi-hole’s UI and/or persisted in on-disk files (e.g. `/etc/pihole/custom.list`, config under `/etc/dnsmasq.d/`).  
- Precedence exists: `/etc/dnsmasq.d/` is processed before `/etc/pihole/custom.list`, and not every method shows up in the UI.

**Source:** Pi-hole config docs (`https://docs.pi-hole.net/ftldns/configfile`); discussion and examples surfaced via web search queries above  
**Relevance:** Decides *where* “truth” for local names should live (UI-managed vs file-managed) given the repo’s desire to keep configuration Git-adjacent and recoverable.

---

### Finding 3: Pi-hole’s Docker repo includes first-party reverse proxy examples (Caddy)

**Summary**

- The official `pi-hole/docker-pi-hole` repo includes example configurations for running Pi-hole behind a reverse proxy (including a Caddyfile example and docker-compose example).  
- Proxy the **web UI**; keep DNS (53/tcp+udp) direct on the LAN.

**Source:** `https://github.com/pi-hole/docker-pi-hole/blob/master/examples/docker-compose-caddy-proxy.yml`; `https://github.com/pi-hole/docker-pi-hole/blob/4decae85/examples/Caddyfile`  
**Relevance:** Strong prior art for “subdomain-per-service + reverse proxy + optional `tls internal`” without inventing a novel pattern.

---

### Finding 4: `/admin` path behavior is a common reverse-proxy foot-gun; prefer vhost-per-service

**Summary**

- Pi-hole’s web UI historically assumes `/admin`; reverse proxies that add/strip prefixes incorrectly can cause redirect loops like `/admin/admin`.  
- Many setups avoid subpath mounting by using **a dedicated hostname** for Pi-hole and letting `/admin` remain unchanged.

**Source:** `https://github.com/pi-hole/docker-pi-hole/issues/401`; `https://github.com/pi-hole/docker-pi-hole/issues/647`  
**Relevance:** Supports the earlier discussion outcome: **subdomains over shared paths** (cleaner than `katdog.home/dns/...` style routing).

---

### Finding 5: Homelab proxy tradeoff prior art (Caddy vs Traefik vs nginx/NPM)

**Summary**

- Caddy tends to be favored for **simple, readable config** and “automatic HTTPS” ergonomics; Traefik for label-driven Docker integration; nginx/NPM for GUI/legacy familiarity.  
- Resource footprint and complexity vary; the “few services on one Pi” case often aligns with simpler configuration-first proxies.

**Source:** Homelab comparisons (e.g. `https://www.virtua.cloud/learn/en/concepts/traefik-caddy-nginx-docker-reverse-proxy`)  
**Relevance:** Helps pick a default proxy for Layer 1 that matches “low-touch appliance” rather than “infrastructure platform.”

---

### Finding 6: Key-only SSH “fallback” is recovery-oriented; break-glass exists but may be overkill here

**Summary**

- Common hardening advice: disable password authentication only after verifying an alternative access path and recovery plan (console, offline edit, additional key).  
- Certificate-based break-glass approaches exist, but may exceed homelab needs unless you’re practicing PKI intentionally.

**Source:** Smallstep “SSH emergency access” (`https://smallstep.com/blog/ssh-emergency-access`); general SSH hardening references found via web search  
**Relevance:** Reinforces the operator model theme: “fallback” means **out-of-band recovery**, not a second network password.

---

## Analysis

1. **Naming default:** If the project wants a standards-backed default domain, `home.arpa` is the clean baseline. If you want a personalized apex (e.g. `katdog.home`), treat it as a deliberate choice with known tradeoffs (possible collisions/leakage) rather than an assumed default.
2. **Local records persistence:** There are multiple Pi-hole-supported ways to store local DNS mappings; the key decision is whether to privilege UI-managed configuration (discoverable, but less Git-shaped) or file-managed configuration (Git-shaped, but may be less visible in UI depending on location).
3. **Reverse proxy posture:** Prior art heavily favors **hostnames per service** with minimal path rewriting. This aligns with Pi-hole’s `/admin` assumptions and reduces subtle proxy bugs.
4. **TLS staging:** “HTTP-first, TLS later” is a valid staged plan if it prevents shipping. When adopting TLS, internal CA / local trust and cert material become part of the operator model, not a proxy-only detail.
5. **SSH posture:** Key-only SSH is reasonable, but only if the project explicitly documents recovery paths. Avoid “security by deleting the ladder.”

---

## Recommendations (adopt / adapt / avoid)

### Adopt

- **Hostname-per-service** (e.g. `dns.<apex>`, `files.<apex>`) and keep Pi-hole’s `/admin` unchanged.  
- Use **Stage 0** conclusions as defaults in Topic 1–7 to reduce thrash.

### Adapt

- **Domain choice:** prefer `home.arpa` by default; allow a personalized apex if you accept the tradeoff and document it.  
- **Local DNS record storage:** choose a single “canonical” place (UI-managed records vs file-managed) and document precedence and backup scope accordingly.

### Avoid (unless strongly justified)

- Path-prefix mounting Pi-hole under a shared hostname (higher risk of redirects and brittle rewrites).  
- Disabling SSH password auth without a written recovery ladder (console/offline keys).

---

## Requirements discovered

- [ ] **FR:** System should support stable, human-friendly service names (hostname-per-service) for Pi-hole and colocated services.  
- [ ] **C:** DNS on port 53 must remain directly reachable on LAN even if web UI is reverse proxied.  
- [ ] **NFR:** Operator UX should avoid brittle reverse-proxy path rewriting (prefer vhosts/subdomains).  
- [ ] **A:** Either `home.arpa` is acceptable as the homenet domain, or a personalized apex is used with documented tradeoffs and recovery.

---

## Next steps

- After Stage 0, proceed to Topic 1–7 conduct, using Stage 0 conclusions as defaults to reduce thrash.

