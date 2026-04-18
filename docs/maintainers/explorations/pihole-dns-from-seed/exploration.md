# Exploration: PiHole-DNS from project seed

**Status:** ✅ Enriched from seed (pre-research; no separate conduct step)  
**Created:** 2026-04-17  
**Source:** [`start.md`](../../../../start.md) — interview status ✅ complete  

**Roadmap:** Project shape and ordering now live in the canonical **[`docs/roadmap.md`](../../../roadmap.md)** (layers, horizontal tracks, open questions). This file remains the seed exploration artifact; use it as input when scoping per-layer explore/research cycles.

---

## What we're exploring

How the interview-captured intent for PiHole-DNS translates into concrete research and decisions: MVP (Layer 0), staged roadmap, deployment and workflow assumptions, and feedback into the dev-infra / seed dogfooding loop. The seed already fixed scope and motivation; this document organizes **what still needs investigation**, not the final answers.

---

## Themes

### Theme 1: Layer 0 — network and MVP cut line

**From the seed:** MVP is static IP on the Pi, Pi-Hole in Docker Compose, DNS working for at least one **opt-in** device. **Current:** Pi on Wi‑Fi only (Ethernet not in use). No Pi-Hole experience yet; conservative rollout to avoid breaking household DNS.

**Why it matters:** Everything else sits on a stable “DNS server is reachable at a known address” foundation. Per-device DNS defers router-level and family-wide risk until confidence exists.

**Leave for research:** DHCP vs static reservation tradeoffs on typical home routers, Pi OS network manager paths, and a minimal validation checklist for “Layer 0 done.”

---

### Theme 2: Observability as the engagement layer

**From the seed:** “Done” day-to-day is still fuzzy, but the user explicitly wants **ongoing engagement** (unlike past “deploy and forget” projects). Observability spans Pi-Hole metrics (queries, blocks) and **platform** health (CPU, memory, containers, uptime). Later layers add dashboards and a wrapper app; observability is the bridge from toy to habit.

**Why it matters:** It drives prioritization after Layer 0 — what to instrument first, what’s good enough for solo use, and what belongs in Layer 2 vs Layer 3.

**Leave for research:** Concrete stacks (lightweight exporters, Pi-friendly agents), what Pi-Hole exposes natively vs what needs add-ons, and sensible “minimum engaging” dashboards for a single operator.

---

### Theme 3: GitOps-lite — repo, registry, Pi

**From the seed:** Repo is source of truth; **GitOps-lite** with images pulled to the Pi (e.g. ghcr.io), **mise** on the Pi for tooling, avoid SSH-and-edit drift. Aligns with platform-engineering learning goals.

**Why it matters:** Shapes CI, secrets, and how much build happens on the Deck/Pi vs in GitHub. Still compatible with Compose-first; doesn’t require K3s for Layer 0.

**Leave for research:** Pragmatic subset for a one-person homelab (when registry + mise kick in vs “git pull on Pi”), secret handling for `WEBPASSWORD` and similar, and alignment with existing OurFileServer patterns.

---

### Theme 4: Roadmap sequencing — Compose, services, K3s, wrapper

**From the seed:** Start with **Docker Compose** (like OurFileServer). Layer 1: local DNS names (`files.home`, `pihole.home`), OurFileServer in the **same** Compose stack. Layer 2: observability. Layer 3: **wrapper application**. **K3s** and real DNS/domain for remote access are explicitly future.

**Why it matters:** Research and ADRs should not front-load orchestration or app work before the staged value is clear. Dependencies between “unified stack,” observability, and the wrapper need ordering without boiling the ocean.

**Leave for research:** Sharp boundaries between layers, migration path from Compose to K3s (if/when), and what “wrapper” means in terms of repos and deployables.

---

### Theme 5: Workflow and seed dogfooding

**From the seed:** Full dev-infra-style pipeline (explore → research → decision → …); feature branches + PRs; AI reviews (Sourcery). Primary dev on **Steam Deck** + Cursor. This repo also tests **seed-based init** and pipeline fit at small scale, feeding learnings back to dev-infra.

**Why it matters:** CI and conventions should match actual deliverables (infra, not npm app). The exploration/research split should stay lean so research owns depth — consistent with deprecating a separate heavy “conduct” pass.

**Leave for research:** Minimal CI that still respects branch rules, how exploration artifacts live under `docs/maintainers/explorations/`, and what to record as dev-infra feedback vs project-only notes.

---

### Theme 6: Operator skills and household risk

**From the seed:** Comfortable with Docker and SSH; **less** with systemd, firewall, packages. Project is partly to grow those skills. Family is secondary users — **conservative** DNS rollout.

**Why it matters:** Runbooks and failure modes (Pi down, bad config) matter as much as happy-path install. Research can surface “safe default” patterns without turning Layer 0 into a networking course.

**Leave for research:** Pi-hole + Docker firewall/port pitfalls, backup scope for `/etc/pihole`, rollback story.

---

## Key questions

1. What is the smallest **verifiable** Layer 0 definition (checklist + tests) on a typical home LAN?
2. For this operator, what observability slice is **worth doing first** after Layer 0 — and what waits for Layer 2?
3. What is the **minimum viable GitOps-lite** path from this repo to the Pi without overbuilding registry/mise before Compose is proven?
4. How should Layers 1–3 be **ordered and scoped** so OurFileServer integration and wrapper work don’t collide?
5. What CI/docs shape fits an **infra-heavy** repo while keeping the dev-infra workflow honest?
6. What operational safeguards (backup, rollback, per-device fallbacks) match **family-risk** constraints?

---

## Spike determination

| Topic | Risk | Spike first? | Rationale |
|-------|------|----------------|-----------|
| Static IP / LAN addressing | MEDIUM-HIGH | Consider | Wrong network config blocks all downstream validation; cheap to try on hardware |
| Registry + mise + Pi deploy | MEDIUM | No for Layer 0 | Can defer partial solutions until Compose + DNS proven |
| Observability stack choice | MEDIUM | No | Research + small experiments likely enough before committing |
| Compose + Pi-hole + host firewall | MEDIUM-HIGH | Consider | Port 53/80 conflicts and `iptables` behavior bite beginners; short spike validates assumptions |

**Risk note:** “Spike” here means time-boxed hands-on validation, not full conduct-style writeups.

---

## Next steps

1. Run structured **research** from [`research-topics.md`](research-topics.md) (prioritize Layer 0 and household-risk items first).  
2. Capture decisions as ADRs when options are comparable.  
3. Feed **seed → explore** learnings to dev-infra separately from project-only docs (Theme 5).

---

**Last Updated:** 2026-04-17
