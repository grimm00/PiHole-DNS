#!/usr/bin/env bash
# Layer 2 observable — automatable steps from manual-testing.md
# Compose: set L2_COMPOSE (default: docker compose). Desk example in mise.toml / mise.local.toml.example
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

L2_COMPOSE="${L2_COMPOSE:-docker compose}"

run_compose() {
  # shellcheck disable=SC2086
  $L2_COMPOSE "$@"
}

require_env() {
  if [[ ! -f .env ]]; then
    echo "missing .env — copy from .env.example and set passwords" >&2
    exit 1
  fi
}

cmd_config() {
  require_env
  run_compose config >/dev/null
  echo "OK: scenario 1 — compose config valid"
}

cmd_up() {
  require_env
  run_compose up -d
  echo "OK: scenario 2 — stack started (run: mise run l2-ps)"
}

cmd_ps() {
  run_compose ps
}

cmd_down() {
  run_compose down
}

cmd_prometheus_health() {
  curl -sf http://127.0.0.1:9090/-/healthy >/dev/null
  echo "OK: scenario 3 — Prometheus healthy"
}

cmd_prometheus_targets() {
  curl -sf http://127.0.0.1:9090/api/v1/targets | python3 -c '
import json, sys
data = json.load(sys.stdin)
jobs = ("prometheus", "pihole", "docker", "node")
seen = {}
for t in data.get("data", {}).get("activeTargets", []):
    job = t.get("labels", {}).get("job", "")
    seen[job] = t.get("health", "?")
for j in jobs:
    h = seen.get(j, "MISSING")
    print(f"  {j:12} {h}")
    if h != "up":
        sys.exit(1)
print("OK: scenario 3 — exporter jobs up")
'
}

cmd_exporters() {
  curl -sf http://127.0.0.1:9617/metrics | head -3 | grep -q . || { echo "fail: :9617 pihole-exporter" >&2; exit 1; }
  curl -sf http://127.0.0.1:9713/metrics | head -3 | grep -q . || { echo "fail: :9713 docker-exporter" >&2; exit 1; }
  curl -sf http://127.0.0.1:9100/metrics | head -3 | grep -q . || { echo "fail: :9100 node-exporter" >&2; exit 1; }
  echo "OK: scenario 4 — exporter /metrics respond"
}

cmd_prometheus_rules() {
  curl -sf 'http://127.0.0.1:9090/api/v1/rules?type=alert' | python3 -c '
import json, sys
data = json.load(sys.stdin)
groups = data.get("data", {}).get("groups", [])
names = {g.get("name") for g in groups}
if "pihole_dns_incident" not in names:
    print("missing group pihole_dns_incident", file=sys.stderr)
    sys.exit(1)
alerts = []
for g in groups:
    if g.get("name") == "pihole_dns_incident":
        alerts = [r.get("name") for r in g.get("rules", [])]
for want in ("PiHoleContainerNotRunning", "PiHoleDNSQueryRateZero"):
    if want not in alerts:
        print(f"missing alert {want}", file=sys.stderr)
        sys.exit(1)
print("OK: scenario 7 — Prometheus alert rules loaded")
'
}

cmd_prometheus_alerts() {
  curl -sf http://127.0.0.1:9090/api/v1/alerts | python3 -m json.tool | head -40
  echo "(scenario 9 — check firing alerts while pihole is stopped)"
}

cmd_urls() {
  cat <<'EOF'
Open in browser (scenarios 5, 6, 8):
  Grafana:     http://127.0.0.1:3000
  Prometheus:  http://127.0.0.1:9090/targets
               http://127.0.0.1:9090/rules
               http://127.0.0.1:9090/alerts
Dashboards: Pi-hole DNS (pihole-dns), Platform Health (platform-health)
Grafana → Alerting → Alert rules → folder "Layer 2 Spike"
EOF
}

cmd_stop_pihole() {
  run_compose stop pihole
  echo "stopped pihole — wait ≥2m then: mise run l2-prometheus-alerts (scenario 9)"
}

cmd_start_pihole() {
  run_compose start pihole || run_compose up -d pihole
  echo "started pihole — scenario 9 recovery"
}

cmd_smoke() {
  cmd_config
  cmd_prometheus_health
  cmd_prometheus_targets
  cmd_exporters
  cmd_prometheus_rules
  echo "OK: automatable smoke passed (browser steps: mise run l2-urls)"
}

usage() {
  sed -n '2,20p' "$0" | grep '^#' | sed 's/^# \{0,1\}//'
  echo ""
  echo "Usage: $0 <command>"
  echo "Commands: config up ps down prometheus-health prometheus-targets exporters"
  echo "          prometheus-rules prometheus-alerts urls stop-pihole start-pihole smoke"
}

case "${1:-}" in
  config) cmd_config ;;
  up) cmd_up ;;
  ps) cmd_ps ;;
  down) cmd_down ;;
  prometheus-health) cmd_prometheus_health ;;
  prometheus-targets) cmd_prometheus_targets ;;
  exporters) cmd_exporters ;;
  prometheus-rules) cmd_prometheus_rules ;;
  prometheus-alerts) cmd_prometheus_alerts ;;
  urls) cmd_urls ;;
  stop-pihole) cmd_stop_pihole ;;
  start-pihole) cmd_start_pihole ;;
  smoke) cmd_smoke ;;
  -h|--help|help) usage ;;
  *) usage >&2; exit 1 ;;
esac
