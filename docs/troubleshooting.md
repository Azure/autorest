# <img align="center" src="./images/logo.png">  Troubleshooting

## Generation Errors

There are two broad kinds of errors you can run into when generating: one kind is thrown earlier in the AutoRest pipeline and has to do with malformed swaggers (see [our main docs][main_docs] for more information). The other kind is thrown by the language generators.

The general AutoRest errors are thrown like this, and are commonly due to swagger issues.

```
FATAL: Error: Enum types of 'object' and format 'undefined' are not supported. Correct your input (HdiNodeTypes).
  Error: Plugin modelerfour reported failure.
```

If you're error does not look like this, refer to the docs in our language generators:

- [Python][python_generation]
- [Java][java_generation]
- [C#][csharp_generation]
- [Typescript][typescript_generation]


Both of these issues should give you enough information to fix the error. If not, please let us know in either the [main repo][autorest_issues], or in the [Python repo][autorest_python_issues]. Also let us know if you believe
there are erroneous errors being thrown.

## Debugging

We use flags to correspond our debugging process, view our [debugging flags][debugging_flags] to find out which ones would work best for you.

If you would like to actually debug through a language generator's code, see our language-specific instructions:

- [Python][python_debug]
- [Java][java_debug]
- [C#][csharp_debug]
- [Typescript][typescript_debug]

<!-- LINKS -->
[main_docs]: https://github.com/Azure/autorest/tree/master/docs/generate/troubleshooting.md
[autorest_issues]: https://github.com/Azure/autorest/issues
[autorest_python_issues]: https://github.com/Azure/autorest.python/issues
[main_debugging]: https://github.com/Azure/autorest/tree/master/docs/generate/troubleshooting.md#debugging
[autorest_python_repo]: https://github.com/Azure/autorest.python/tree/autorestv3
[debugging_flags]: generate/flags.md#debugging-flags
[python_generation]: https://github.com/Azure/autorest.python/tree/autorestv3/docs/troubleshooting.md#generation-errors
[java_generation]: https://github.com/Azure/autorest.java/tree/v4/docs/troubleshooting.md#generation-errors
[csharp_generation]: https://github.com/Azure/autorest.csharp/tree/v3/docs/troubleshooting.md#generation-errors
[typescript_generation]: https://github.com/Azure/autorest.typescript/tree/v6/docs/troubleshooting.md#generation-errors
[python_debug]: https://github.com/Azure/autorest.python/tree/autorestv3/docs/troubleshooting.md#debugging
[java_debug]: https://github.com/Azure/autorest.java/tree/v4/docs/troubleshooting.md#debugging
[csharp_debug]: https://github.com/Azure/autorest.csharp/tree/v3/docs/troubleshooting.md#debugging
[typescript_debug]: https://github.com/Azure/autorest.typescript/tree/v6/docs/troubleshooting.md#debugging