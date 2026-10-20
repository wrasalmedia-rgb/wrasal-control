# WRASAL-SOS-002 · Secure Work Control → Notion synchronization

**State:** implementation proposal on draft PR; not approved, merged, enabled or live.

## Source-of-truth policy

GitHub `wrasalmedia-rgb/wrasal-control` is an S2/S3 **control-plane scaffold**, not proof that the full Work Control runtime exists. Its tracked `work_orders/WRASAL-####.json` files are the recorded source facts for this bounded experiment. Work Tree remains the organizational hierarchy. Notion is a *projection*, never authority.

**Destination:** cloned Startup OS project data source, provided at runtime through the protected `NOTION_DATA_SOURCE_ID` secret. The ID must be an explicitly approved UUID; the source code does not select a workspace. A prior manually created record for `WRASAL-0005` exists at [the Notion mirror](https://app.notion.com/p/3ffc034c1032818cbb9ac4224468edb7). At the inspection, GitHub showed executor PASS, canonical acceptance PENDING. The Git blob SHA was `996b5a6ceeb4f58039a3aca5a5fd20bc5a4deb5b`.

## Minimal data flow

`Pinned checked-out Git tree → validate all source records → normalize Ruby projection → find by stable work-order ID → detect duplicates and drift → selective create/update → read-back and uniqueness check → report.`

This bridge **never** marks Notion status `Done`, approves Canon, issues release authorization, changes GitHub source, or books revenue. A source `accepted` value is displayed as reported text, not an independently verified human approval.

## Safety and operational controls

- **Allowlist:** fixed GitHub repo, `work_orders/WRASAL-####.json` source paths, pinned commit and per-file blob revision; only the exact Notion data-source ID and approved projection fields may be written.
- **Bounded batch:** maximum 30 tracked work orders; validate all records before writing. No automatic retries for ambiguous creates or updates. Read-only queries may retry rate limits a bounded number of times.
- **Duplicate detection:** lookup by `Control Work Order ID`; duplicate, mismatched `Record Class`, or ambiguous pagination fails closed.
- **Drift detection:** same blob revision with changed Notion fields blocks instead of overwriting. A changed source revision permits a reviewed projection update. This is not transactional compare-and-swap; simultaneous human edits remain a residual risk.
- **Manual snapshot adoption:** `--adopt-verified-manual-snapshot` is an explicit one-time exception only if the existing snapshot matches every authoritative field except the projection mode and conversion of the source URL from `main` to its pinned commit.
- **Write receipts:** read the resulting page and verify unique ID and exact projected fields before reporting success.
- **Secrets:** the GitHub PR test workflow does not receive any Notion token. A separate protected `notion-sync` GitHub environment must have authorized reviewers, `NOTION_API_TOKEN`, `NOTION_DATA_SOURCE_ID`, and `WRASAL_NOTION_APPLY=EXPLICITLY_AUTHORIZED` provisioned only after human approval. The `apply` job is manual-dispatch-only from merged `main`. No timer, cron, or release bypass is installed.
- **Technical stack:** Ruby standard library, Git, Notion API. No Python, Express, Next.js or new general-purpose runtime. Erlang/OTP supervision remains an option only if a persistent service is approved; this short-lived CI process needs none.
- **Privacy:** no token, client data, payment record, or private workspace material is committed to the public GitHub repository.

## Verification commands

```sh
ruby -c scripts/notion_work_queue_sync.rb
ruby tests/notion_work_queue_sync_test.rb
ruby scripts/notion_work_queue_sync.rb --dry-run
```

These tests use isolated Git fixtures and a fake Notion client; they exercise source constraints, idempotency, duplicate protection, status drift, explicit adoption, credential gating and non-retryable writes. Hosted CI is required against the **latest** PR commit before any merge.

## Release / activation gates

- [x] Ruby source and fake-client tests authored.
- [ ] Hosted CI for latest PR commit succeeds.
- [ ] Human inspects diff, Notion mapping and authority boundaries.
- [ ] Human approves merge; branch protected as appropriate.
- [ ] Narrow-scope Notion integration and protected GitHub environment are provisioned. Neither is presently verified.
- [ ] Dry-run output is inspected against current Git source.
- [ ] Explicitly authorized first real apply is observed and compared to the Notion target by source revision and record ID.
- [ ] Human records any acceptance decision. No acceptance may be inferred from a successful CI run.

## Commercial continuation

The [WRAYVOLUTION brand-readiness offer](https://app.notion.com/p/3ffc034c1032814dba64d2d7d6378fd5) and [internal source-to-production sample](https://app.notion.com/p/3ffc034c103281908f53c29ea5c6fd3d) exist as **working** preparation, not approved offers or customer evidence. Human commercial decisions, approved scope and rights, customer interviews, delivery acceptance and bank/payment receipts are required before declaring validated demand, operations or revenue.
