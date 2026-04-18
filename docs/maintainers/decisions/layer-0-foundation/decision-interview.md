# Decision interview — Layer 0 — Foundation

**Purpose:** Capture operator choices and confirmations before ADRs are marked **Accepted**. Same *shape* as [`start.md`](../../../../start.md) (sectioned interview log → derived decisions). Aligns with dev-infra’s direction on **agentic workflow modernization**: structured prompts for explore / research / **decision** so humans and agents share a clear checklist.

**Status:** 🟡 Interview in progress — **§1–2 complete**; §3–6 pending  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

**Feeds:** [requirements.md](../../research/layer-0-foundation/requirements.md) (Final) → ADRs in this directory.

---

## What research already decided (facts, not forks)

Use this as shared context during the interview. **Forks** belong in the log below.

| Area | Research outcome |
|------|-------------------|
| **Stack** | Pi-hole **v6**, `pihole/pihole`, Compose, `FTLCONF_*`, ports **53/80**, persist `./etc-pihole`, optional `./etc-dnsmasq.d` with `FTLCONF_misc_etc_dnsmasq_d` — see **FR-2**, Stages 0 & 2. |
| **Safety** | Order of rollback: client DNS → compose down → restore volumes / Teleporter — see **FR-3**, Stage 3. |
| **Deploy (Track A)** | Minimum path: `git` + `.env` + `docker compose`; pin/cache images per **NFR-1** after verify — Stage 4, **FR-4**. |
| **Constraint** | **C-1:** Prefer [Pi-hole Docker docs](https://docs.pi-hole.net/docker/) over random tutorials for port conflicts and upgrades. |

**Seed alignment:** [`start.md`](../../../../start.md) **D2** (staged architecture), **D3** (GitOps-lite direction), **D5** (Ethernet, static IP prerequisite). This interview narrows **Layer 0** where research left **either/or** or **timing** open.

---

## Interview log

Answers go under each prompt. Add rationale (“why”) where it affects ADRs or runbooks.

### Section 1 — Stable LAN IPv4 (FR-1, ADR-001)

<a id="section-1"></a>

**1.1 — Which mechanism do you commit to for Layer 0: DHCP reservation (router) or static IP on the Pi (e.g. NetworkManager)?**

> I've already reserved an IP address for the pi.
>
> **Recorded for ADR-001:** Layer 0 uses **DHCP reservation on the home router** so the Pi receives a **fixed LAN IPv4** on Ethernet. *(If your setup were instead a **static IP configured only on the Pi** via NetworkManager, update this line and ADR-001.)*

**1.2 — Document the chosen facts for the runbook: Pi MAC (if reservation), reserved IP, interface name (Ethernet), and how you’ll verify after reboot.**

> Verification is done: **192.168.50.2** is shown on **eth0** when using `ip address` (or `ip addr`). Also confirmed by reaching the file server at that IP (correct port) and **SSH**. Omit **MAC** or other identifiers from public docs if needed; keep full facts in private operator notes.

**1.3 — Any constraint from your router or LAN that overrides Stage 1 assumptions (e.g. no DHCP reservation UI)?**

> Nothing that I've run into so far. 

---

### Section 2 — Pi-hole Compose baseline (FR-2, ADR-002)

<a id="section-2"></a>

**2.1 — Confirm acceptance of the researched Compose baseline** (`FTLCONF_dns_listeningMode`, password env, `./etc-pihole` persistence, `./etc-dnsmasq.d` if used). Anything you want **explicitly different** from [docker-compose.yml](../../../../docker-compose.yml) for Layer 0?

> No, not that I can think of. 

**2.2 — If bind-mount paths or env names change, list them here so ADR-002 and implementation stay aligned.**

> May be a question that ultimately gets answered during the design step. For my file server, I use a partition on an external drive connected to the pi.
>
> **Recorded for ADR-002:** That layout applies to the **existing file-server stack**, not a Layer 0 change to Pi-hole. For Layer 0, Pi-hole keeps **repo-relative** bind mounts as in [`docker-compose.yml`](../../../../docker-compose.yml) (`./etc-pihole`, `./etc-dnsmasq.d`). Moving Pi-hole volume roots (e.g. onto another disk) is **out of scope for this ADR** unless/until a later design or layer explicitly changes it.

---

### Section 3 — Backup & rollback runbook (FR-3, ADR-003)

<a id="section-3"></a>

**3.1 — Where will the Layer 0 runbook live** (e.g. `README.md`, `docs/…`, separate `RUNBOOK.md`)?

> docs/runbooks/

**3.2 — Teleporter: optional only, or required in your household process?**

> Let's make this required. 

**3.3 — Anything to add beyond FR-3** (scheduling, reminders, family-facing steps)?

> No, but ideas can be captured for later dev cycles. 

---

### Section 4 — Minimum deploy & image policy (FR-4, NFR-1, ADR-004)

<a id="section-4"></a>

**4.1 — After first successful deploy, what is your concrete pin strategy for `pihole/pihole`:** date tag, digest, or “record digest in docs after pull”?

> A digest just because I'm trying to get into the practice of matching what I do for work. 

**4.2 — Confirm deferral of mise / private registry / ghcr for Layer 0** unless a trigger from Stage 4 applies (multi-host, air-gap, team).

> I will confirm. 

**4.3 — Where do operators find the “minimum deploy” steps** (same doc as 3.1 or dedicated)?

> In docs. I actually have a fuzzy idea of a better place but for now, this is good. 

---

### Section 5 — Horizontal tracks × quality (optional overlay)

<a id="section-5"></a>

*Not every quality attribute needs an answer here. Use this section to note which [roadmap tracks](../../../../roadmap.md#horizontal-tracks-cross-cutting) this Layer 0 decision set touches and any extra assurance you want documented.*

**Reference — quality attributes in this repo:** [quality-attributes.md](../../quality-attributes.md) (track × attribute table, Layer 0 FR/NFR mapping, optional ISO 25010 checklist).

**5.1 — Tracks A–D: anything you want explicitly called out for Layer 0 ADRs** (e.g. Track D family-risk, Track A pin timing)?

> *[Answer]*

**5.2 — Any quality attribute from dev-infra’s catalog you want as an explicit acceptance criterion for implementation review?**

> *[Answer]*

---

### Section 6 — Meta & handoff

<a id="section-6"></a>

**6.1 — Ready to mark ADR-001 … ADR-004 **Accepted** after wording pass, or any ADR to split/merge?**

> *[Answer]*

**6.2 — Feedback for dev-infra** (pipeline fit, this interview format): one bullet.

> *[Answer]*

---

## Derived decisions (post-interview)

*Add remaining DD* entries after §3–6. §1–2 map below.*

### DD1: Stable LAN via DHCP reservation (FR-1)

Operator uses **DHCP reservation** on the home router; Pi is verified at **192.168.50.2** on **eth0** (see §1). **ADR-001** documents the choice and verification approach; sensitive identifiers stay out of public docs.

### DD2: Compose baseline unchanged for Layer 0 (FR-2)

Operator accepts the researched **Pi-hole v6** Compose baseline **as in repo** (§2.1). External-drive partitioning for **OurFileServer** does not alter Pi-hole bind mounts for Layer 0 (**ADR-002**); any relocation of Pi-hole data paths is deferred to design / later layers unless explicitly decided.

---

## Related artifacts

| Artifact | Location |
|----------|----------|
| Research summary | [research-summary.md](../../research/layer-0-foundation/research-summary.md) |
| Requirements | [requirements.md](../../research/layer-0-foundation/requirements.md) |
| Roadmap | [roadmap.md](../../../../roadmap.md) |
| Seed interview | [start.md](../../../../start.md) |
| Dev-infra dogfooding issue | [dev-infra#78](https://github.com/grimm00/dev-infra/issues/78) |

---

**Last Updated:** 2026-04-18
