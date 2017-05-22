# Scenario: Client generation for multiple programming languages at once

> see https://aka.ms/autorest

## Configuration for validation testing
---
Testing composed merge state and ARM type validation rules.


``` yaml
title: Test Services
description: Test Services Client
api-version: 0-0-0
azure-validator: true

input-file:
- specjsons/vaults.json
- specjsons/vaultusages.json
```