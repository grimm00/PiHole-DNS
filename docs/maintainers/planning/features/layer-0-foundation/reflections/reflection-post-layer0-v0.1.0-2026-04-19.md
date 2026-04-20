# Project reflection — Layer 0 — Foundation (post–v0.1.0)

**Scope:** Layer 0 delivery, release **v0.1.0**, and transition to Layer 1  
**Period analyzed:** ~2026-04-17 → 2026-04-19 (research closure through tag, PR #3, post-merge docs, narrative)  
**Generated:** 2026-04-19  

---

## Current state

### Recent activity

- **Layer 0:** ✅ Complete — **9/9** tasks ([`status-and-next-steps.md`](../status-and-next-steps.md)).
- **Merged PRs:** [#1](https://github.com/grimm00/PiHole-DNS/pull/1) → `main` (runbooks), [#2](https://github.com/grimm00/PiHole-DNS/pull/2) → `develop` (MVP remainder), [#3](https://github.com/grimm00/PiHole-DNS/pull/3) → `main` (release **v0.1.0**).
- **Tag:** **`v0.1.0`** on finalize commit; **`main`** and **`develop`** aligned after post-merge doc commits (e.g. narrative refresh).
- **Tests / CI:** Placeholder `tests/`; CI workflows exercise lint/build/test stubs — acceptable for docs-first Layer 0.

### Key metrics

| Metric | Value |
|--------|--------|
| Task groups complete | 4/4 |
| Deferred Sourcery (PR #3) | Overall 3 — `Last updated` metadata normalization (doc hygiene) |
| Opportunities hub | [`layer-0-foundation-learnings.md`](../../../opportunities/layer-0-foundation-learnings.md) |

---

## What worked well

### Uniform planning + honest PR narrative

**Pattern:** `implementation-plan.md` task groups mapped to PR bodies (9/9, group names).  
**Evidence:** PR #2 closure; post-merge status tables for PR #1 vs #2.  
**Keep doing:** Refresh PR **body** from the plan before final review (already called out in learnings).

### Runbooks-first operator safety

**Pattern:** Backup/rollback order, minimum deploy, digest workflow before “fancy” tooling.  
**Evidence:** `docs/runbooks/`, ADR-003/004, FR-3/FR-4/NFR-1 links from `docs/README.md`.  
**Keep doing:** Treat client DNS revert and volume scope as first-class in any future layer.

### Release as documentation

**Pattern:** `/release-prep` → `/release-finalize` → PR #3 → `/post-pr` — changelog, tag, readiness, fix hubs.  
**Evidence:** Root `CHANGELOG.md`, `docs/maintainers/planning/releases/v0.1.0/`, [`fix/pr3/README.md`](../fix/pr3/README.md).  
**Keep doing:** Same skeleton for the next versioned milestone.

### Narrative for apprenticeship

**Pattern:** [`narrative.md`](../../../../narratives/layer-0-foundation/narrative.md) updated to span research → delivery → release.  
**Keep doing:** One story file per major vertical layer when the arc is non-trivial.

---

## Opportunities for improvement

### Operator access path (current vs desired)

**Issue:** Concrete “how do I open a session on the Pi?” (IP discovery, SSH user, password vs key, mobile vs desktop) lived in **muscle memory** more than in a single **design** section. After a break, re-entry cost was real (e.g. IP lookup, auth friction).  
**Impact:** Slow recovery when operating infrequently; Layer 1 (local names, SSH by hostname) will intersect this directly.  
**Suggestion:** In **Layer 1 design/planning**, add an **Operator access** subsection: **current** (`ssh user@ip`, password) vs **desired** (`ssh user@dns-name`, key-pair), plus where keys and naming will live. Link from runbooks when procedures exist.  
**Effort:** Moderate (mostly writing, optional small hardening later).

### Design vs task drift

**Issue:** [`notes-post-cycle-design-retrospective.md`](../notes-post-cycle-design-retrospective.md) — some “how in *this* environment” detail may sit in tasks/runbooks before it appears in design.  
**Impact:** Future readers see procedures before they see the map.  
**Suggestion:** Optional one-page addendum or tighten [`design-layer-0.md`](../../../design/layer-0-foundation/design-layer-0.md) when touching Layer 1 design — not a Layer 0 blocker.

### Status doc freshness

**Issue:** [`status-and-next-steps.md`](../status-and-next-steps.md) still says “Promote … to `main` when you cut a release” — release and post-merge work are **done**.  
**Impact:** Minor confusion for “what’s next.”  
**Suggestion:** Next docs pass: replace with “**v0.1.0** on `main`; next: Layer 1 planning” (or link to roadmap).

### `dt-review` hygiene

**Issue:** Sourcery capture files sometimes need **normalization** after `dt-review`.  
**Impact:** Noise at top of `prN.md`; easy to fix if you know the habit.  
**Suggestion:** Keep normalizing after each run; optional tooling fix later ([learnings](../../../opportunities/layer-0-foundation-learnings.md)).

---

## Potential issues

### Deferred doc consistency (PR #3)

**Risk:** `Last updated` fields out of sync across planning docs.  
**Mitigation:** Schedule a short doc-consistency sweep or fold into Layer 1 edits.  
**Priority:** 🟡 Medium (cosmetic, not blocking).

### Branch-story complexity for newcomers

**Risk:** Historical **PR #1 → `main`** before **`develop`** — documented in planning, but easy to miss.  
**Mitigation:** README/planning hubs already mention it; keep one canonical paragraph when onboarding docs appear.  
**Priority:** 🟢 Low.

---

## Actionable suggestions

### High priority

#### Layer 1: lead with operator access + naming

**Category:** Documentation / Architecture  
**Priority:** 🔴 High  
**Effort:** Moderate  

**Suggestion:** When starting **Layer 1 — Usable** ([roadmap](../../../../../roadmap.md)), open exploration/planning with **SSH/DNS access model** alongside local DNS names (`files.home`, `pihole.home`) so “desired access” and “desired names” evolve together.

**Next steps:**

1. `/explore layer-1-usable` (or amend existing exploration) with themes: local DNS, Compose services, **operator access**.
2. Add **Operator access (current vs desired)** to Layer 1 design when the shape is clear.

**Related:** [`notes-post-cycle-design-retrospective.md`](../notes-post-cycle-design-retrospective.md), discussion on access path.

---

### Medium priority

#### Refresh `status-and-next-steps.md` merge line

**Category:** Documentation  
**Priority:** 🟡 Medium  
**Effort:** Quick  

**Suggestion:** Update merged table / next steps to reflect **v0.1.0 on `main`** and pointer to Layer 1.

---

### Low priority

#### Normalize `Last updated` metadata (deferred from PR #3)

**Category:** Documentation  
**Priority:** 🟢 Low  
**Effort:** Moderate (many files)  

**Suggestion:** Opportunistic sweep; tracked in [`fix/pr3/README.md`](../fix/pr3/README.md).

---

## Recommended next steps

1. **Immediate:** Update [`status-and-next-steps.md`](../status-and-next-steps.md) for post–v0.1.0 reality (optional small PR or direct commit to `develop`).
2. **Short-term:** `/explore layer-1-usable` with input from this reflection (`/explore --from-reflect` on this file when ready).
3. **Long-term:** Layer 1 design section for **access + storage paths** (keys, repo paths, backup units) before deep task breakdown.

---

## Trends and patterns

### Positive

- Documentation-heavy delivery with **versioned release** and **traceable reviews** (`pr1`–`pr3`).
- **Opportunities** hub captures workflow meta-lessons without blocking merge.

### Emerging

- **Operator experience** (access, naming, auth) is the bridge between Layer 0 “it runs” and Layer 1 “it’s usable day-to-day.”

---

**Next reflection:** After Layer 1 planning milestone or first Layer 1 PR merge — suggest **2026-05** or next major vertical completion.

**Last updated:** 2026-04-19
