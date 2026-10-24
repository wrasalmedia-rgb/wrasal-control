# WRASAL ShotSpec Schema — Validation Infrastructure

**Version:** wrasal-shot-spec-v1  
**File:** `03-full-shotlist/schema/shot-spec-schema.json`  
**Validator:** `07-verification/validate-shotlist.mjs` (Node, pinned via repository's `js-yaml` dependency)  
**Machine-Readable Source:** `03-full-shotlist/master-shot-list.yaml` (validated against this schema implicitly via validator checks T01–T18)

**Required Fields (§9):** 27 fields (including timecode_in/out, elapsed_*) — 21 canonical required + 6 computed for validation. All 34 shots must have every required field. Unknown information must be represented explicitly (never convert assumed lens focal distance into actual capture metadata).

**Governance:** This schema is Systems Architect deliverable — preserves provenance, enables deterministic validation, and prevents silent overwrite of baseline. Original 34 identifiers §5 preserved. Revisions must preserve original state + rationale.
