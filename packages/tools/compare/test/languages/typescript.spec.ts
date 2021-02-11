import * as assert from "assert";
import * as path from "path";
import {
  parseFile,
  extractSourceDetails,
  SourceDetails,
  compareClass,
  compareParameter,
  compareMethod
} from "../../src/languages/typescript";
import { MessageType } from "../../src/comparers";

describe("TypeScript Parser", function() {
  it("extracts semantic elements from source", function() {
    const parseTree = parseFile(
      path.resolve(__dirname, "../artifacts/typescript/old/index.ts")
    );
    const sourceDetails: SourceDetails = extractSourceDetails(parseTree);

    assert.deepEqual(sourceDetails, {
      classes: [
        {
          name: "SomeClass",
          isExported: false,
          methods: [
            {
              name: "removedMethod",
              body: "{}",
              returnType: "void",
              visibility: "public",
              genericTypes: [],
              parameters: [
                {
                  name: "optional",
                  type: "string",
                  ordinal: 0,
                  isOptional: true
                }
              ]
            },
            {
              name: "changedParamType",
              body: "{}",
              returnType: "void",
              visibility: "public",
              genericTypes: [],
              parameters: [
                {
                  name: "firstParam",
                  type: "string",
                  ordinal: 0,
                  isOptional: false
                }
              ]
            },
            {
              name: "changedReturnType",
              body:
                '{\n    const booString = "boo";\n    return booString;\n  }',
              returnType: "string",
              visibility: "public",
              genericTypes: [],
              parameters: [
                {
                  name: "firstParam",
                  type: "string",
                  ordinal: 0,
                  isOptional: false
                }
              ]
            },
            {
              name: "reorderedParams",
              body: "{}",
              returnType: "void",
              visibility: "public",
              genericTypes: [],
              parameters: [
                {
                  name: "firstParam",
                  type: "string",
                  ordinal: 0,
                  isOptional: false
                },
                {
                  name: "secondParam",
                  type: "string",
                  ordinal: 1,
                  isOptional: false
                }
              ]
            },
            {
              name: "hasGenericParam",
              body: "{}",
              visibility: "protected",
              returnType: "void",
              genericTypes: [
                {
                  name: "T",
                  ordinal: 0
                }
              ],
              parameters: [
                {
                  name: "genericParam",
                  isOptional: false,
                  ordinal: 0,
                  type: "T"
                }
              ]
            }
          ],
          fields: [
            {
              name: "removedField",
              type: "string",
              value: undefined,
              isReadOnly: false,
              visibility: "private"
            },
            {
              name: "visibilityChangedField",
              type: "Namespace.Type",
              value: undefined,
              isReadOnly: false,
              visibility: "public"
            },
            {
              name: "readOnlyChangedField",
              type: "any",
              value: `"stuff"`,
              isReadOnly: true,
              visibility: "private"
            }
          ]
        },
        {
          name: "BaseClass",
          methods: [],
          fields: [],
          isExported: false
        },
        {
          name: "ExportedClass",
          baseClass: "BaseClass",
          interfaces: ["SomeInterface", "AnotherInterface"],
          methods: [],
          fields: [],
          isExported: true
        }
      ],
      interfaces: [
        {
          name: "SomeInterface",
          methods: [],
          fields: [],
          isExported: false
        },
        {
          name: "BaseInterface",
          methods: [],
          fields: [],
          isExported: false
        },
        {
          name: "AnotherInterface",
          interfaces: ["BaseInterface"],
          methods: [],
          fields: [],
          isExported: true
        }
      ],
      types: [
        {
          name: "SomeUnion",
          type: `"red" | "green" | "brurple"`,
          isExported: true
        }
      ],
      functions: [
        {
          name: "someFunction",
          body: '{\n  return "test";\n}',
          genericTypes: [
            {
              name: "T",
              ordinal: 0
            }
          ],
          parameters: [
            {
              name: "genericParam",
              type: "T",
              ordinal: 0,
              isOptional: false
            }
          ],
          returnType: "string"
        }
      ],
      variables: [
        {
          name: "SomeConst",
          type: "SomeUnion",
          value: `"red"`,
          isExported: true,
          isConst: true
        }
      ]
    } as SourceDetails);
  });

  it("compares parameters", () => {
    const result = compareParameter(
      {
        name: "firstParam",
        type: "string",
        ordinal: 0,
        isOptional: false
      },
      {
        name: "firstParam",
        type: "number",
        ordinal: 0,
        isOptional: true
      }
    );

    assert.deepEqual(result, {
      message: "firstParam",
      type: MessageType.Changed,
      children: [
        {
          message: "Type",
          type: MessageType.Outline,
          children: [
            { message: "string", type: MessageType.Removed },
            { message: "number", type: MessageType.Added }
          ]
        },
        {
          message: "Optional",
          type: MessageType.Outline,
          children: [
            { message: "false", type: MessageType.Removed },
            { message: "true", type: MessageType.Added }
          ]
        }
      ]
    });
  });

  it("compares base class references", () => {
    const result = compareClass(
      {
        name: "SomeClass",
        baseClass: "BaseClass",
        methods: [],
        fields: [],
        isExported: false
      },
      {
        name: "SomeClass",
        baseClass: "AnotherClass",
        methods: [],
        fields: [],
        isExported: false
      }
    );

    assert.deepEqual(result, {
      message: "SomeClass",
      type: MessageType.Changed,
      children: [
        {
          message: "Base Class",
          type: MessageType.Outline,
          children: [
            { message: "BaseClass", type: MessageType.Removed },
            { message: "AnotherClass", type: MessageType.Added }
          ]
        }
      ]
    });
  });

  it("compares interface implementation references", () => {
    const result = compareClass(
      {
        name: "SomeClass",
        methods: [],
        fields: [],
        isExported: false
      },
      {
        name: "SomeClass",
        interfaces: ["InterfaceA", "InterfaceB"],
        methods: [],
        fields: [],
        isExported: false
      }
    );

    assert.deepEqual(result, {
      message: "SomeClass",
      type: MessageType.Changed,
      children: [
        {
          message: "Interfaces",
          type: MessageType.Outline,
          children: [
            { message: "InterfaceA", type: MessageType.Added },
            { message: "InterfaceB", type: MessageType.Added }
          ]
        }
      ]
    });
  });

  it("compares methods", () => {
    const result = compareMethod(
      {
        name: "theFunc",
        returnType: "string",
        genericTypes: [],
        parameters: [
          {
            name: "firstParam",
            type: "string",
            ordinal: 0,
            isOptional: false
          }
        ]
      },
      {
        name: "theFunc",
        returnType: "any",
        genericTypes: [],
        parameters: [
          {
            name: "differentParam",
            type: "number",
            ordinal: 0,
            isOptional: true
          }
        ]
      }
    );

    assert.deepEqual(result, {
      message: "theFunc",
      type: MessageType.Changed,
      children: [
        {
          message: "Parameters",
          type: MessageType.Outline,
          children: [
            { message: "firstParam", type: MessageType.Removed },
            { message: "differentParam", type: MessageType.Added }
          ]
        },
        {
          message: "Return Type",
          type: MessageType.Outline,
          children: [
            { message: "string", type: MessageType.Removed },
            { message: "any", type: MessageType.Added }
          ]
        }
      ]
    });
  });
});
