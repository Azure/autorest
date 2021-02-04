# Change Log - @autorest/core

This log was last generated on Thu, 04 Feb 2021 19:16:37 GMT and should not be manually modified.

## 3.0.6370
Thu, 04 Feb 2021 19:05:18 GMT

### Patches

- Internal: Moved source to src/ folder
- Refactoring: Cleanup of code running transform directives
- Internal code linting fixes
- Internal: Add some tests to the tree shaker

## 3.0.x
Tue, 4 Feb 2020 00:00:00 GMT

### Patches

- rebuild to pick up latest data-store to fix the caching filename size
- OAI2-to-OAI3 converter update in perks.
- TransformerViaPointer was turning null into {} 
- rebuild to fix NPM publishing problem.
- remove additionalProperties: false so v2 generators don't choke.
- rebuild to pick up perks change to fix multibyte utf8 over byte boundary problem
- rebuild to pick up a perks change to support turning underscore in semver to dash on gh releases
- rebuild to pick up newer extension library that supports python interpreter detection
- force rebuild to pick up fix in oai2 converter
- update the oai2-to-oai3 converter (parameterized host parameters should be client parameters if they are $ref'd)

