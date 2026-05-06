# Research: Reverse proxy + TLS (Layer 1 — Usable)

**Status:** ✅ Complete  
**Created:** 2026-05-05  
**Completed:** 2026-05-05  
**Exploration topic:** Candidate topic 2 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

What reverse proxy (Caddy / nginx / Traefik) best fits this stack on the Pi, and what TLS approach works for a LAN (termination, trust model, cert material) without blocking shipping?

---

## Context

- Layer 1 discussion notes point toward subdomain-per-service with a proxy front door.  
- TLS is desired eventually; decisions must account for local trust and operational simplicity.

---

## Topic goals

- [x] Compare proxy options for this use case (simple vhosts, path behavior, usability).  
- [x] Determine a viable LAN TLS approach (or staged approach: HTTP now, HTTPS later).  
- [x] Identify pitfalls for Pi-hole behind a proxy and how to verify.

---

## Methodology

Focused prior art and targeted web research (nginx-centric), with “TLS must not block shipping” as a constraint.

**Sources (checklist)**

- [x] Caddy / nginx / Traefik documentation for reverse proxy + TLS  
- [x] Pi-hole admin UI behind proxy notes / common issues  
- [x] Homelab LAN TLS trust model references (internal CA, etc.)

**Queries executed (web)**

- `nginx reverse proxy Pi-hole docker /admin redirect X-Forwarded-Proto headers configuration`  
- `Pi-hole docker reverse proxy nginx subdomain pihole.example.com without /admin path issues`  
- `Raspberry Pi nginx reverse proxy docker compose multiple services same host ports 80 443 best practice`  
- `internal TLS homelab options self signed internal CA mkcert nginx reverse proxy local domains`

---

## Findings

### Finding 1: Pi-hole’s `/admin` path is a recurring reverse-proxy pitfall; keep hostname-per-service

**Summary**

- Pi-hole expects the admin UI under `/admin/`. Reverse proxies that try to “hide” `/admin` via subpath rewrites commonly hit asset/redirect issues (including double-path `/admin/admin` patterns).  
- A stable pattern is: give Pi-hole its own hostname (subdomain) and proxy the web UI without path mangling; let `/admin` remain `/admin`.

**Source:** Pi-hole docker issues and userspace examples (e.g. `https://github.com/pi-hole/docker-pi-hole/issues/401`, `https://discourse.pi-hole.net/t/pi-hole-v6-nginx-reverse-proxy-issue-admin-dashboard-not-resolving-without-admin-path/77362`)  
**Relevance:** Confirms the project direction away from shared-hostname subpaths and toward subdomain-per-service.

---

### Finding 2: nginx reverse proxy configuration must preserve headers/scheme; include `/api/` and frame headers

**Summary**

- Working nginx configs commonly set `Host`, `X-Forwarded-For`, and (when doing HTTPS termination) `X-Forwarded-Proto`.  
- Some setups also adjust `X-Frame-Options` behavior to avoid UI issues when proxied.

**Source:** nginx+Pi-hole writeups/discussions (e.g. `https://neilzone.co.uk/2025/04/updating-my-nginx-config-for-pi-hole-6x/`, Pi-hole userspace threads)  
**Relevance:** Provides concrete verification points for a Layer 1 proxy implementation and reduces “mysterious UI breaks.”

---

### Finding 3: Homelab reverse proxy prior art favors one proxy on 80/443, backends on an internal network

**Summary**

- Common Compose pattern: one reverse proxy binds host `80` and `443`, while backends do not bind those ports publicly; backends join a shared Docker network and are reached by service name/port from the proxy.  
- Routing is typically host-based (subdomains), which scales cleanly as services are added.

**Source:** selfhosting “reverse proxy multiple services” style guidance (e.g. `https://selfhosting.sh/foundations/reverse-proxy-multiple-services/`) and Raspberry Pi nginx proxy writeups  
**Relevance:** Aligns with “same IP, multiple services” and avoids port collisions when OurFileServer is added.

---

### Finding 4: LAN TLS can be staged; mkcert (local CA) is a pragmatic option when you’re ready

**Summary**

- It’s common to ship internal services on HTTP first, then add TLS once routing is stable.  
- For internal TLS without public ACME/Let’s Encrypt, options include a local CA (e.g. mkcert) + distributing trust to devices, or using proxy tools that support “internal” cert issuance. mkcert is often used for quick local-trust certificates.

**Source:** mkcert (`https://github.com/FiloSottile/mkcert`); homelab HTTPS guides (e.g. `https://selfhosting.sh/foundations/https-everywhere/`)  
**Relevance:** Supports the explicit constraint: “TLS must not block this stage,” while still giving a credible path to HTTPS later.

---

## Analysis

1. **Proxy choice can be nginx without overfitting:** nginx is a solid default if you’re comfortable writing config and want “boring, stable.” Caddy/Traefik remain viable alternatives, but nginx meets the needs for a small number of services.
2. **The biggest risk is URL/path rewriting, not TLS itself:** Most Pi-hole proxy pain comes from `/admin` handling. The safest design is **subdomain-per-service** and avoiding subpath publishing.
3. **Shipping order:** It is reasonable to ship Layer 1 in two steps: (a) reverse proxy + names over HTTP, (b) add LAN TLS when trust distribution is ready. This matches your “don’t let TLS block” requirement.
4. **Colocation readiness:** A host-based nginx reverse proxy on 80/443 sets you up for adding a file server without fighting port collisions; services can be internal-only behind the proxy.

---

## Recommendations

- [ ] **Adopt nginx** as the reverse proxy if you prefer config-as-code and “boring stable”; use host-based routing (subdomains).  
- [ ] **Avoid subpath mounting** Pi-hole (don’t try to make it live at `/pihole`); keep `/admin` intact on the Pi-hole hostname.  
- [ ] **Ship without TLS first** if needed: define Layer 1 success as “names + proxy routing works over HTTP.”  
- [ ] **TLS later:** when ready, add LAN TLS with an explicit trust model (mkcert/local CA, or proxy-native internal issuance), and document “how trust is installed” as operator work.

---

## Requirements discovered

- [ ] **NFR:** Reverse proxy configuration must be low-fragility (prefer host-based routing; minimal path rewriting).  
- [ ] **C:** Reverse proxy should only front web traffic (80/443); DNS (53/tcp+udp) must remain directly reachable.  
- [ ] **C:** TLS is not a Layer 1 blocker; the system must be usable over HTTP while TLS is staged.

---

## Next steps

- Run research-conduct for this topic; extract requirements into [`requirements.md`](requirements.md).

