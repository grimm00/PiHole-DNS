# Research: Local DNS + names (Layer 1 — Usable)

**Status:** ✅ Complete  
**Created:** 2026-05-05  
**Completed:** 2026-05-05  
**Exploration topic:** Candidate topic 1 — [Layer 1 research-topics](../../explorations/layer-1-usable/research-topics.md)

---

## Research question

How do local apex + subdomains get defined (Pi-hole DNS records, router, split DNS), and how should this repo align with roadmap examples like `files.home` and `pihole.home`?

---

## Context

- Layer 1 outcome: human-friendly names for services (Pi-hole and file server).  
- Names interact with operator discovery and long-term maintainability (who can find what, when the router changes, etc.).

---

## Topic goals

- [x] Identify the simplest workable naming scheme for this homelab.  
- [x] Determine where records should live (Pi-hole, router, other).  
- [x] Document how naming reduces reliance on raw IPs while keeping a recovery path.

---

## Methodology

Focused web research + prior-art review:

- Prefer one “canonical” place for local records so backups and recovery are obvious.
- Keep the naming scheme simple enough to be used by a second operator in the future.

**Sources (checklist)**

- [x] Pi-hole local DNS / DNS records documentation  
- [x] Router/DHCP reservation and DNS integration references (conditional forwarding prior art)  
- [ ] Notes from this repo’s current operator practice

**Queries executed (web)**

- `Pi-hole Local DNS Records custom.list hosts dnsmasq.d precedence custom CNAME records where stored`  
- `Pi-hole v6 Local DNS Records page dns_records.php custom.list v6 web interface storage`  
- `Pi-hole API customdns customcname add delete get auth`  
- `Pi-hole conditional forwarding local domain router DHCP name resolution pros cons`  
- `home network use .home domain risks leakage collision RFC 8375 why home.arpa recommended`

---

## Findings

### Finding 1: `.home` works in practice, but `home.arpa` is the standards-backed homenet domain

**Summary**

- For a homelab, using `.home` (or a personalized apex like `katdog.home`) will function as long as all clients query your resolver.  
- Standards guidance exists: RFC 8375 designates `home.arpa` and replaced earlier `.home` recommendations due to collision/leakage concerns.

**Source:** RFC 8375 (`https://rfc-editor.org/rfc/rfc8375.txt`)  
**Relevance:** Supports making `.home` a **deliberate choice** (with a documented alternative if you ever change course).

---

### Finding 2: Pi-hole supports local DNS via UI and on-disk config; v6 storage is more “managed”

**Summary**

- Pi-hole provides a UI for local DNS records and CNAME records; there are also on-disk mechanisms (dnsmasq config and host files).  
- In Pi-hole v6, local DNS record data is increasingly represented in managed config (e.g. `pihole.toml`) and/or managed host files under `/etc/pihole/…`, rather than only a simple `custom.list`.

**Source:** Pi-hole config docs (`https://docs.pi-hole.net/ftldns/configfile`); Pi-hole web/issues/discourse (e.g. `https://discourse.pi-hole.net/t/local-dns-records/74898`)  
**Relevance:** Impacts “Git-shaped config”: direct file editing can work but may be rewritten/normalized by FTL in v6.

---

### Finding 3: Conditional forwarding is a useful integration point, but adds coupling and failure modes

**Summary**

- Conditional forwarding can resolve local hostnames by forwarding queries for a local domain/range to your router/DHCP server.  
- It can introduce coupling issues (loops/complexity) in multi-Pi-hole or redundant DHCP setups; UI support may be limited depending on version.

**Source:** Pi-hole Userspace discussions (e.g. `https://discourse.pi-hole.net/t/local-dns-vs-conditional-forwarding/62473`)  
**Relevance:** Suggests a “simple first” approach: for a small set of service names, explicit local records in Pi-hole may be lower-risk than relying on router integration.

---

### Finding 4: Pi-hole API can manage local DNS/CNAME records (auth required)

**Summary**

- Pi-hole exposes API endpoints to add/delete/list custom DNS and CNAME records (requires an auth token / password-based auth parameter).

**Source:** Pi-hole API docs (`https://docs.pi-hole.net/api/`) and AdminLTE PRs linked therein  
**Relevance:** Enables future automation without manually editing files or clicking UI—useful if you want “GitOps-lite” workflows later.

---

## Analysis

1. **Naming scheme can be simple and still future-proof:** Keep **one hostname per service** (e.g. `dns.<apex>`, `files.<apex>`). Whether the apex ends in `.home` or `home.arpa` is secondary; what matters is documenting the choice and having an escape hatch.
2. **Prefer one canonical record source for “service names”:** For a small number of curated service names, store them in **Pi-hole’s managed local DNS mechanism** (UI/API) so they are discoverable and less likely to be overridden by other sources. Treat router integration (conditional forwarding) as optional, not required.
3. **Backups and persistence are the deciding factor:** Whatever mechanism you pick, you must be able to restore it from the repo’s persisted mounts (and know where the truth lives). Pi-hole v6’s “managed config” implies that the UI/API route may actually be *more stable* than hand-editing internal files that FTL rewrites.

---

## Recommendations

- [ ] **Deliberate apex choice:** Use `.home` for now if desired (memorable), but document `home.arpa` as the standards alternative and `.local` as mDNS-reserved.  
- [ ] **Service naming convention:** Use subdomains (hostname-per-service) rather than path-based routing.  
- [ ] **Record ownership:** Put a small curated set of service records in Pi-hole’s **local DNS UI/API** (the “canonical” source).  
- [ ] **Router integration:** Treat conditional forwarding as optional; only adopt it if you explicitly want “resolve DHCP hostnames” behavior and accept the coupling.  
- [ ] **Backup note:** Ensure whichever record store is used is included in the persisted mount backup scope and documented in the operator model.

---

## Requirements discovered

- [ ] **FR:** System must support local service names that are stable across reboots and router changes (as long as Pi-hole remains the resolver).  
- [ ] **NFR:** Naming choices must be documented as deliberate (domain choice + escape hatch) to reduce future migration cost.  
- [ ] **C:** Avoid `.local` for the primary homenet domain because it overlaps with mDNS behavior.

---

## Next steps

- Run research-conduct for this topic; extract requirements into [`requirements.md`](requirements.md).

