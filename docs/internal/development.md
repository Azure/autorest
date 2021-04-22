# Autorest Development

## Requirements

- `node` (LTS recommended)

Optional recommendation:

- VSCode with the following extensions:

  - Prettier
  - ESLint
  - EditorConfig

## First build

1. Install [rush.js](https://rushjs.io/pages/intro/get_started/) using

```bash
npm install -g @microsoft/rush
```

2. Install dependencies

```bash
rush update
```

3. Build

```bash
rush build

# or to do a force rebuild.
rush rebuild
```

## Run in watch mode

When working on autorest it is recommended to have the compiler run in watch mode. This means that on file changes typescript will automatically recompile and produce the output.

```bash
# Run for all packages.
rush watch
# Run for a specific package.
npm run watch
```

## Test

Test framework we used is [jest](https://jestjs.io/)

To run the test on the built product you have 2 options:

1. Run all the tests using

```bash
rush test:ci
```

2. Run individual project tests(Recommended when working on test)

```bash
# Go to the package directory
cd packages/<type>/<package>/

# Run test in interactive mode
npm test

# Alternatively you can run them once with coverage(Same as rush test:ci)
npm run test:ci
```

## Other commands

- Linting

```bash
# Run for all packages.
rush lint
# Run for a specific package.
npm run lint
```

- Cleaning

```bash
# Run for all packages.
rush clean
# Run for a specific package.
npm run clean
```

## Use your local changes

You can tell autorest to use your local changes.

- For `@autorest/core`, use the `--version` option

```bash
autorest --version:<path-to-repo>/packages/extensions/core
```

- For `@autorest/modelerfour`, use the `--use` option

```bash
autorest --use:<path-to-repo>/packages/extensions/modelerfour
```

- For `autorest itself`, change the command

```bash
node <path-to-repo>/packages/apps/autorest/entrypoints/app.js
```
