# Default Configuration - Directives

The built-in `transform` directive with its filters `from` and `where` are very powerful, but can become verbose and thus hard to reuse for common patterns (e.g. rename an operation).
Furthermore, they usually rely on precise data formats (e.g. where to find operations in the `code-model-v1`) and thus break once the data format changes.
We propose the following mechanism of declaring directives similar to macros, which allows capturing commonly used directives in a more high-level way.
Configuration files using these macros instead of "low-level" directives are robust against changes in the data format as the declaration in here will be adjusted accordingly.

## How it works

A declaration such as

```yaml false
declare-directive:
  my-directive: >-
    [
      {
        transform: `some transformer, parameterized with '${JSON.stringify($)}'`
      },
      {
        from: "code-model-v1"
        transform: `some other transformer, parameterized with '${JSON.stringify($)}'`
      }
    ]
```

can be used by naming it in a `directive` section:

```yaml false
directive:
  - my-directive: # as a standalone, with an object as parameter
      foo: bar
      baz: 42
  - from: a
    where: b
    my-directive: 42 # together with other stuff, with a number as parameter
```

Each `directive` entry that names `my-directive` will be expanded with the whatever the declaration evaluates to, where `$` is substituted with the value provided to the directive when used.
If the declaration evaluates to an array, the directives are duplicated accordingly (this enables directive declarations that transform data on multiple stages).
In the above example, `directive` gets expanded to:

```yaml false
directive:
  - transform: >-
      some transformer, parameterized with '{ "foo": \"bar\", "baz": 42 }'
  - from: code-model-v1
    transform: >-
      some other transformer, parameterized with '{ "foo": \"bar\", "baz": 42 }'
  - from: a
    where: b
    transform: >-
      some transformer, parameterized with '42'
  - from: a
    where: b
    transform: >-
      some other transformer, parameterized with '42'
```

As can be seen in the last `directive`, `from` as specified originally was not overridden by `code-model-v1`, i.e. what was specified by the user is given higher priority.

## `set`

Formerly implemented in the AutoRest core itself, `set` is now just syntactic sugar for `transform`.

```yaml
declare-directive:
  set: >-
    { transform: `return ${JSON.stringify($)}` }
```

## Operations

### Selection

Select operations by ID at different stages of the pipeline.

```yaml
declare-directive:
  where-operation: >-
    (() => {
      switch ($context.from) {
        case "code-model-v1":
          return { from: "code-model-v1", where: `$.operations[*].methods[?(@.serializedName == ${JSON.stringify($)})]` };

        case "openapi-document":
          return { from: "openapi-document", where: `$..paths.*[?(@.operationId == ${JSON.stringify($)})]` };

        case "swagger-document":
        default:
          return { from: "swagger-document", where: `$.paths.*[?(@.operationId == ${JSON.stringify($)})]` };
      }
    })()
  where-model: >-
    (() => {
      switch ($context.from) {
        case "code-model-v1":
          throw "not implemented";

        case "code-model-v3":
          return {from: "code-model-v3", where: `$.schemas[?(/${$}/i.exec(@.details.default.name))]`};

        case "openapi-document":
          return { from: "openapi-document", where: `$.schemas[${JSON.stringify($)}]` };

        case "swagger-document":
        default:
          return { from: "swagger-document", where: `$.definitions[${JSON.stringify($)}]` };
      }
    })()
```

## Removal

Removes an operation by ID.

```yaml
declare-directive:
  remove-operation: >-
    [{
      from: 'openapi-document',
      "where-operation": $,
      transform: '$ = undefined'
    },
    {
      from: 'swagger-document',
      "where-operation": $,
      transform: '$ = undefined'
    }
    ]
  rename-operation: >-
    [{
      from: 'swagger-document',
      "where-operation": $.from,
      transform: `$.operationId = ${JSON.stringify($.to)}`
    },{
      from: 'openapi-document',
      "where-operation": $.from,
      transform: `$.operationId = ${JSON.stringify($.to)}`
    }]
  remove-model: >-
    [{
      from: 'swagger-document',
      "where-model": $,
      transform: 'return undefined'
    },{
      from: 'openapi-document',
      "where-model": $,
      transform: 'return undefined'
    }]
  rename-model: >-
    [{
      from: 'swagger-document',
      where: '$.definitions',
      transform: `if ($[${JSON.stringify($.from)}]) { $[${JSON.stringify($.to)}] = $[${JSON.stringify($.from)}]; delete $[${JSON.stringify($.from)}]; }`
    },
    {
      from: 'swagger-document',
      where: `$..['$ref']`,
      transform: `$ = $ === "#/definitions/${$.from}" ? "#/definitions/${$.to}" : $`
    },
    {
      from: 'swagger-document',
      where: `$..['$ref']`,
      transform: `$ = $ === ($documentPath + "#/definitions/${$.from}") ? ($documentPath + "#/definitions/${$.to}") : $`
    }]
  remove-property: >-
    [{
      from: 'swagger-document',
      transform: `delete $.properties[${JSON.stringify($)}]`
    },
    {
      from: 'openapi-document',
      transform: `delete $.properties[${JSON.stringify($)}]`
    }]
  rename-property: >-
    [{
      from: 'swagger-document',
      transform: `if ($.properties[${JSON.stringify($.from)}]) { $.properties[${JSON.stringify($.to)}] = $.properties[${JSON.stringify($.from)}]; delete $.properties[${JSON.stringify($.from)}]; }`
    },
    {
      from: 'openapi-document',
      transform: `if ($.properties[${JSON.stringify($.from)}]) { $.properties[${JSON.stringify($.to)}] = $.properties[${JSON.stringify($.from)}]; delete $.properties[${JSON.stringify($.from)}]; }`
    }]

  remove-parameter: >-
    [{
      from: 'swagger-document',
      transform: `$.parameters = $.parameters.filter(x=> !(x.in === ${JSON.stringify($.in)} && x.name === ${JSON.stringify($.name)}))`
    },
    {
      from: 'openapi-document',
      transform: `$.parameters = $.parameters.filter(x=> !(x.in === ${JSON.stringify($.in)} && x.name === ${JSON.stringify($.name)}))`
    }]
```
