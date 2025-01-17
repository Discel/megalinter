---
title: PROTOBUF linters in MegaLinter
description: protolint is available to analyze PROTOBUF files in MegaLinter
---
<!-- markdownlint-disable MD003 MD020 MD033 MD041 -->
<!-- @generated by .automation/build.py, please do not update manually -->
<!-- Instead, update descriptor file at https://github.com/oxsecurity/megalinter/tree/main/megalinter/descriptors/protobuf.yml -->
# PROTOBUF

## Linters

| Linter                                                                                   | Additional                                                                                                                                                                               |
|------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [**protolint**](protobuf_protolint.md)<br/>[_PROTOBUF_PROTOLINT_](protobuf_protolint.md) | [![GitHub stars](https://img.shields.io/github/stars/yoheimuta/protolint?cacheSeconds=3600)](https://github.com/yoheimuta/protolint) ![autofix](https://shields.io/badge/-autofix-green) |

## Linted files

- File extensions:
  - `.proto`

## Configuration in MegaLinter

| Variable                      | Description                   | Default value |
|-------------------------------|-------------------------------|---------------|
| PROTOBUF_FILTER_REGEX_INCLUDE | Custom regex including filter |               |
| PROTOBUF_FILTER_REGEX_EXCLUDE | Custom regex excluding filter |               |

