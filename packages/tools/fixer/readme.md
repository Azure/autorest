# Autorest Fixer

Autorest fixer is a tool to help migrating old pattern previously allowed or automatically fixed JIT in autorest but are not allowed anymore.

List of fixes

| Code                  | Description                                                                                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `missing-type-object` | When defining a schema with properties many spec were missing the `type` property all together. Autorest used assume it was `type: object`. This fixer does go through and fix the issues. |
