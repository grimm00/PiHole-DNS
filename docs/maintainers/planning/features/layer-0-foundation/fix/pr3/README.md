# PR #3 follow-up — Release v0.1.0

**PR:** [chore: Release v0.1.0](https://github.com/grimm00/PiHole-DNS/pull/3)  
**Merged:** 2026-04-18 → `main` (default branch now at Layer 0 + release artifacts)

---

## Sourcery review

**Review file:** [`docs/maintainers/feedback/sourcery/pr3.md`](../../../../../feedback/sourcery/pr3.md)

**Status:** Individual grammar + digest/traceability items **addressed** on `release/v0.1.0` before merge; one overall item **deferred**.

| ID | Summary | Priority | Effort | Status |
|----|---------|----------|--------|--------|
| #1 | “an explicit step” grammar | LOW | LOW | Addressed — `layer-0-foundation-learnings.md` |
| Overall 1 | Record upstream tag context for pinned digest | MEDIUM | LOW | Addressed — comment on `image:` in `docker-compose.yml` |
| Overall 2 | `TZ` default vs expectations | LOW | LOW | N/A — documented inline in Compose |
| Overall 3 | Normalize `Last updated` metadata across docs | MEDIUM | MEDIUM | **Deferred** — doc hygiene sweep |

**Action:** Opportunistic follow-up PR when touching planning docs for Layer 1 or a dedicated docs-consistency pass.

---

## After merge

- **`main`** matches **`develop`** at release line (merge commit includes PR #3).
- Optional: publish **GitHub Release** from tag **`v0.1.0`** using [`RELEASE-NOTES.md`](../../../../releases/v0.1.0/RELEASE-NOTES.md).

---

**Last updated:** 2026-04-18
