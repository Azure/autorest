import {
  ChoiceSchema,
  ObjectSchema,
  ChoiceValue,
  Parameter,
  Property,
  Schema,
  SchemaType,
  SealedChoiceSchema,
  SerializationStyle,
  Operation,
  isNumberSchema,
} from "@autorest/codemodel";
import { TypespecDecorator, DecoratorArgument } from "../interfaces";
import { createCSharpNameDecorator } from "../pretransforms/rename-pretransform";
import { getOwnDiscriminator } from "./discriminator";
import { isSealedChoiceSchema, isStringSchema } from "./schemas";

export function getModelDecorators(model: ObjectSchema): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  const paging = model.language.default.paging ?? {};
  if (paging.isPageable) {
    decorators.push({
      name: "pagedResult",
      module: "@azure-tools/typespec-azure-core",
      namespace: "Azure.Core",
    });
  }

  const ownDiscriminator = getOwnDiscriminator(model);

  if (ownDiscriminator) {
    decorators.push({
      name: "discriminator",
      arguments: [ownDiscriminator.serializedName],
    });
  }

  if (model.language.default.isError) {
    decorators.push({ name: "error" });
  }

  let resource = model.language.default.resource;
  if (resource) {
    if (resource.startsWith("/")) {
      // Remove the leading
      resource = resource.slice(1);
    }
    decorators.push({
      name: "resource",
      module: "@azure-tools/typespec-azure-core",
      namespace: "Azure.Core",
      arguments: [resource],
    });
  }

  return decorators;
}

export function getModelClientDecorators(model: ObjectSchema): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (model.language.csharp?.name) {
    decorators.push(createCSharpNameDecorator(model));
  }
  return decorators;
}

export function getPropertyDecorators(element: Property | Parameter): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  const paging = element.language.default.paging ?? {};

  if (!isParameter(element)) {
    const visibility = getPropertyVisibility(element);
    if (visibility.length) {
      decorators.push({ name: "visibility", arguments: visibility });
    }
  }

  if (paging.isNextLink) {
    decorators.push({ name: "nextLink" });
  }

  if (paging.isValue) {
    decorators.push({ name: "items" });
  }

  if (element.schema.type === SchemaType.Credential) {
    decorators.push({ name: "secret" });
  }

  getNumberSchemaDecorators(element.schema, decorators);
  getStringSchemaDecorators(element.schema, decorators);

  if (element.language.default.isResourceKey) {
    decorators.push({
      name: "key",
      fixMe: [
        "// FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one",
      ],
    });
  }

  if (isParameter(element) && element?.protocol?.http?.in) {
    const location = element.protocol.http.in;
    const locationDecorator: TypespecDecorator = { name: location };

    if (location === "query") {
      locationDecorator.arguments = [element.language.default.serializedName];
      if (element.schema.type === SchemaType.Array) {
        let format = "multi";
        switch (element.protocol.http?.style) {
          case SerializationStyle.Form:
            if (!element.protocol.http?.explode) {
              format = "csv";
            }
            break;
          case SerializationStyle.PipeDelimited:
            format = "pipes";
            break;
          case SerializationStyle.Simple:
            format = "csv";
            break;
          case SerializationStyle.SpaceDelimited:
            format = "ssv";
            break;
          case SerializationStyle.TabDelimited:
            format = "tsv";
            break;
        }
        locationDecorator.arguments = [
          {
            value: `{name: "${element.language.default.serializedName}", format: "${format}"}`,
            options: { unwrap: true },
          },
        ];
      }
    }

    decorators.push(locationDecorator);
  }

  if (!isParameter(element) && element.serializedName !== element.language.default.name) {
    decorators.push({
      name: "encodedName",
      arguments: ["application/json", (element as Property).serializedName],
    });
  }

  return decorators;
}

export function getPropertyClientDecorators(element: Property | Parameter): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (element.extensions?.["x-ms-client-flatten"]) {
    decorators.push({
      name: "flattenProperty",
      module: "@azure-tools/typespec-client-generator-core",
      namespace: "Azure.ClientGenerator.Core",
      suppressionCode: "deprecated",
      suppressionMessage: "@flattenProperty decorator is not recommended to use.",
    });
  }

  if (element.language.csharp?.name) {
    decorators.push(createCSharpNameDecorator(element));
  }

  return decorators;
}

function isParameter(schema: Parameter | Property): schema is Parameter {
  return !(schema as Property).serializedName;
}

