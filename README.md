# 4D Builder Playground

This repository contains example projects and test workflows used to
develop and validate reusable GitHub Actions from the **4d_actions**
repository.

It serves as a playground for experimenting with automated 4D
application builds, syntax checking, packaging, signing, and release
workflows before they are used in production repositories.

## Purpose

The repository is intentionally simple. Its goals are to:

-   verify new reusable workflows
-   reproduce and debug workflow issues
-   test cross-platform behavior
-   provide working examples for 4D developers

## Current examples

### Syntax checking

The repository includes examples showing how to run the reusable **Check
4D Syntax** workflow on different operating systems.

Example:

-   `check_syntax_windows.yml`
-   `check_syntax_macos.yml`
-   `check_syntax_linux.yml` (when available)

The Windows example calls the reusable workflow:

``` yaml
jobs:
  check-syntax:
    uses: madamov/4d_actions/.github/workflows/check_4d_syntax.yml@v1
    with:
      runner: windows-latest
      startup_method: checkSyntax
      user_parameters: '{"errorFolderPath":"__DOCUMENTS__"}'
```

The reusable workflow:

-   locates the 4D project
-   downloads or restores the correct version of **tool4d**
-   runs the requested startup method
-   collects the generated JSON result
-   exposes the following outputs:

  Output         Description
  -------------- ------------------------------------------------------
  `success`      `"true"` when syntax checking completed successfully
  `error_file`   Path to the generated JSON result file on the runner

A second job typically verifies these outputs and fails the workflow
when syntax errors are reported.

## Requirements

These examples require the reusable workflows from:

-   `madamov/4d_actions`

Depending on the workflow being tested, additional repository variables
or secrets may be required.

## Repository structure

``` text
.github/
└── workflows/
    check_syntax_windows.yml
    ...
```

Additional workflow examples will be added as new reusable workflows
become available.

## Related repository

Reusable GitHub Actions are maintained in:

-   https://github.com/madamov/4d_actions

This repository only demonstrates how those workflows are intended to be
used.
