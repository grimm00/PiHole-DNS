# Sourcery Review — PR #4

**Generated:** 2026-06-02  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/4  
**Branch:** `spike/layer-2-observable` → `develop`  
**Note:** `dt-review` was not available in PATH; this file was assembled from GitHub PR review data (Sourcery bot comments + reviewer's guide).

---

## Summary

| Type | Count |
|------|------:|
| Individual inline comments | 1 |
| Overall / review guide | 1 (file-level summary) |

**CI:** All checks passing (build, lint, test, Sourcery review, branch type).

---

## Individual Comments

### Comment #1 — Dashboard label bullets under wrong exporter heading

**File:** `docs/maintainers/planning/features/layer-2-observable/spike-outcomes.md` (line 51, § pihole-exporter)

**Issue:** The bullet listing `container_state{name="pihole"}` and `container_memory_working_set_bytes{name="pihole"}` sits under **pihole-exporter (Mosher-Labs)**. Those metrics come from **docker-exporter**, not Mosher-Labs.

**Suggestion:** Move the bullet under the **docker-exporter** subsection, or add explicit text that these are docker-exporter dashboard filters (cross-reference H5/H6 in Task 3 mapping).

**GitHub:** https://github.com/grimm00/PiHole-DNS/pull/4#discussion_r3344642486

---

## Overall Comments (Reviewer's Guide)

Sourcery's guide summarizes the PR accurately: Group 1 tasks expanded and completed; `spike-outcomes.md` introduced as curated handoff; status/plan updated; learning log appended in `notes/spike-l2.md`. No additional actionable issues beyond Comment #1.

---

## Priority Matrix Assessment

| Comment | Priority | Impact | Effort | Action |
|---------|----------|--------|--------|--------|
| #1 — docker-exporter metrics under pihole-exporter heading | 🟢 LOW | 🟡 MEDIUM (doc clarity) | 🟢 LOW | **Addressed** — moved to docker-exporter § (2026-06-02) |

### Per-comment detail

**Comment #1**

**Priority:** LOW 🟢  
**Impact:** MEDIUM 🟡 — wrong section may confuse Group 2 implementer wiring Grafana/Prometheus labels  
**Effort:** LOW 🟢 — one-line move or parenthetical in `spike-outcomes.md`  
**Action:** Addressed — bullet moved under docker-exporter § Group 2 handoff.

### Priority reference

- 🔴 **CRITICAL:** Security, stability, or core functionality  
- 🟠 **HIGH:** Bug risks or significant maintainability issues  
- 🟡 **MEDIUM:** Documentation consistency / operator confusion  
- 🟢 **LOW:** Nice-to-have clarity  

---

## Manual testing

**Not applicable** — docs-only PR (Group 1 planning artifacts). No manual testing guide required.

---

## Merge recommendation

**Approve** — Comment #1 addressed.
