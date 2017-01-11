# Linting

There are a number of validation messages that AutoRest will output when deserializing the spec file.

## Running linter (command line options)
Simply run AutoRest.exe against your spec file. Any errors will be in the console output.

If you want to see any other messages (e.g. Warnings or Info messages), use the `-Verbose` flag.

If you want AutoRest.exe to fail with an error code if any Warnings are found, use the `-ValidationLevel Warning` flag.

If you want to simply see that validation messages output, use `-CodeGenerator None` to suppress outputting code.

## Using linting in VS Code
Download the VS Code extension here: [https://github.com/Azure/openapi-lint-extension](https://github.com/Azure/openapi-lint-extension). The extension helps see each validation rule in situ, as well as providing other useful quality-of-life features for writing OpenAPI specs.

## Current list of rules displayed by the VS Code extension
These pages describe each rule in detail and how to fix the issue. They also show the effect that each issue has on the generated code, to make it easier to understand the rational behind the rule.
- [AnonymousParameterTypes](anonymous-parameter-types.md)
- [AvoidNestedProperties](avoid-nested-properties.md)
- [DefaultInEnum](default-in-enum.md)
- [DescriptiveDescriptionRequired](descriptive-description-required.md)
- [ModelTypeIncomplete](model-type-incomplete.md)
- [NonEmptyClientName](non-empty-client-name.md)
- [OperationDescriptionRequired](operation-description-required.md)
- [OperationIdNounInVerb](operation-id-noun-in-verb.md)
- [OperationIdSingleUnderscore](operation-id-single-underscore.md)
- [ParameterDescriptionRequired](parameter-description-required.md)
- [RequiredPropertiesMustExist](required-properties-must-exist.md)
- [ResponseRequired](response-required.md)
- [ValidFormats](valid-formats.md)
- [XmsPathsInPath](xms-paths-in-path.md)