# 4D Builder Playground

This repository contains example projects and test workflows used to
develop and validate reusable GitHub Actions from the **madamov/4d_actions**
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

## Workflows

All workflows are started manually with `workflow_dispatch` and call a
reusable workflow from `madamov/4d_actions` at the `v1` ref.

### Check 4D syntax on Windows

[`.github/workflows/check_syntax_windows.yml`](.github/workflows/check_syntax_windows.yml)
calls `check_4d_syntax.yml` on `windows-latest`. It runs the
`checkSyntax` 4D startup method and asks it to write its error report to
the runner's Documents directory.

```yaml
jobs:
  check-syntax:
    uses: madamov/4d_actions/.github/workflows/check_4d_syntax.yml@v1
    with:
      runner: windows-latest
      startup_method: checkSyntax
      user_parameters: '{"errorFolderPath":"__DOCUMENTS__"}'
```

After the reusable workflow finishes, the `verify-syntax` job checks its
`success` output. The job fails and reports the path from `error_file`
when the syntax check is unsuccessful.

### Check 4D syntax on macOS

[`.github/workflows/check_syntax_macos.yml`](.github/workflows/check_syntax_macos.yml)
has the same syntax-checking and verification flow as the Windows
example, but passes `macos-latest` as the runner:

```yaml
jobs:
  check-syntax:
    uses: madamov/4d_actions/.github/workflows/check_4d_syntax.yml@v1
    with:
      runner: macos-latest
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

Both syntax-checking workflows consume these outputs in their
verification jobs and fail when syntax errors are reported.

### Cache tool4d

[`.github/workflows/download_tool4d.yml`](.github/workflows/download_tool4d.yml)
calls `get_tool4d.yml` four times to prepare tool4d independently for
each tested version and runner combination:

| Version | Runner |
| --- | --- |
| 20.8 | `macos-latest` |
| 21.1 | `macos-latest` |
| 20.8 | `windows-latest` |
| 21.1 | `windows-latest` |

The four jobs can run in parallel. This workflow is useful for warming
or validating the reusable workflow's tool4d caches for all listed
platform/version combinations.

### Cache and upload 4D binaries

[`.github/workflows/cache_4d_binaries.yml`](.github/workflows/cache_4d_binaries.yml)
calls `get_cache_4d_binaries.yml` to download, install, and cache a
selected 4D version. Its manual-dispatch inputs are:

| Input | Description |
| --- | --- |
| `version` | Required 4D version; one of 20.8, 20.8 HF3, 20.8 HF4, 21.1, or 21 R3. Defaults to 20.8. |
| `downloader_version` | Optional 4D Downloader release tag; an empty value selects the latest release. |
| `sftp_url` | Optional destination URL for uploading the installed binaries over SFTP. |

4D Downloader is application written using Objo Studio with the purpose to download 4D installers from product-download.4d.com. 

The caller forwards the following repository secrets to the reusable
workflow:

-   `PRODUCT_DOWNLOAD_USERNAME` and `PRODUCT_DOWNLOAD_PASSWORD` for
    authenticated 4D product downloads
-   `DOWNLOADER_TOKEN` for obtaining the downloader
-   `SFTP_USERNAME`, `SFTP_PASSWORD`, and `SFTP_FINGERPRINT` for the
    optional SFTP upload (`SFTP_FINGERPRINT` is passed as
    `SFTP_HOST_FINGERPRINT`)

## Requirements

These examples require the reusable workflows from:

-   `madamov/4d_actions`

Depending on the workflow being tested, additional repository variables
or secrets may be required.

## Repository structure

``` text
.github/
└── workflows/
    ├── cache_4d_binaries.yml
    ├── check_syntax_macos.yml
    ├── check_syntax_windows.yml
    └── download_tool4d.yml
```

Additional workflow examples will be added as new reusable workflows
become available.

## Related repository

Reusable GitHub Actions are maintained in:

-   https://github.com/madamov/4d_actions

This repository only demonstrates how those workflows are intended to be
used.
