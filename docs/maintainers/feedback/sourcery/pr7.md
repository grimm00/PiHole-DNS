# Sourcery Review — PR #7

**Generated:** 2026-06-04 (`/pr-validation 7`)  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/7  
**Branch:** `fix/arm64-pihole6-exporter-build` → `develop`  
**Note:** `dt-review` not in PATH; content from GitHub PR review + inline comments (`gh api`).

---

## Summary

| Type | Count |
|------|------:|
| Individual inline comments | 3 |
| Review guide (overall) | 1 |

**CI:** build, lint, test, Detect Branch Type, Sourcery review — **passing**. `mergeStateStatus`: **CLEAN**.

---

## Individual Comments

### Comment 1 — `docker/pihole6-exporter/Dockerfile` line 5

**Issue:** Pin Python package versions for reproducible/safer builds (`prometheus_client`, `requests`, `urllib3` unpinned).

**Priority:** MEDIUM  
**Impact:** MEDIUM  
**Effort:** LOW  
**Action:** **Fixed** — pinned `prometheus_client==0.21.1`, `requests==2.32.3`, `urllib3==2.4.0`.

### Comment 2 — `docker/pihole6-exporter/Dockerfile` line 9

**Issue:** `ADD` from remote URL — network coupling, no checksum, offline build failure.

**Priority:** HIGH  
**Impact:** HIGH  
**Effort:** MEDIUM  
**Action:** **Fixed** — vendored `pihole6_exporter` into `docker/pihole6-exporter/`; `COPY` in Dockerfile.

### Comment 3 — `docker/pihole6-exporter/Dockerfile` line 3

**Issue:** `python:3.14-alpine` tag floats on patch updates.

**Priority:** LOW  
**Impact:** LOW  
**Effort:** LOW  
**Action:** **Deferred** — spike build; pin base digest on Pi after first successful build (NFR-1 / ADR-004 discipline).

---

## Overall — Reviewer's Guide

**Summary:** Local arm64 build for Mosher exporter; compose/docs require `docker compose build pihole-exporter` before pull/up on Pi.

**Priority:** N/A (informational)  
**Action:** No code change required.

---

## Priority Matrix Assessment

| Comment | Priority | Impact | Effort | Action |
|---------|----------|--------|--------|--------|
| #1 — pip pins | MEDIUM | MEDIUM | LOW | Fixed |
| #2 — vendored script vs ADD URL | HIGH | HIGH | MEDIUM | Fixed |
| #3 — base image pin | LOW | LOW | LOW | Deferred (digest pin on Pi) |
| Review guide | — | — | — | Informational |

---

## Merge recommendation

**Ready for merge** after operator runs **Scenario 10** on Pi (build + metrics curl). Desk `compose config` validated during validation.

---

**Last updated:** 2026-06-04
