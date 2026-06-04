# Mosher-Labs/pihole6-exporter — built locally for linux/arm64 (Pi).
# Upstream ghcr.io/mosher-labs/pihole6-exporter publishes amd64 only (no arm64 manifest).
# Script vendored from https://github.com/Mosher-Labs/pihole6-exporter (MIT) — matches commit 44c3bf3b.
FROM python:3.14-alpine

RUN pip install --no-cache-dir \
    prometheus_client==0.21.1 \
    requests==2.32.3 \
    urllib3==2.4.0

COPY pihole6_exporter /usr/local/bin/pihole6_exporter
RUN chmod +x /usr/local/bin/pihole6_exporter

EXPOSE 9617
ENTRYPOINT ["/usr/local/bin/pihole6_exporter"]
