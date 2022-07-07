# Developping autorest

## Requirements

- `node` (LTS recommended)
  - **On windows**: Make sure to choose to install the native build dependencies in the setup
  - Alternatively follow instruction here https://github.com/nodejs/node-gyp
- `python` 3.x

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

# Before making a pull request

Steps to do before making a pull request:

1. Run `rush change` and describe the change and if it should be a `major`, `minor` or `patch` version.

   - `major`: If there is a breaking change.(Except `autorest`, `@autorest/core` and `@autorest/modelefour` packages which should use minor bump for that.)
   - `minor`: If there is a new feature but not breaking(Except `autorest`, `@autorest/core` and `@autorest/modelefour` packages)
   - `patch`: For any bug fix.

2. Run `rush format` to ensure the code is formatted correctly.
