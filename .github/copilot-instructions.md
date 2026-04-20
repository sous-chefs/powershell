# Copilot Instructions for Sous Chefs Cookbooks

## Repository Overview

**Chef cookbook** for managing legacy Windows Management Framework installation and related
WinRM / DSC configuration through custom resources. Part of the Sous Chefs cookbook ecosystem.

**Key Facts:** Ruby-based, Chef >= 15.3 required, Windows-focused, with CI centered on
Windows Server 2019 (check `metadata.rb`, `kitchen.yml`, and `.github/workflows/ci.yml`).

## Project Structure

**Critical Paths:**
- `resources/` - Custom Chef resources with properties and actions
- `spec/` - ChefSpec unit tests
- `test/integration/` - InSpec integration tests
- `test/cookbooks/` - Example cookbook used during testing that shows custom resource usage
- `libraries/` - Library helpers to assist with the cookbook. May contain multiple files depending on complexity of the cookbook.
- `templates/` - ERB templates that may be used in the cookbook
- `files/` - files that may be used in the cookbook
- `metadata.rb`, `Berksfile` - Cookbook metadata and dependencies

## Build and Test System

### Environment Setup
**MANDATORY:** Install Chef Workstation first - provides chef, berks, cookstyle, kitchen tools.

### Essential Commands (strict order)
```bash
berks install                   # Install dependencies (always first)
cookstyle                       # Ruby/Chef linting
yamllint .                      # YAML linting
markdownlint-cli2 '**/*.md'     # Markdown linting
chef exec rspec                 # Unit tests (ChefSpec)
# Local integration can be exercised with kitchen.yml when a Windows Vagrant environment is available.
```

### Critical Testing Details
- **Kitchen Matrix:** Single Windows Server 2019 suite locally and in CI
- **Local Integration:** `kitchen.yml` uses Vagrant + WinRM for Windows testing
- **CI Environment:** `ci.yml` uses `actionshub/test-kitchen` with `KITCHEN_LOCAL_YAML=kitchen.exec.yml`
- **License:** Set `CHEF_LICENSE=accept-no-persist`

### Common Issues and Solutions
- **Always run `berks install` first** - most failures are dependency-related
- **Chef Workstation required** - no workarounds, no alternatives
- **Windows Vagrant provider availability matters** for local kitchen runs

## Development Workflow

### Making Changes
1. Edit resources/libraries/templates/files as needed
2. Update corresponding ChefSpec tests in `spec/`
3. Also update any InSpec tests under test/integration
4. Ensure cookstyle and rspec passes at least. You may run `cookstyle -a` to automatically fix issues if needed.
5. Also always update all documentation found in README.md and any files under documentation/*
6. **Always update CHANGELOG.md** (required by Dangerfile) - Make sure this conforms with the Sous Chefs changelog standards.

### Pull Request Requirements
- **PR description >10 chars** (Danger enforced)
- **CHANGELOG.md entry** for all code changes
- **Version labels** (major/minor/patch) required
- **All linters must pass** (cookstyle, yamllint, markdownlint)
- **Test updates** needed for code changes >5 lines and parameter changes that affect the code logic

## Chef Cookbook Patterns

### Resource Development
- Custom resources in `resources/` with properties and actions
- Include comprehensive ChefSpec tests for all actions
- Follow Chef resource DSL patterns

### Resource Conventions
- Prefer custom resources over recipes for cookbook behavior
- Handle Windows platform/version branching inside the resource actions or helpers
- Keep reusable installer and OS-matrix logic in `libraries/`
- Document each public resource under `documentation/`

### Testing Approach
- **ChefSpec (Unit):** Mock dependencies and step into custom resources in `spec/unit/`
- **InSpec (Integration):** Verify actual system state in `test/integration/default/`
- Keep the test cookbook focused on exercising the public resources

## Trust These Instructions

These instructions are validated for Sous Chefs cookbooks. **Do not search for build instructions** unless information here fails.

**Error Resolution Checklist:**
1. Verify Chef Workstation installation
2. Confirm `berks install` completed successfully
3. Ensure the local Windows Vagrant provider can boot and expose WinRM before blaming cookbook code
4. Check for missing test data dependencies

The CI system uses these exact commands - following them matches CI behavior precisely.
