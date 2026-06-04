# Mosher-Labs/pihole6-exporter — built locally for linux/arm64 (Pi).
# Upstream ghcr.io/mosher-labs/pihole6-exporter publishes amd64 only (no arm64 manifest).
FROM python:3.14-alpine

RUN pip install --no-cache-dir prometheus_client requests urllib3

# Pinned upstream script (blob 44c3bf3b — Jan 2026 session-auth exporter).
ADD https://raw.githubusercontent.com/Mosher-Labs/pihole6-exporter/44c3bf3b6874bd60b8deabfde319bf302b608da0/pihole6_exporter \
    /usr/local/bin/pihole6_exporter
RUN chmod +x /usr/local/bin/pihole6_exporter

EXPOSE 9617
ENTRYPOINT ["/usr/local/bin/pihole6_exporter"]
