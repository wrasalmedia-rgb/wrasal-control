# YUTE™ OS — Consolidated Agency Foundation Specification (`YUTE-OS-AGENCY-FOUNDATION-v001`)

- **Document ID:** `YUTE_OS_AGENCY_FOUNDATION_v001`
- **Work Order:** `WO-YUTE-AGENCY-001` (*YUTE Guard™ + Agency Firewall + Evidence Vault*)
- **Governance Disposition:** `decisions/YUTE-ADR-0010.md` & `YUTE-PR8-REVIEW-001` (*Conditional Approval — Fictional-Data Engineering Only; Human Ratification Required*)
- **Priority:** `P0` *(Controlled Exception to Oct 20 Portfolio Freeze — Independent of `WO-YUTE-LUTA-DARRON-001` / `HOLD-RIGHTS-001`)*
- **Constitutional Authority:** `concepts/YUTE-FOUNDATION-DOCTRINE-001.md` (`v002.2`)
- **Spec Revision:** `v001.2` (`2026-10-31` — Incorporates `YUTE-PR8-REVIEW-001`: Standalone PG 16.4 Migrations, `YUTE-AGENCY-INV-002` Composite Authority Chain, `EGRESS-FENCE-v001`, & 5-Stage Consent Process Evidence)
- **Standalone Executable Migrations:** `missions/WO-YUTE-AGENCY-001/migrations/001_yute_mvp_core.sql`, `002_yute_agency_foundation.sql`, `003_verify_pg16_invariants.sql`
- **Schema Verification Evidence:** `evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json` (`PostgreSQL 16.4` — `10/10` adversarial SQL invariants PASS)
- **Runtime Classification:** `PG 16.4 DDL & CONSTRAINTS VERIFIED; RUBY 3.3 SERVICE & MULTI-SOCKET CONCURRENCY ASSURANCE PENDING YUTE-ADR-0010 RATIFICATION.`
- **Canonical Acceptance:** `pending`

> **YUTE™**
> **KNOW BEFORE YOU AGREE.**
> **CONTROL WHAT YOU AUTHORIZE.**
> **PRESERVE THE EVIDENCE.**

---

## 1. Product Zero Identity & Human Flow: `YUTE GUARD™`

To prevent governance complexity from obscuring human utility, YUTE's product identity maps directly to three human actions:
1. **`KNOW BEFORE YOU AGREE.` (`YUTE GUARD™` / `Yute::ContractShield`):** Upload an agreement with zero avatar or biometric onboarding; inspect exact cited clauses (`UNICODE_NFC_LF`), plain-language explanations, uncertainties, and questions worth raising.
2. **`CONTROL WHAT YOU AUTHORIZE.` (`Yute::ConsentLedger` + `Yute::DigitalRightsPassport` + `Yute::AgencyFirewall`):** Make an autonomous human decision (`DECLINED`, `DEFERRED_FOR_COUNSEL`, or `DECIDED_TO_AUTHORIZE`), bind permissions strictly to a coherent chain of authority (`YUTE-AGENCY-INV-002`), and block out-of-scope operations fail-closed (`YUTE-AGENCY-INV-001`).
3. **`PRESERVE THE EVIDENCE.` (`Yute::EvidenceVault`):** Preserve immutable versions, 5-stage consent process receipts, denial proofs, and honest 4-axis revocation ledgers.

---

## 2. Constitutional Invariants & `YUTE-PR8-REVIEW-001` Forensic Resolutions

### 2.1 Resolution of P0 Finding 01 — Standalone Executable PostgreSQL 16 Migrations
All DDL is now extracted as standalone, ordered `.sql` files in `missions/WO-YUTE-AGENCY-001/migrations/` (`001_yute_mvp_core.sql`, `002_yute_agency_foundation.sql`, and adversarial test script `003_verify_pg16_invariants.sql`) using native `pg_catalog.gen_random_uuid()` (eliminating unnecessary superuser extension friction). Executed against real **`PostgreSQL 16.4`** (`evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json`), verifying `23` tables, `15` composite foreign keys, `10` immutability/validation triggers, `7` RLS-enabled agency tables, and `10/10` SQLSTATE constraint rejections.

