# Exploration: Layer 1 — Usable

**Status:** 🟡 Themes captured — research pending  
**Created:** 2026-04-19  
**Sources:** [Roadmap](../../../roadmap.md) (Layer 1 — Usable); [post–v0.1.0 reflection](../../planning/features/layer-0-foundation/reflections/reflection-post-layer0-v0.1.0-2026-04-19.md); [Layer 1 precursor discussion learnings](../../planning/opportunities/layer-1-precursor-discussion-learnings.md)

---

## Scope

**In scope**

- **Human-friendly local names** for Pi-hole and colocated services (e.g. family apex + subdomains); **reverse proxy** in Compose; **HTTPS/TLS** as an explicit learning and design topic.  
- **Operator access:** SSH baseline (e.g. key-only), **recovery** when network password login is off, and **clarity** between **SSH** (OS) vs **Pi-hole web UI** (application).  
- **Runbooks as usability:** maintenance and security guidance that matches how the stack is actually operated — not only ad hoc fixes; Layer 1 delivers **sliced** task groups so “usability” stays bounded.  
- **Discovery and canonical addressing:** how an operator (or **someone else**) finds the Pi when the IP or hostname is unknown — a **runbook ladder** (preferred paths first, scans/tools mid-chain, break-glass last).  
- **OurFileServer** (or equivalent) in the **same** Compose stack where it fits the roadmap outcome.

**Out of scope** (defer to roadmap / later layers)

- Full observability platform (Layer 2); wrapper app (Layer 3); K3s.

**Environment note:** Same assumptions as Layer 0 where relevant (Pi on Ethernet; opt-in clients may be Wi‑Fi).

---

## Themes

### Theme 1: Local naming, reverse proxy, TLS

**From the reflection (discussion notes 2026-04-19):** Prefer a **family apex** with **one subdomain per service** (e.g. `dns.example.home`, `files.example.home`) over multiple apps behind one hostname with path prefixes. Include a **reverse proxy** in Compose; plan **HTTPS** with clear decisions on **termination**, **local trust**, and **cert material**. Document **53 vs 80/443** once for operators (DNS vs browser traffic).

**Leave for research:** Proxy choice and Pi-hole vhost behavior; TLS options for LAN (internal CA, Caddy, etc.).

---

### Theme 2: Operator access — SSH vs Pi-hole UI, recovery

**From precursor learnings:** Key-only SSH implies **out-of-band recovery** (console, offline `authorized_keys`, break-glass keys, multiple keys) — not “another password on SSH.” Pi-hole **web** auth is a **different surface** from SSH; DNS control remains high impact even when the UI is “app-scoped.”

**Leave for research / runbooks:** Exact SSH posture for this repo; what to document per surface; recovery checklists.

---

### Theme 3: Runbooks and planning shape

**From discussion:** Ad hoc runbook edits for one-off fixes; avoid an unbounded **“Layer 0.5”** unless time-boxed; Layer 1 as **usability umbrella** with **explicit task groups** (naming, access, runbooks, security baseline).

**Leave for research:** Which runbook sections get updated in Layer 1 vs later; template for “operator discovery.”

---

### Theme 4: Discovery ladder and canonical addressing

**Problem:** Operators sometimes **do not know** the Pi’s current IP or name (new device, router reset, long absence). **Network analyzers / scanners** are useful **mid-chain** discovery tools but should not be the only documented path.

**Runbook ladder (preferred order to document):**

1. **Name-first / reservation-first** — Local DNS or **mDNS** (`*.local`) when available; **DHCP reservation label** on the router (human-readable name next to the lease).  
2. **Router admin** — Client list / DHCP leases / reservation table (often fastest when LAN access works).  
3. **Active scan / analyzer** — e.g. net-analyzer-class tools on the subnet when the above fail.  
4. **Break-glass** — Serial, HDMI+keyboard, or offline media (aligns with SSH recovery themes).

**Handoff / fragility:** A **memorable low-number IP** from DHCP reservation helps **one** operator’s memory but is **fragile for others** unless the same facts live in a **single canonical place** (repo runbook or design — not oral tradition). Prefer **documented procedure** + **friendly reservation name** over “everyone memorizes the fourth octet.”

**Leave for research:** Which steps belong in which runbook; optional one-page “operator card” pattern; how Layer 1 **local names** reduce dependence on raw IPs.

---

## Key questions

1. What **hostname scheme** and **proxy layout** minimize Pi-hole and file-server integration pain?  
2. What **TLS** approach matches homelab learning goals without blocking shipping?  
3. What **SSH + web** posture and **recovery** steps belong in **Layer 1** runbooks vs deferred hardening?  
4. What is the **minimum discovery ladder** every operator-facing runbook should link or repeat?  
5. Where is the **canonical** “how to reach the Pi” truth (IP, name, reservation label) maintained for **future you and others**?

---

## Inputs (do not duplicate wholesale)

| Artifact | Role |
|----------|------|
| [Reflection post–Layer 0 v0.1.0](../../planning/features/layer-0-foundation/reflections/reflection-post-layer0-v0.1.0-2026-04-19.md) | Naming, proxy, TLS, `/explore` theme list |
| [Layer 1 precursor discussion learnings](../../planning/opportunities/layer-1-precursor-discussion-learnings.md) | SSH recovery, UI vs SSH, planning shape |

---

**Last updated:** 2026-04-19
