# PR #6 — Group 3 Incident and Alerting

**Feature:** Layer 2 Observable (training-week spike)  
**PR:** https://github.com/grimm00/PiHole-DNS/pull/6  
**Merged:** 2026-06-03 → `develop`  
**Branch:** `feat/layer-2-observable-03-incident-and-alerting`

---

## Shipped

- Q3/Q4 resolved — stop-container incident; Grafana unified alerting only (no Alertmanager).
- `prometheus-config/alerts.yml` + Grafana `grafana/provisioning/alerting/pihole-alerts.yml`.
- Provisioned dashboards `pihole-dns.json`, `platform-health.json`.
- Desk compose shortcuts in `mise.toml` (`compose-up`, etc.).

---

## 📋 Deferred Issues

**Date:** 2026-06-03  
**Review:** PR #6 Sourcery feedback — [`pr6.md`](../../../../feedback/sourcery/pr6.md)  
**Status:** ✅ **NONE** — All Sourcery items addressed pre-merge (PromQL alignment, `noDataState`/`execErrState`, grammar). Pi drill (Group 4 Task 18) should confirm alert behavior on real hardware.

---

**Last updated:** 2026-06-03
