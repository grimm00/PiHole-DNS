# Status & next steps — Layer 0 — Foundation

**Status:** 🟠 In Progress  
**Last updated:** 2026-04-19  

---

## Merged to `main`

| PR | Merged | What shipped |
|----|--------|--------------|
| [#1](https://github.com/grimm00/PiHole-DNS/pull/1) | 2026-04-18 | Runbooks group (Tasks 1–4): `docs/runbooks/` index, backup/restore, minimum deploy, digest workflow; planning updates; Sourcery review capture [`pr1.md`](../../../feedback/sourcery/pr1.md) |

---

## Progress summary

**Overall:** 4/9 tasks complete

| Group | Status | Progress | Notes |
|-------|--------|----------|-------|
| Runbooks — operator procedures | ✅ Complete | 4/4 tasks | Tasks 1–4 done |
| Repository entry points | 🔴 Not Started | 0/2 tasks | |
| Compose and image pin | 🔴 Not Started | 0/2 tasks | |
| Layer 0 closure | 🔴 Not Started | 0/1 tasks | Optional roadmap update |

---

## Next steps

1. **Task 5** — Operator quickstart in root `README.md` + runbook links (`/task 5` or `/task next`).
2. Expand group 2 if needed — `/transition-plan layer-0-foundation --expand --group 2`.
3. Implement — `/task next` on a **feature branch from `develop`** (e.g. `feat/layer-0-foundation`); open PRs against **`develop`**.

---

## Notes

- **Git workflow:** Branch from **`develop`**, merge via PR into **`develop`** (dev-infra–style integration). **`main`** may track releases; PR #1 landed on `main` before `develop` existed.
- Plan generated from ADRs `docs/maintainers/decisions/layer-0-foundation/`, requirements, and [design-layer-0.md](../../../design/layer-0-foundation/design-layer-0.md) on 2026-04-19.
- **After Layer 0 closes:** run the short retrospective in [notes-post-cycle-design-retrospective.md](notes-post-cycle-design-retrospective.md) (what belonged in design before implementation vs only in transition-plan tasks).

---

**Last updated:** 2026-04-19
