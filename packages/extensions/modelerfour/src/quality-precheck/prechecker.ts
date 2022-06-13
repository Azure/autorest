import { Session, AutorestExtensionHost, startSession } from "@autorest/extension-base";
import { shadowPosition } from "@azure-tools/codegen";
import {
  Model as oai3,
  Refable,
  Dereferenced,
  dereference,
  Schema,
  JsonType,
  StringFormat,
} from "@azure-tools/openapi";
import { getDiff } from "recursive-diff";
import { Interpretations } from "../modeler/interpretations";

import { ModelerFourOptions } from "../modeler/modelerfour-options";
import { DuplicateSchemaMerger } from "./duplicate-schema-merger";

export async function processRequest(host: AutorestExtensionHost) {
  const debug = (await host.getValue("debug")) || false;

  try {
    const session = await startSession<oai3>(host);

    // process
    const plugin = new QualityPreChecker(session);

    const input = plugin.input;
    // go!
    const result = plugin.process();

    // throw on errors.
    if (!(await session.getValue("ignore-errors", false))) {
      session.checkpoint();
    }

    host.writeFile({
      filename: "prechecked-openapi-document.yaml",
      content: JSON.stringify(result, null, 2),
      artifactType: "prechecked-openapi-document",
      sourceMap: { type: "identity", source: session.filename },
    });
    host.writeFile({
      filename: "original-openapi-document.yaml",
      content: JSON.stringify(input, null, 2),
      artifactType: "openapi-document",
      sourceMap: { type: "identity", source: session.filename },
    });
  } catch (error: any) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(error)} ${error.stack}`);
    }
    throw error;
  }
}

export class QualityPreChecker {
  input: oai3;
  private options: ModelerFourOptions;
  protected interpret: Interpretations;

  constructor(protected session: Session<oai3>) {
    this.input = shadowPosition(session.model); // shadow(session.model, filename);
    this.options = this.session.configuration.modelerfour ?? {};
    this.interpret = new Interpretations(session);
  }

  private resolve<T>(item: Refable<T>): Dereferenced<T> {
    return dereference(this.input, item);
  }

  getProperties(schema: Schema) {
    return Object.entries(schema.properties ?? {}).map(([key, value]) => ({
      key: key,
      name: <string>this.interpret.getPreferredName(value, key),
      property: this.resolve(value).instance,
    }));
    //return items(schema.properties).toMap(each => <string>this.interpret.getPreferredName(each.value, each.key), each => this.resolve(each.value).instance);
  }

  getSchemasFromArray(
    tag: string,
    schemas: Array<Refable<Schema>> | undefined,
  ): Iterable<{ name: string; schema: Schema; tag: string }> {
    return Object.values(schemas ?? []).map((a) => {
      const { instance: schema, name } = this.resolve(a);
      return {
        name: this.interpret.getName(name, schema),
        schema,
        tag,
      };
    });
  }

  *getAllParents(tag: string, schema: Schema): Iterable<{ name: string; schema: Schema; tag: string }> {
    for (const parent of this.getSchemasFromArray(tag, schema.allOf)) {
      yield parent;
      yield* this.getAllParents(parent.name, parent.schema);
    }
  }

  *getGrandParents(tag: string, schema: Schema): Iterable<{ name: string; schema: Schema; tag: string }> {
    for (const parent of this.getSchemasFromArray(tag, schema.allOf)) {
      yield* this.getAllParents(parent.name, parent.schema);
    }
  }

  checkForHiddenProperties(schemaName: string, schema: Schema, completed = new WeakSet<Schema>()) {
    if (completed.has(schema)) {
      return;
    }
    completed.add(schema);

    if (schema.allOf && schema.properties) {
      const myProperties = this.getProperties(schema);

      for (const { name: parentName, schema: parentSchema } of this.getAllParents(schemaName, schema)) {
        this.checkForHiddenProperties(parentName, parentSchema, completed);

        for (const { key, name: propName, property: parentProp } of this.getProperties(parentSchema)) {
          const myProp = myProperties.find((each) => each.name === propName);
          if (myProp) {
            // check if the only thing different is the description.
            const diff = getDiff(parentProp, myProp.property).filter(
              (each) => each.path[0] !== "description" && each.path[0] !== "x-ms-metadata",
            );

            if (diff.length === 0) {
              // the property didn't change except for description.
              // we can let this go with a warning.
              this.session.warning(
                `Schema '${schemaName}' has a property '${propName}' that is already declared the parent schema '${parentName}' but isn't significantly different. The property has been removed from ${schemaName}`,
                ["PreCheck", "PropertyRedeclarationWarning"],
              );
              delete schema.properties[myProp.key];
              continue;
            }

            if (diff.length === 1) {
              // special case to yell about readonly changes
              if (diff[0].path[0] === "readOnly") {
                this.session.warning(
                  `Schema '${schemaName}' has a property '${propName}' that is already declared the parent schema '${parentName}' but 'readonly' has been changed -- this is not permitted. The property has been removed from ${schemaName}`,
                  ["PreCheck", "PropertyRedeclarationWarning"],
                );
                delete schema.properties[myProp.key];
                continue;
              }
            }

            if (diff.length > 0) {
              const details = diff
                .map((each) => `${each.path.join(".")} => '${each.op === "delete" ? "<removed>" : each.val}'`)
                .join(",");
              this.session.warning(
                `Schema '${schemaName}' has a property '${propName}' that is conflicting with a property in the parent schema '${parentName}' differs more than just description : [${details}]`,
                ["PreCheck", "PropertyRedeclaration"],
              );
              continue;
            }
          }
        }
      }
    }
  }

  checkForDuplicateParents(schemaName: string, schema: Schema, completed = new WeakSet<Schema>()) {
    if (completed.has(schema)) {
      return;
    }
    completed.add(schema);

    if (schema.allOf) {
      const grandParents = [...this.getGrandParents(schemaName, schema)];
      const direct = [...this.getSchemasFromArray(schemaName, schema.allOf)];

      for (const myParent of direct) {
        for (const duplicate of grandParents.filter((each) => each.schema === myParent.schema)) {
          this.session.error(
            `Schema '${schemaName}' inherits '${duplicate.tag}' via an \`allOf\` that is already coming from parent '${myParent.name}'`,
            ["PreCheck", "DuplicateInheritance"],
          );
        }
      }
    }
  }

  checkForDuplicateSchemas() {
    this.session.warning(
      "Checking for duplicate schemas, this could take a (long) while.  Run with --verbose for more detail.",
      ["PreCheck", "CheckDuplicateSchemas"],
    );

    const duplicateSchemaChecker = new DuplicateSchemaMerger(this.session, this.options);
    this.input = duplicateSchemaChecker.findDuplicateSchemas(this.input);
  }

  fixUpSchemasThatUseAllOfInsteadOfJustRef() {
    for (const { schema, key } of this.listSchemas()) {
      // we're looking for schemas that offer no possible value
      // because they just use allOf instead of $ref
      if (!schema.type || schema.type === JsonType.Object) {
        if (Object.keys(schema.allOf ?? {}).length === 1) {
          if (Object.keys(schema.properties ?? {}).length > 0) {
            continue;
          }
          if (schema.additionalProperties) {
            continue;
          }

          const $ref = (schema?.allOf?.[0] as any)?.$ref;

          const text = JSON.stringify(this.input);
          this.input = JSON.parse(text.replace(new RegExp(`"\\#\\/components\\/schemas\\/${key}"`, "g"), `"${$ref}"`));
          const location = schema["x-ms-metadata"].originalLocations?.[0]?.replace(/^.*\//, "");
          delete this.input.components?.schemas?.[key];
          this.session.warning(
            `Schema '${location}' is using an 'allOf' instead of a $ref. This creates a wasteful anonymous type when generating code.`,
            ["PreCheck", "AllOfWhenYouMeantRef"],
          );
        }
      }
    }
  }

  fixUpObjectsWithoutType() {
    for (const { name, schema } of this.listSchemas()) {
      if (<any>schema.type === "file" || <any>schema.format === "file" || <any>schema.format === "binary") {
        // handle inconsistency in file format handling.
        this.session.warning(
          `'The schema ${schema?.["x-ms-metadata"]?.name || name} with 'type: ${schema.type}', format: ${
            schema.format
          }' will be treated as a binary blob for binary media types.`,
          ["PreCheck", "BinarySchema"],
          schema,
        );
        schema.type = JsonType.String;
        schema.format = StringFormat.Binary;
      }

      switch (schema.type) {
        case undefined:
        case null:
          if (schema.properties) {
            // if the model has properties, then we're going to assume they meant to say JsonType.object
            // but we're going to warn them anyway.

            this.session.warning(
              `The schema '${
                schema?.["x-ms-metadata"]?.name || name
              }' with an undefined type and declared properties is a bit ambiguous. This has been auto-corrected to 'type:object'`,
              ["PreCheck", "SchemaMissingType"],
              schema,
            );
            schema.type = JsonType.Object;
            break;
          }
          if (schema.additionalProperties) {
            // this looks like it's going to be a dictionary
            // we'll mark it as object and let the processObjectSchema sort it out.
            this.session.warning(
              `The schema '${
                schema?.["x-ms-metadata"]?.name || name
              }' with an undefined type and additionalProperties is a bit ambiguous. This has been auto-corrected to 'type:object'`,
              ["PreCheck", "SchemaMissingType"],
              schema,
            );
            schema.type = JsonType.Object;
            break;
          }

          if (schema.allOf || schema.anyOf || schema.oneOf) {
            // if the model has properties, then we're going to assume they meant to say JsonType.object
            // but we're going to warn them anyway.
            this.session.warning(
              `The schema '${
                schema?.["x-ms-metadata"]?.name || name
              }' with an undefined type and 'allOf'/'anyOf'/'oneOf' is a bit ambiguous. This has been auto-corrected to 'type:object'`,
              ["PreCheck", "SchemaMissingType"],
              schema,
            );
            schema.type = JsonType.Object;
            break;
          }
          break;
      }
    }
  }

  isEmptyObjectSchema(schema: Schema): boolean {
    if (
      Object.keys(schema.properties ?? {}).length > 0 ||
      Object.keys(schema.allOf ?? {}).length > 0 ||
      schema.additionalProperties === true
    ) {
      return false;
    }

    if (schema.additionalProperties !== false) {
      const resolved = this.resolve(schema.additionalProperties);
      return !resolved.instance || this.isEmptyObjectSchema(resolved.instance);
    }

    return true;
  }

  fixUpSchemasWithEmptyObjectParent() {
    for (const { name, schema } of this.listSchemas()) {
      if (schema.type === JsonType.Object) {
        if (Object.keys(schema.allOf ?? {}).length > 1) {
          const schemaName = schema["x-ms-metadata"]?.name || name;
          schema.allOf = schema.allOf?.filter((p, index) => {
            const parent = this.resolve(p).instance;

            if (this.isEmptyObjectSchema(parent)) {
              this.session.warning(
                `Schema '${schemaName}' has an allOf list with an empty object schema as a parent, removing it.`,
                ["PreCheck", "EmptyParentSchemaWarning"],
                p,
              );
              return false;
            }

            return true;
          });
        }
      }
    }
  }

  private checkParentSameType() {
    for (const { name, schema } of this.listSchemas()) {
      if (schema.allOf && schema.type) {
        const schemaName = getSchemaName(schema, name);
        for (const parentRef of schema.allOf) {
          const parent = this.resolve(parentRef).instance;
          if (parent.type && parent.type !== schema.type) {
            const parentName = getSchemaName(parent, name);
            const lines = [
              `Schema '${schemaName}' has an allOf reference to '${parentName}' but those schema have different types:`,
              `  - ${schemaName}: ${schema.type}`,
              `  - ${parentName}: ${parent.type}`,
            ];

            this.session.error(lines.join("\n"), ["PreCheck", "AllOfTypeDifferent"], parentRef);
          }
        }
      }
    }
  }

  process() {
    if (this.options["remove-empty-child-schemas"]) {
      this.fixUpSchemasThatUseAllOfInsteadOfJustRef();
    }

    this.fixUpObjectsWithoutType();

    this.fixUpSchemasWithEmptyObjectParent();

    this.checkForDuplicateSchemas();

    this.checkParentSameType();

    let onlyOnce = new WeakSet<Schema>();
    for (const { name, schema } of this.listSchemas()) {
      this.checkForHiddenProperties(this.interpret.getName(name, schema), schema, onlyOnce);
    }

    onlyOnce = new WeakSet<Schema>();
    for (const { name, schema } of this.listSchemas()) {
      this.checkForDuplicateParents(this.interpret.getName(name, schema), schema, onlyOnce);
    }

    return this.input;
  }

  private listSchemas(): Array<{ schema: Schema; name: string; key: string }> {
    const schemas = this.input.components?.schemas;
    if (!schemas) {
      return [];
    }
    return Object.entries(schemas).map(([key, value]) => {
      const { instance, name } = this.resolve(value);
      return {
        key,
        schema: instance,
        name,
      };
    });
  }
}

function getSchemaName(schema: Schema, id: string) {
  return schema["x-ms-metadata"]?.name || id;
}
