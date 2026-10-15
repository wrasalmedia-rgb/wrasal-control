# WRASAL Campaign Genome Execution Method

Registry ID: WRASAL-CAMPAIGN-EXEC-METHOD-001

Version: 1.0.0

Lifecycle status: PROPOSED / PENDING REVIEW

## Purpose

This document records a reusable execution method for applying the WRASAL Campaign Genome to engineering and product evidence. It is a documentation and provenance artifact: it records decisions, required inputs, steps, evidence recording expectations, and human-review boundaries. This method does NOT validate or approve any prototype, build, test, or deployment.

Campaign context
- Campaign frame: The Reality Gate
- Core campaign line: The prototype is real. The next proof is physical.

(These context phrases are recorded for campaign framing only and are not evidence of validation or performance.)

## Governing principles

All work under this method follows the mandatory WRASAL governing principles:

- REALITY FIRST. TECHNOLOGY SECOND.
- No evidence → no authority.
- No authority → no state change.
- Uncertainty must never silently become confidence.
- AI may propose, inspect, organize, and evaluate.
- AI must not invent evidence, claim human approval, or self-authorize changes to canonical standards.
- An artifact is not proof of validation.
- A successful commit is evidence of publication, not evidence of independent validation.
- Preserve the distinction between proposal, built artifact, tested artifact, validated system, and operating or revenue-generating system.

Do not claim that a test, review, approval, deployment, or validation occurred unless the repository contains evidence supporting that claim.

## Preconditions

- A named owner and repository are specified and accessible with push permission for the working branch.
- The operating mode is explicitly chosen from: EXPERIMENT, BUILD-TO-DEPLOY, MAINTAIN-EXTEND.
- Source artifacts are available and linked (or the document explicitly records missing artifacts and unresolved evidence).
- The lifecycle status of this method is PROPOSED / PENDING REVIEW until human reviewers ratify it.

## Required inputs

Provide the following before executing the method:

1. Identification and ownership
   - Work identifier
   - Owner (person or team) with contact
   - Intended outcome and acceptance criteria
   - Operating mode (one of EXPERIMENT, BUILD-TO-DEPLOY, MAINTAIN-EXTEND)
   - Target repository or system (exact owner/repo or URL)

2. Source artifacts and provenance links
   - Source code locations (file paths, commits, or URLs)
   - Reports (engineering reports such as Pan v4, SorcerTree Swift Bootstrap) with links
   - Test logs, hardware test benches, measurement data (if available)

3. Constraints and dependencies
   - Known constraints (legal, safety, hardware availability)
   - External dependencies and their versions

4. Required outputs and deployment target
   - Artifacts to produce (documents, code changes, tests)
   - Deployment target (environment, device, or repository path)

5. Exclusions
   - Explicitly state what is out of scope for this execution

6. Acceptance criteria
   - Measurable criteria that must be met for the work to be considered complete

If any of these inputs are missing, record them as unresolved and do not proceed to state changes that require human authority.

## Nine-stage workflow

Each stage below records required activities and evidence to capture. Preserve links and provenance. Record unresolved questions as unresolved; do not invent missing evidence.

1) Declare

- Identify: work identifier, owner, intended outcome, operating mode (EXP, BUILD, MAINTAIN), and exact target repo or system.
- Record date/time and responsible person or team.
- Evidence: link to the repository or system, owner contact, and any charter documents.

2) Scope

- List source artifacts by exact paths or commit SHAs.
- Record known constraints, required outputs, exclusions, dependencies, and acceptance criteria.
- Note unresolved items explicitly under "Unresolved Questions".

3) Inspect

- Read actual source artifacts.
- Distinguish and record: observed facts, source claims, assumptions, hypotheses, missing evidence, unresolved conflicts.
- Preserve provenance: file paths, commit SHAs, timestamps, and author identities.
- Evidence: include direct links to artifacts and quotes where relevant.

4) Design

- Map source material to the intended campaign, implementation, or verification plan.
- Identify reality checks (falsifiable tests) that would constrain or falsify the proposed outcome.
- Record design decisions and alternatives with rationale and evidence.

5) Build

- Create only the artifacts required by the approved scope.
- Keep proposed changes distinguishable from canonical or ratified material (e.g., in a feature branch, with clear labels).
- Evidence: commit SHAs, changed file paths, build logs.

6) Verify

- Run relevant checks against actual artifact or runtime where possible.
- Record: commands run, expected results, observed results, failures, limitations, and evidence locations (logs, artifacts, screenshots).
- Never substitute a proposed test plan for an executed test. If tests were not run, record that explicitly.

7) Review

- Record review status and required human decisions.
- Do not infer approval from silence or from a successful build.
- Evidence: review comments, approver identity, timestamps, and explicit approval statements.

8) Release

- Record exact release/publication evidence: repository, branch, commit SHA, changed paths, and review or deployment status as applicable.
- Do not describe a pull request as merged unless repository state confirms it is merged.

9) Archive

- Preserve final artifact, source references, verification results, unresolved issues, and next actions so the process can be reproduced.
- Evidence: archive location, links, and retention policy notes.

## Evidence-recording requirements

- Always include direct links (URLs) and exact commit SHAs for code artifacts.
- Record commands and exact outputs (or attach logs) for verification steps.
- For human approvals, record the identity of the approver, the explicit approval statement, and timestamp.
- Distinguish between observed evidence, claimed evidence, and missing evidence.

## Failure and uncertainty handling

- If evidence is missing, stop and record the missing items as "Unresolved". Do not proceed to actions that change canonical state without human authority.
- If a test fails, record the failure, do not infer success, and list next remediation steps.
- If evidence conflicts (contradictory logs or claims), record both sides and escalate for human resolution.

## Human review and authority boundaries

- State changes to canonical artifacts (main branch, production systems, standards documents) require explicit human approval from the documented approver(s).
- AI may prepare proposals, tests, and diffs but must not self-authorize merges or approvals.
- Record who may approve each class of change (e.g., owner, security reviewer, hardware lead).

## Acceptance criteria

- Acceptance criteria must be concrete, measurable, and recorded in the Scope stage. Examples include passing unit tests, passing hardware-in-the-loop checks, or producing a signed review from the responsible engineer.
- The method is complete when all acceptance criteria are met and evidence is linked in the Release and Archive stages.

## Publication and audit fields (required)

- Repository: wrasalmedia-rgb/wrasal-control
- Branch (working): docs/wrasal-campaign-execution-method-001
- File path: concepts/WRASAL-CAMPAIGN-EXEC-METHOD-001.md
- Author: (record the human authoring this document)
- Date created: (YYYY-MM-DD)
- Commit SHA: (recorded at commit time)
- PR URL: (recorded when PR is opened)
- Review status: PROPOSED / PENDING REVIEW
- Evidence locations: (list of URLs to artifacts, logs, and archives)

> NOTE: Fill the commit SHA, author, date, and PR URL when those artifacts exist; do not invent values here.

## Changelog

- 1.0.0 (PROPOSED): Initial draft recorded in concepts/WRASAL-CAMPAIGN-EXEC-METHOD-001.md. Lifecycle status: PROPOSED / PENDING REVIEW.

