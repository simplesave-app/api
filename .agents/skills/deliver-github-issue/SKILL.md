---
name: deliver-github-issue
description: Take a GitHub issue through clarification, isolated implementation, automated and manual testing, pull-request review, and release readiness. Use when asked to pick up, implement, develop, fix, or ship a repository issue end to end, especially when the work requires a git worktree, a testable local branch, a senior subagent review, and human approval gates before publishing and merging.
---

# Deliver a GitHub Issue

Own one issue from intake until its pull request is ready for the human to merge. Work autonomously between the three mandatory human gates. Keep the user informed with concise status updates during long-running work.

## Non-negotiable rules

- Treat the GitHub issue and repository instructions as authoritative inputs, not automatically complete specifications.
- Perform implementation in a dedicated git worktree. Never develop in the user's primary checkout.
- Preserve unrelated changes, worktrees, branches, processes, and data. Never use destructive cleanup such as `git reset --hard`.
- Ask only questions that materially affect product behavior, scope, data, security, or compatibility. Make and disclose low-risk assumptions.
- Do not commit, push, create or modify a pull request, comment remotely, or merge without authorization for that exact operation. Combine related authorization requests at a gate when practical.
- Never merge the final pull request unless the user explicitly asks. The default final action is to hand the merge to the user.
- Stop at each mandatory gate. Continue only after the user responds.

## 1. Intake and investigate

1. Read the full issue, comments, linked issues and pull requests, milestones, and labels.
2. Read repository instructions and the files that define its architecture, development commands, CI checks, and conventions.
3. Inspect the relevant implementation and tests. Check recent history when it explains intent.
4. Confirm the issue is still valid and not already implemented or superseded.
5. Translate the request into user-visible outcome, scope boundaries, acceptance criteria, implementation approach, automated and manual test plans, risks, migrations, compatibility concerns, and unresolved decisions.
6. Identify missing follow-up work. Do not silently expand the issue; propose separate issues when work is useful but not required for acceptance.

### Gate 1: Confirm direction

Give the user a compact implementation brief covering the interpretation, approach, acceptance criteria, major tradeoffs, and questions. Ask them to confirm the direction. Do not create the worktree or edit code before approval.

## 2. Create an isolated worktree

After Gate 1 approval:

1. Inspect `git status`, remotes, the default branch, current worktrees, and existing local and remote branches.
2. Fetch the latest remote state without changing the user's checked-out files.
3. Derive a branch such as `issue-<number>-<short-slug>` and a sibling worktree path such as `<repo-parent>/<repo-name>-issue-<number>`.
4. Resolve both paths explicitly before creating anything. Never use a broad directory, `~`, or an unresolved environment variable as a worktree target.
5. Create the branch and worktree from the latest remote default branch, for example:

   ```sh
   git fetch origin
   git worktree add -b issue-123-short-slug /absolute/sibling/repo-issue-123 origin/main
   ```

6. If the branch or target already exists, inspect it. Reuse it only when it clearly belongs to this issue and is safe; otherwise choose a new explicit name.
7. Run every edit, formatter, test, server, commit, and push from the issue worktree. Include its path in status updates.

## 3. Implement and verify

1. Implement the smallest coherent change that meets the confirmed acceptance criteria.
2. Follow existing architecture and style. Do not mix opportunistic refactors into the issue.
3. Add or update behavior-focused tests, including meaningful failure and authorization cases.
4. Run fast, targeted checks while iterating, then run the repository's full required checks.
5. For this repository, use CI as the baseline:

   ```sh
   bin/rubocop
   bin/brakeman --no-pager
   RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails db:test:prepare test
   ```

   Adapt the database host or environment only when the local setup requires it. Report the exact commands and results.
6. Review the complete diff and status for accidental files, secrets, debug code, schema drift, missing error handling, and incomplete tests.
7. Include and verify any documentation, migrations, fixtures, seeds, or API examples required for acceptance.

## 4. Prepare hands-on testing

Start a locally testable version from the issue worktree before publishing:

1. Prepare dependencies and data using the repository's documented setup.
2. Start required services with `docker compose up -d` when appropriate, then prepare the database and run the Rails server from the worktree.
3. Avoid port, container-name, volume, or database collisions with the primary checkout or another worktree. Use a distinct Compose project name and ports when concurrent environments could overlap.
4. Keep the process available long enough for the user to test. Provide the worktree path and branch, local URL, credentials or seed data, exact scenarios, known limitations, and automated check results.

### Gate 2: Test and authorize publishing

Ask the user to test the local version and either give feedback or approve it. In the same prompt, ask explicitly whether approval authorizes the agent to:

- create the scoped commit or commits;
- push the branch;
- create a draft pull request linked with `Closes #<number>`.

Treat approval as authorization only when these operations were named. Apply feedback in the worktree and repeat verification and Gate 2 until approved.

## 5. Publish the pull request

After explicit Gate 2 authorization:

1. Recheck the diff and required checks.
2. Commit only issue-scoped files with an explanatory message.
3. Rebase or merge the latest default branch according to repository convention, resolve conflicts deliberately, and rerun affected checks.
4. Push the issue branch and open a draft pull request.
5. Include the issue link, `Closes #<number>`, summary, design notes, test commands and results, manual QA, screenshots or examples when relevant, risks, migrations, and deployment or rollback notes.
6. Wait for CI. Diagnose and fix failures attributable to the branch; request authorization before pushing additional fixes if that was not already included in the publishing approval.

## 6. Run an independent senior review

Once the pull request exists, delegate a read-only review to a fresh subagent acting as a senior developer. Give it the issue, repository instructions, pull request diff, and test evidence, but do not give it the implementation rationale or expected verdict.

Require the reviewer to prioritize actionable findings and inspect correctness, security and authorization, data integrity, migrations, concurrency, rollback safety, API compatibility, error handling, edge cases, test quality, and operational maintainability.

The reviewer must not edit files, push, approve, or merge. Triage every finding with evidence. Fix valid findings in the implementation worktree, rerun relevant checks, publish authorized updates, and request another independent pass when changes are material. Record dismissed findings and the reason in the handoff.

Mark the pull request ready for review only with explicit authorization or when that action was clearly included in Gate 2.

## 7. Hand off for merge

### Gate 3: Review and merge

Give the user a release-readiness summary containing the pull request link, issue resolved, final behavior, notable design choices, CI and local test status, manual QA, senior-review findings and resolutions, migrations, deployment steps, risks, rollback notes, and proposed follow-up issues.

Ask the user to review and merge, or provide feedback. Do not merge by default. If asked to merge, verify current CI, approvals, mergeability, and repository policy immediately before doing so.

## 8. Close out safely

After the merge is confirmed:

1. Verify the issue closed as intended and report any release or deployment work still outstanding.
2. Ask before deleting the local branch or removing the worktree unless cleanup was explicitly preauthorized.
3. Remove only a clean, explicitly resolved issue worktree. Never force-remove a worktree containing changes.
4. Update the primary checkout only when it is clean and the user wants it updated.

## Handling blockers

- Continue through recoverable implementation and test failures; explain what changed.
- Stop for secrets, unavailable external services, destructive migrations, production actions, scope changes, or decisions that alter user-visible behavior.
- If GitHub access is unavailable, finish and verify the local worktree, then provide the exact remaining publishing steps.
