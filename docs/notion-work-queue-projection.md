# WRASAL Work Control → Notion S2 projection (working proposal)

**Status:** code proposal / review required. **Scope:** one-way, manually mediated, read-only **against the GitHub Work Control source**. Producing a JSON projection does **not** mutate Notion, GitHub, Work Control, Canon, client records, or a runtime.

## Ownership
- The WRASAL Work Tree is responsible for **placement** in the organization.
- The existing Work Control / `work_orders/WRASAL-####.json` records are the declared **source status and evidence**.
- This repository is a control-plane scaffold, not the full Work Control runtime.
- Notion's `S2 · Work Queue Projection` is a **view / mirror**. Its `Status` property is a coarse display group, **not** canonical acceptance.
- Human decision and review remain necessary for Canon promotion and RELEASE. This projector does not make either decision.

## Tested source contract
A GitHub JSON work-order record contains `work_order_id`, `project`, `record_authority`, `recorded_on`, `objective`, `execution_status`, `implementation_result`, `verification_result`, `canonical_acceptance`, `references` and `evidence`. The exact status vocabularies are in `work_orders/status-vocabulary.json`.

The Ruby projector requires a GitHub blob URL within `wrasalmedia-rgb/wrasal-control/work_orders/WRASAL-####.json`, a matching ID, and a 40-hex-character source **blob SHA**. The SHA is an observed revision marker; it does not establish independently verified provenance or acceptance.

## Deterministic projection
Run locally after fetching an actual work-order JSON and its Git blob SHA:

```sh
ruby scripts/project_work_order.rb \
  --file work_orders/WRASAL-0005.json \
  --url https://github.com/wrasalmedia-rgb/wrasal-control/blob/main/work_orders/WRASAL-0005.json \
  --revision <OBSERVED_40_HEX_BLOB_SHA>
```

The result is **a JSON object for review** with keys `properties`, `source`, and `warning`. It is not an API call and must not be treated as an authorization token.

### Mapping principles
| Control source | Notion mirror |
| --- | --- |
| `work_order_id` | `Control Work Order ID`; unique matching key for subsequent reconciliation |
| `execution_status` | `Control Execution` (raw); `Status` is a coarse display |
| `implementation_result` | `Control Implementation` |
| `verification_result` | `Control Verification` |
| `canonical_acceptance` | `Control Acceptance` (raw) |
| `record_authority` | `Control Authority` (raw, not a verified human identity) |
| source blob SHA | `Source Revision` |
| source URL | `Control Record URL` |
| read-only/manual projection | `Record Class = LIVE MIRROR`, `Projection Mode = READ ONLY SNAPSHOT` |

`Status` is **Not started** for a `requested` source record, otherwise **In progress**. **It never becomes Done**, even if the JSON says `canonical_acceptance=accepted`; the projector does not independently authenticate any approval. `Verification=pass` is displayed as PARTIAL evidence because executor tests alone do not establish end-to-end release. No receipt implies completed deployment, sale, or payment.

## Notion mirroring process (manual until separately authorized and implemented)
1. Read the GitHub work-order record from the authorized repository and record its blob SHA.
2. Validate its vocabulary and ID; run the Ruby adapter and tests.
3. Inspect the existing Notion projection database for a matching `Control Work Order ID`. **Update that row** if it exists; otherwise create one. Never insert a second row for the same ID.
4. Copy only projection fields. Include snapshot date, source URL, source revision, and read-only mode.
5. After writing, read back the row and compare exact fields. Check source revision again to detect drift.
6. Never submit Notion edits as Work Control transitions. Never mark an item Done from a mirrored PASS.
7. Any newly discovered conflict is reported and **held** for human review.
8. Revisit authorization and security before introducing scheduled polling, tokens, or webhooks. Nothing in this proposal enables automated synchronization.

## Verification
```sh
ruby -c scripts/project_work_order.rb
ruby tests/project_work_order_test.rb
```

Tests cover status vocabulary, mismatched IDs, cross-repository references, non-SHA revisions, and **fail-closed approval behavior**. CI uses a pinned Ruby setup and pinned checkout action; no credentials, external Notion writes, or automatic promotion.

## Exit criteria for this proposal
- [ ] Ruby tests pass on GitHub CI and the precise commit is inspected.
- [ ] One actual source record is mirrored; the Notion row and source SHA are read back.
- [ ] The Notion board retains candidate/mirror classification and cannot be mistaken for an authority.
- [ ] Idempotent synchronization, concurrency, rate limits, auth, and failure recovery are specified before any continuous polling.
- [ ] Authorized human review and explicit acceptance recorded; only then consider merge or deployment.

**Explicitly excluded:** Canon promotion, work-order creation by AI from Notion, runtime commands, paid customer work, automatic payments, Notion write-back to GitHub, and a scheduled synchronization service.
