# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

GitHub template repository (`is_template: true`) for Sky Haven Azure infrastructure projects. When creating a new `infra-*` repo, generate it from this template. The `infra/` scaffold and all pipelines come pre-wired.

## Common Commands

```bash
# Initialise (run from repo root)
terraform -chdir=infra init \
  -backend-config="resource_group_name=rg-tfs-platform-prd-uks-01" \
  -backend-config="storage_account_name=sttfsplatformprduks01" \
  -backend-config="container_name=<repo-name>" \
  -backend-config="key=terraform.tfstate"

# Plan / Apply / Destroy
terraform -chdir=infra plan    -var-file="vars/globals.tfvars" -var-file="vars/prd.tfvars"
terraform -chdir=infra apply   -var-file="vars/globals.tfvars" -var-file="vars/prd.tfvars"
terraform -chdir=infra destroy -var-file="vars/globals.tfvars" -var-file="vars/prd.tfvars"
```

## Pipeline Behaviour

**`linting.yml`** — runs on every PR to `main` (excluding README changes). Uses Super-Linter with TFLint and Checkov; config in `.github/linters/`.

**`terraform.yml`** — triggers on push to `major/**`, `minor/**`, `patch/**` branches that touch `infra/**`, or via `workflow_dispatch` (plan/apply/destroy choice). Authenticates to Azure via OIDC (no client secret). Before init it ensures the state container exists; after every run (including failures) it breaks any leftover state lease.

**`tag.yml`** — auto-tags on PR merge. Branch prefix drives semver bump: `major/**` → major, `minor/**` → minor, `patch/**` → patch. Other prefixes produce no tag.

## Terraform Structure

All `.tf` files live under `infra/`. Underscore-prefixed files hold specific block types only:

| File | Block type |
|------|-----------|
| `_terraform.tf` | `terraform {}` |
| `_providers.tf` | `provider` |
| `_variables.tf` | `variable` |
| `_locals.tf` | `locals` |

`infra/vars/globals.tfvars` holds shared values (`workload`). Environment files (`dev.tfvars`, `prd.tfvars`) hold values that differ per env. Both are always passed together to Terraform.

`local.resource_suffix` and `local.resource_suffix_flat` are the single source of truth for resource naming — all resource `name` arguments must reference one of these.

## Azure State Backend

State is stored in `sttfsplatformprduks01` (storage account), resource group `rg-tfs-platform-prd-uks-01`. Each repo gets its own container named after the repository. The `ensure-tfstate-container` action creates it on first run; `break-tfstate-lease` cleans up stuck leases.

## Checkov Skips

Skips in `.github/linters/.checkov.yaml` are intentional suppressions for controls that conflict with Sky Haven's design decisions (e.g. Key Vault soft-delete managed externally, `workflow_dispatch` inputs by design). Do not remove them without understanding the rationale.