### 2.2 Resolution of P0 Finding 02 — `YUTE-AGENCY-INV-002` Cross-Record & Cross-Subject Integrity (`TEST-06`)
> **`YUTE-AGENCY-INV-002`:** **`NO AUTHORIZATION MAY BE TRANSFERRED BETWEEN HUMAN SUBJECTS, ASSETS, OR PURPOSES THROUGH DATABASE ASSOCIATION ALONE.`**

Separate single-column foreign keys (`subject_id`, `agreement_id`, `ceremony_id`) allow a broken or malicious caller to splice Subject A's valid ceremony onto Subject B's grant. `001` and `002` eliminate this class of vulnerability via **15 composite `UNIQUE` + `FOREIGN KEY` constraints** spanning the entire authority graph:

```text
human_subjects(subject_id)
  └──► agreement_documents UNIQUE (agreement_id, subject_id, canonical_text_sha256)
         ├──► contract_shield_findings FK (agreement_id, canonical_text_sha256)
         ├──► digital_rights_records UNIQUE (rights_record_id, subject_id) + FK (evidence_agreement_id, subject_id)
         └──► authorization_ceremonies UNIQUE (ceremony_id, subject_id, agreement_id)
                                       + FK (agreement_id, subject_id, canonical_text_sha256)
                └──► consent_ledger_grants UNIQUE (grant_id, subject_id, scoped_rights_record_id, permitted_action, named_target_scope)
                                           + FK (ceremony_id, subject_id, agreement_id)  [Blocks TEST-06 -> SQLSTATE 23503]
                                           + FK (scoped_rights_record_id, subject_id)    [Blocks Cross-Subject Asset -> 23503]
                       └──► agency_firewall_decisions FK (matched_grant_id, subject_id, requested_rights_record_id, requested_action, requested_target_scope)
                              └──► firewall_capability_leases FK (decision_id, grant_id, subject_id, target_rights_record_id, permitted_action, named_target_scope)
```

Every `ALLOW` decision and every `FirewallCapabilityLease` is cryptographically and relationally locked to the **exact same `(subject_id, rights_record_id, permitted_action, named_target_scope)` tuple**.

### 2.3 Resolution of P0 Finding 03 — Transaction, Lock, & Egress Ordering (`EGRESS-FENCE-v001`)
YUTE defines **precisely when an action becomes irrevocably authorized** and how concurrent revocation behaves at every microsecond without holding database locks open across unbounded external network calls:

| Boundary Type | Exact Lock & Transaction Sequence | Point of Irrevocable Action & Concurrent Revocation Outcome |
|---|---|---|
| **Path A: Internal Storage / Artifact Commit** | Single ACID transaction `T_COMMIT` executes `SELECT grant_status FROM consent_ledger_grants WHERE grant_id = $1 AND subject_id = $2 FOR SHARE`, transitions `lease_state` `ISSUED -> COMMITTED_INTERNAL`, and writes manifest atomically. | **Commit of `T_COMMIT`.** Zero TOCTOU gap (`0 ms`): a concurrent revocation `UPDATE` either precedes `T_COMMIT` (causing `T_COMMIT` to abort and zero memory) or blocks until `T_COMMIT` finishes. |
| **Path B: External Rendering / Synthesis / Network Adapter (`EGRESS-FENCE-v001`)** | **Step 1 (`T1`):** Issue short-TTL lease (`ISSUED`; `0` bytes sent).<br>**Step 2 (`T2_CLAIM`):** Immediately prior to socket write, acquire `SELECT grant_status FROM consent_ledger_grants WHERE grant_id = $1 FOR UPDATE`. If `REVOKED`/expired → `INVALIDATED_AT_COMMIT_BOUNDARY` (`0` bytes sent). If `ACTIVE` → transition lease to `EGRESS_CLAIMED_PRE_SOCKET` (`<= 5s` hard socket deadline) and commit `T2_CLAIM`.<br>**Step 3 (`SOCKET_FLUSH`):** Stream payload to TLS socket; record monotonic timestamp `first_payload_byte_flushed_at` at first flushed byte.<br>**Step 4 (`T3_SETTLE`):** Re-read `grant_status` upon adapter completion/abort. | **`first_payload_byte_flushed_at` (`POINT_OF_IRREVOCABLE_EGRESS`).**<br>• **Revocation before `T2_CLAIM`:** Blocked `100%` (`INVALIDATED_AT_COMMIT_BOUNDARY`, `0` bytes).<br>• **Revocation during `EGRESS_CLAIMED_PRE_SOCKET` *before* `first_payload_byte_flushed_at`:** Cooperative abort closes socket pre-flush → `ABORTED_PRE_SOCKET_ZERO_BYTES` (`protected_assets_released = FALSE`).<br>• **Revocation *after* `first_payload_byte_flushed_at`:** Wire bytes cannot be recalled physically; lease settles as `REVOKED_POST_IRREVOCABLE_EGRESS` (`protected_assets_released = TRUE`), automatically forcing `revocation_status_ledgers` to `had_prior_external_distribution = TRUE`, `downstream_notification_status = 'PENDING_DISPATCH'`, and `confirmed_deletion_status = 'EXTERNAL_DELETION_UNCONFIRMED'`. |

