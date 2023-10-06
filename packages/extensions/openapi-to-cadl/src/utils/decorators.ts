import { ChoiceSchema, ObjectSchema, Parameter, Property, Schema, SealedChoiceSchema } from "@autorest/codemodel";
import { CadlDecorator, DecoratorArgument } from "../interfaces";
import { getOwnDiscriminator } from "./discriminator";
import { isSealedChoiceSchema, isStringSchema } from "./schemas";

export function getModelDecorators(model: ObjectSchema): CadlDecorator[] {
  const decorators: CadlDecorator[] = [];

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

export function getPropertyDecorators(element: Property | Parameter): CadlDecorator[] {
  const decorators: CadlDecorator[] = [];

  const paging = element.language.default.paging ?? {};

  if ((element as Property).readOnly) {
    decorators.push({ name: "visibility", arguments: ["read"] });
  }

  if (paging.isNextLink) {
    decorators.push({ name: "nextLink" });
  }

  if (paging.isValue) {
    decorators.push({ name: "items" });
  }

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
    const locationDecorator: CadlDecorator = { name: location };

    if (location === "query") {
      locationDecorator.arguments = [element.language.default.serializedName];
    }

    decorators.push(locationDecorator);
  }

  if (!isParameter(element) && element.serializedName !== element.language.default.name) {
    decorators.push({
      name: "projectedName",
      arguments: ["json", (element as Property).serializedName],
    });
  }

  return decorators;
}

function isParameter(schema: Parameter | Property): schema is Parameter {
  return !(schema as Property).serializedName;
}

function getStringSchemaDecorators(schema: Schema, decorators: CadlDecorator[]): void {
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

export function getEnumDecorators(enumeration: SealedChoiceSchema | ChoiceSchema): CadlDecorator[] {
  const decorators: CadlDecorator[] = [];

  if (isSealedChoiceSchema(enumeration)) {
    decorators.push({
      name: "Azure.Core.fixed",
      module: "@azure-tools/typespec-azure-core",
    });
  }

  return decorators;
}
export function generateDecorators(decorators: CadlDecorator[] = []): string {
  const definitions: string[] = [];
  for (const decorator of decorators ?? []) {
    if (decorator.fixMe) {
      definitions.push(decorator.fixMe.join(`\n`));
    }
    if (decorator.arguments) {
      definitions.push(`@${decorator.name}(${decorator.arguments.map((a) => getArgumentValue(a)).join(", ")})`);
    } else {
      definitions.push(`@${decorator.name}`);
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
