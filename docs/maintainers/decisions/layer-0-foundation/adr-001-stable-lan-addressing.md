# ADR-001: Stable LAN IPv4 — addressing mode

**Status:** Accepted  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Context

Layer 0 requires a **stable, documented** IPv4 for the Pi (**FR-1**). Research validated both **DHCP reservation** and **manual static IP** on Raspberry Pi OS Bookworm. The operator confirmed a reservation-style setup with verification on **eth0**.

**Related:** [decision-interview.md §1](decision-interview.md#section-1) · [research-stage-1-stable-addressing.md](../../research/layer-0-foundation/research-stage-1-stable-addressing.md)

---

## Decision

**Decision:** For Layer 0, stable addressing is achieved via **DHCP reservation on the home router** so the Raspberry Pi receives a **fixed IPv4** on **Ethernet (eth0)**. Verified address: **192.168.50.2**. Verification: `ip address` / `ip addr` shows the address on **eth0**; connectivity confirmed via **SSH** and existing services (e.g. file server) on that IP.

**Public docs:** Omit **MAC addresses** and other sensitive identifiers; keep full details in private operator notes if needed.

---

## Consequences

### Positive

- Matches common homelab practice; router remains source of truth for “this MAC always gets this IP.”
- Clear verification steps (interface + IP + reachability) align with FR-1.

### Negative

- Depends on **router UI** and DHCP behavior; if the router is replaced or reset, reservation must be re-established.

---

## Alternatives considered

### DHCP reservation vs static IP on the Pi (NetworkManager)

**Description:** Research treats both as valid. Static on-host configuration can avoid router dependency but shifts all IP config to the Pi.

**Why DHCP reservation was chosen:** Operator reserved the address via the router and verified stable **192.168.50.2** on **eth0**; no need to diverge to host-only static for Layer 0.

---

## Decision rationale

Aligns with **FR-1** and the decision interview: stable IPv4 under normal conditions, documented mechanism, and repeatable verification. **A-2** (router can participate) holds.

---

## Requirements impact

- **FR-1:** Satisfied by this mechanism and documented verification.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-1  
- [decision-interview.md](decision-interview.md)

---

**Last Updated:** 2026-04-18
