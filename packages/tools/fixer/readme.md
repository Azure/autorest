# Autorest Fixer

Autorest fixer is a tool to help migrating old pattern previously allowed or automatically fixed JIT in autorest but are not allowed anymore.

## Usage

```bash
# Install
npm install -g @autorest/fixer

# Run
autorest-fixer path/to/specs/**/*.json

# Run (Dry-run)
autorest-fixer --dry-run path/to/specs/**/*.json
```

### Help

```bash
autorest-fixer --help
```

```
cli.js <include..>

Start the server

Positionals:
  include  List of wildcard pattern/folder to search for specs.
                                                          [string] [default: []]

Options:
      --version  Show version number                                   [boolean]
      --help     Show help                                             [boolean]
  -v, --verbose  Run with verbose logging level.                       [boolean]
      --debug    Run with debug logging level.                         [boolean]
      --level    Run with given logging level.                          [string]
      --dry-run  Perform a dry run.                                    [boolean]
```

## List of fixes

| Code                  | Description                                                                                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `missing-type-object` | When defining a schema with properties many spec were missing the `type` property all together. Autorest used assume it was `type: object`. This fixer does go through and fix the issues. |