### 2.4 Resolution of P1 Finding 04 (Section 03) — Five-Stage Consent Process Evidence
Documented presentation (`presented_at <= signed_at`) proves event order, **not** internal human comprehension. `authorization_ceremonies` models five distinct events without fabricating mental-state certainty:
1. **`PRESENTED`** (`presented_at`): Agreement & cited clauses rendered.
2. **`ACKNOWLEDGED`** (`acknowledged_at`): Receipt of flagged clauses & risk notices acknowledged (`presented_at <= acknowledged_at`).
3. **`EXPLAINED`** (`explained_at`): Plain-language explanations, uncertainties, optional clarification requests (`clarification_requests_json`), and counsel referral (`counsel_referral_offered = TRUE`) completed (`acknowledged_at <= explained_at`).
4. **`DECIDED`** (`decided_at` + `decision_outcome`): Autonomous human choice recorded (`DECLINED`, `DEFERRED_FOR_COUNSEL`, or `DECIDED_TO_AUTHORIZE`). `DECLINED` and `DEFERRED_FOR_COUNSEL` are first-class valid outcomes (`authorized_at IS NULL`) that **cannot** be attached to any `consent_ledger_grants` row (`trg_grant_requires_decided_to_authorize`).
5. **`AUTHORIZED`** (`authorized_at`): Verified signature bound when and only when `decision_outcome = 'DECIDED_TO_AUTHORIZE'` (`decided_at <= authorized_at`), tagged `comprehension_epistemic_status = 'PROCESS_EVIDENCE_ONLY_NOT_MIND_PROOF'`.

### 2.5 Resolution of P1 Finding 05 (Section 04) — Public Repository Privacy Minimization
Recorded in `missions/WO-YUTE-AGENCY-001/YUTE_PRIVACY_MINIMIZATION_AUDIT_001.md`: direct personal email strings and granular personal body-marking motifs have been redacted from public `wrasal-control` discovery artifacts while preserving `HOLD-RIGHTS-001`.

---

## 3. Executable Migration Reference (`migrations/002_yute_agency_foundation.sql`)

The authoritative standalone SQL files reside at:
- `missions/WO-YUTE-AGENCY-001/migrations/001_yute_mvp_core.sql`
- `missions/WO-YUTE-AGENCY-001/migrations/002_yute_agency_foundation.sql`
- `missions/WO-YUTE-AGENCY-001/migrations/003_verify_pg16_invariants.sql`

*(See `missions/WO-YUTE-AGENCY-001/migrations/002_yute_agency_foundation.sql` for the complete verified DDL executed in `evidence/WO-YUTE-AGENCY-001-pg16-schema-verification.json`.)*