export function getPropertyVisibility(property: Property): string[] {
  const xmsMutability = property.extensions?.["x-ms-mutability"];
  if (!xmsMutability) {
    return property.readOnly ? ["read"] : [];
  }

  const visibility: string[] = [];

  if (Array.isArray(xmsMutability)) {
    if (xmsMutability.includes("read")) {
      visibility.push("read");
    }
    if (xmsMutability.includes("create")) {
      visibility.push("create");
    }
    if (xmsMutability.includes("update")) {
      visibility.push("update");
    }
  }

  return visibility;
}

function getNumberSchemaDecorators(schema: Schema, decorators: TypespecDecorator[]): void {
  if (!isNumberSchema(schema)) {
    return;
  }

  if (schema.maximum) {
    if (schema.exclusiveMaximum) {
      decorators.push({ name: "maxValueExclusive", arguments: [schema.maximum] });
    } else {
      decorators.push({ name: "maxValue", arguments: [schema.maximum] });
    }
  }

  if (schema.minimum) {
    if (schema.exclusiveMinimum) {
      decorators.push({ name: "minValueExclusive", arguments: [schema.minimum] });
    } else {
      decorators.push({ name: "minValue", arguments: [schema.minimum] });
    }
  }
}

function getStringSchemaDecorators(schema: Schema, decorators: TypespecDecorator[]): void {
  if (!isStringSchema(schema)) {
    return;
  }

  if (schema.maxLength) {
    decorators.push({ name: "maxLength", arguments: [schema.maxLength] });
  }

  if (schema.minLength) {
    decorators.push({ name: "minLength", arguments: [schema.minLength] });
  }

  if (schema.pattern) {
    decorators.push({ name: "pattern", arguments: [escapeRegex(schema.pattern)] });
  }
}

function escapeRegex(str: string) {
  return str.replace(/\\/g, "\\\\");
}

export function getEnumDecorators(enumeration: SealedChoiceSchema | ChoiceSchema): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (isSealedChoiceSchema(enumeration)) {
    decorators.push({
      name: "fixed",
      module: "@azure-tools/typespec-azure-core",
      namespace: "Azure.Core",
    });
  }

  return decorators;
}

export function getEnumClientDecorators(enumeration: SealedChoiceSchema | ChoiceSchema): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (enumeration.language.csharp?.name) {
    decorators.push(createCSharpNameDecorator(enumeration));
  }

  return decorators;
}

export function getEnumChoiceClientDecorators(enumChoice: ChoiceValue): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (enumChoice.language.csharp?.name) {
    decorators.push(createCSharpNameDecorator(enumChoice));
  }
  return decorators;
}

export function getOperationClientDecorators(operation: Operation): TypespecDecorator[] {
  const decorators: TypespecDecorator[] = [];

  if (operation.language.csharp?.name) {
    decorators.push(createCSharpNameDecorator(operation));
  }
  return decorators;
}

export function generateDecorators(decorators: TypespecDecorator[] = []): string {
  const definitions: string[] = [];
  for (const decorator of decorators ?? []) {
    if (decorator.fixMe) {
      definitions.push(decorator.fixMe.join(`\n`));
    }
    if (decorator.suppressionCode) {
      definitions.push(`#suppress "${decorator.suppressionCode}" "${decorator.suppressionMessage}"`);
    }
    if (decorator.arguments) {
      definitions.push(`@${decorator.name}(${decorator.arguments.map((a) => getArgumentValue(a)).join(", ")})`);
    } else {
      definitions.push(`@${decorator.name}`);
    }
  }

  return definitions.join("\n");
}

export function generateAugmentedDecorators(keyName: string, decorators: TypespecDecorator[] = []): string {
  const definitions: string[] = [];
  for (const decorator of decorators ?? []) {
    if (decorator.fixMe) {
      definitions.push(decorator.fixMe.join(`\n`));
    }
    if (decorator.suppressionCode) {
      definitions.push(`#suppress "${decorator.suppressionCode}" "${decorator.suppressionMessage}"`);
    }
    if (decorator.arguments) {
      definitions.push(
        `@@${decorator.name}(${keyName}, ${decorator.arguments.map((a) => getArgumentValue(a)).join(", ")})`,
      );
    } else {
      definitions.push(`@@${decorator.name}(${keyName})`);
    }
  }

  return definitions.join("\n");
}

function getArgumentValue(argument: DecoratorArgument | string | number): string {
  if (typeof argument === "string") {
    return `"${argument}"`;
  } else if (typeof argument === "number") {
    return `${argument}`;
  } else {
    let value = argument.value;
    if (!argument.options?.unwrap) {
      value = `${argument.value}`;
    }

    return value;
  }
}
