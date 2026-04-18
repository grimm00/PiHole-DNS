# ADR-001: Stable LAN IPv4 — addressing mode

**Status:** Proposed  
**Created:** 2026-04-18  
**Last Updated:** 2026-04-18  

---

## Context

Layer 0 requires a **stable, documented** IPv4 for the Pi (**FR-1**). Research validated both **DHCP reservation** and **manual static IP** on Raspberry Pi OS Bookworm; the operator must choose one for this deployment.

**Related:** [decision-interview.md §1](decision-interview.md#section-1) · [research-stage-1-stable-addressing.md](../../research/layer-0-foundation/research-stage-1-stable-addressing.md)

---

## Decision

*[To be filled from decision interview §1.]*

**Decision:** *[e.g. Use DHCP reservation on the home router for the Pi’s Ethernet MAC, fixed IPv4 `x.x.x.x`.]*

---

## Consequences

### Positive

- *[TBD]*

### Negative

- *[TBD]*

---

## Alternatives considered

### DHCP reservation vs static on host

**Description:** Research treats both as valid; trade-offs depend on router capabilities and operator preference.

**Why one over the other:** *[From interview]*

---

## Decision rationale

*[From interview + FR-1]*

---

## Requirements impact

- **FR-1:** Satisfied by documenting the chosen mechanism and verification steps.

---

## References

- [requirements.md](../../research/layer-0-foundation/requirements.md) — FR-1  
- [decision-interview.md](decision-interview.md)

---

**Last Updated:** 2026-04-18
