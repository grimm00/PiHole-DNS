# PR #5 — Group 2 Compose and Services

**Feature:** Layer 2 Observable (training-week spike)  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/5  
**Merged:** 2026-06-03 → `develop`  
**Branch:** `spike/layer-2-observable`

---

## Shipped

- Extended root `docker-compose.yml` with Prometheus, Grafana, node-exporter, pihole-exporter, docker-exporter (Tasks 5–9).
- `prometheus-config/prometheus.yml` scrape jobs for all exporters.
- Grafana provisioning (datasource + dashboard file provider).
- `.env.example` updates for Grafana admin password and exporter secret reuse.

---

## 📋 Deferred Issues

**Date:** 2026-06-03  
**Review:** PR #5 Sourcery feedback — [`pr5.md`](../../../../feedback/sourcery/pr5.md)  
**Status:** ✅ **NONE** — Comment #1 (`allowUiUpdates` vs RO mount) addressed pre-merge; no MEDIUM/LOW items deferred.

---

**Last updated:** 2026-06-03
