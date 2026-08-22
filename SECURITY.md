# Security Policy

## Supported version

This educational repository has no published release yet. Security fixes are
applied to the latest commit on `main` only.

## Reporting a vulnerability

Do not open a public issue for a vulnerability. Use GitHub's private
**Security** tab and select **Report a vulnerability**:

https://github.com/umutseve4/btk-sql-lab/security/advisories/new

Include reproduction steps, affected files, expected impact, and a minimal
proof of concept when safe. Never include real credentials or personal data.
An initial acknowledgement is targeted within 7 days. A remediation timeline
will be provided after the report is reproduced and its severity is assessed.

## Scope and credential model

The documented `sa` password is a disposable development credential for the
isolated Codespace database only. It must never be reused for an internet-facing,
shared, staging, or production SQL Server. CI generates a fresh password for
each run and masks it from logs.
