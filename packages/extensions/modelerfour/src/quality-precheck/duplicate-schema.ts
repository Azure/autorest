import { Session } from "@autorest/extension-base";
import { items, length, values } from "@azure-tools/linq";
import oai3, { dereference, Dereferenced, JsonType, Schema } from "@azure-tools/openapi";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { getDiff } from "recursive-diff";

export class DuplicateSchemaChecker {
  public constructor(private session: Session<oai3.Model>, private options: ModelerFourOptions) {}

  public findDuplicateSchemas(spec: oai3.Model): oai3.Model {
    if (!spec.components?.schemas) {
      return spec;
    }
    let count = 0;
    for (;;) {
      const result = this.findAndRemoveDuplicateSchemas(spec);
      spec = result.spec;
      count += result.removedCount;
      if (result.removedCount === 0) {
        break;
      }
    }

    this.session.verbose(`Found and removed ${count} duplicate schema`, {});

    return spec;
  }

  private findAndRemoveDuplicateSchemas(spec: oai3.Model): { spec: oai3.Model; removedCount: number } {
    let errors = new Set<string>();

    const dupedNames = this.groupSchemasByName(spec);

    let count = 0;
    for (const [name, schemas] of dupedNames.entries()) {
      if (name && schemas.length > 1) {
        const result = this.resolveDuplicateSchemas(spec, name, schemas);
        if (result.errors.size > 0) {
          errors = new Set([...errors, ...result.errors]);
        }
        count += result.removedCount;
        spec = result.spec;
      }
    }

    for (const each of errors) {
      // Allow duplicate schemas if requested
      if (this.options["lenient-model-deduplication"]) {
        this.session.warning(each, ["PreCheck", "DuplicateSchema"]);
      } else {
        this.session.error(
          `${each}; This error can be *temporarily* avoided by using the 'modelerfour.lenient-model-deduplication' setting.  NOTE: This setting will be removed in a future version of @autorest/modelerfour; schemas should be updated to fix this issue sooner than that.`,
          ["PreCheck", "DuplicateSchema"],
        );
      }
    }

    return { spec, removedCount: count };
  }
  private groupSchemasByName(spec: oai3.Model) {
    return items(spec.components?.schemas)
      .select((s) => ({ key: s.key, value: dereference(spec, s.value) }))
      .groupBy(
        // Make sure to check x-ms-client-name first to see if the schema is already being renamed
        (each) => each.value.instance["x-ms-client-name"] || each.value.instance["x-ms-metadata"]?.name,
        (each) => each,
      );
  }

  private resolveDuplicateSchemas(
    spec: oai3.Model,
    name: string,
    schemas: DereferencedSchema[],
  ): { spec: oai3.Model; errors: Set<string>; removedCount: number } {
    const [baseSchema, ...otherSchemas] = schemas;
    const errors = new Set<string>();
    const sameSchemas = [];
    for (const otherSchema of otherSchemas) {
      const diff = getDiff(baseSchema.value.instance, otherSchema.value.instance).filter(
        (each) => each.path[0] !== "description" && each.path[0] !== "x-ms-metadata",
      );

      if (diff.length === 0) {
        sameSchemas.push(otherSchema);
      } else {
        if (values(schemas).any((each) => this.isObjectOrEnum(each.value.instance))) {
          const rdiff = getDiff(otherSchema.value.instance, baseSchema.value.instance).filter(
            (each) => each.path[0] !== "description" && each.path[0] !== "x-ms-metadata",
          );
          if (diff.length > 0) {
            const details = diff
              .map((each) => {
                const path = each.path.join(".");
                let iValue = each.op === "add" ? "<none>" : JSON.stringify(each.oldVal);
                if (each.op !== "update") {
                  const v = rdiff.find((each) => each.path.join(".") === path);
                  iValue = JSON.stringify(v?.val);
                }
                const nValue = each.op === "delete" ? "<none>" : JSON.stringify(each.val);
                return `${path}: ${iValue} => ${nValue}`;
              })
              .join(",");
            errors.add(`Duplicate Schema named ${name} -- ${details} `);
          }
        }
      }
    }

    // found two schemas that are indeed the same.
    // stop, find all the $refs to the second one, and rewrite them to go to the first one.
    // then go back and start again.
    // Restart the scan now that the duplicate has been removed

    // it may not be identical, but if it's not an object, I'm not sure we care too much.
    if (errors.size === 0) {
      spec = this.removeDuplicateSchemas(spec, name, [baseSchema, ...sameSchemas]);
    }
    return {
      spec: spec,
      errors,
      removedCount: sameSchemas.length,
    };
  }

  private removeDuplicateSchemas(spec: oai3.Model, name: string, schemas: DereferencedSchema[]): oai3.Model {
    const { keep: schemaToKeep, remove: schemasToRemove } = this.findSchemaToRemove(spec, schemas);
    const newSpec = this.replaceRefs(spec, schemaToKeep, schemasToRemove);

    for (const schemaToRemove of schemasToRemove) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      delete newSpec.components!.schemas![schemaToRemove.key];

      // update metadata to match
      const schema = newSpec?.components?.schemas?.[schemaToKeep.key];
      if (schema) {
        const primarySchema = dereference(newSpec, schema);
        const primaryMetadata = primarySchema.instance["x-ms-metadata"];
        const secondaryMetadata = schemaToRemove.value.instance["x-ms-metadata"];

        if (primaryMetadata && secondaryMetadata) {
          primaryMetadata.apiVersions = [
            ...new Set<string>([...(primaryMetadata.apiVersions || []), ...(secondaryMetadata.apiVersions || [])]),
          ];
          primaryMetadata.filename = [
            ...new Set<string>([...(primaryMetadata.filename || []), ...(secondaryMetadata.filename || [])]),
          ];
          primaryMetadata.originalLocations = [
            ...new Set<string>([
              ...(primaryMetadata.originalLocations || []),
              ...(secondaryMetadata.originalLocations || []),
            ]),
          ];
          primaryMetadata["x-ms-secondary-file"] = !(
            !primaryMetadata["x-ms-secondary-file"] || !secondaryMetadata["x-ms-secondary-file"]
          );
        }
      }
    }

    this.session.verbose(
      `Schema ${name} has multiple identical declarations, reducing to just one - removing: ${schemasToRemove.length}, keeping: ${schemaToKeep.key}`,
      ["PreCheck", "ReducingSchema"],
    );

    return newSpec;
  }

  private replaceRefs(spec: oai3.Model, schemaToKeep: DereferencedSchema, schemasToRemove: DereferencedSchema[]) {
    const newRef = `#/components/schemas/${schemaToKeep.key}`;
    const refsToReplace = new Set(schemasToRemove.map((x) => `#/components/schemas/${x.key}`));
    visit(spec, (node) => {
      if (typeof node === "object" && node.$ref && refsToReplace.has(node.$ref)) {
        node.$ref = newRef;
        return true;
      }
      return false;
    });
    return spec;
  }

  private replaceRefs2(spec: oai3.Model, schemaToKeep: DereferencedSchema, schemasToRemove: DereferencedSchema[]) {
    let text = JSON.stringify(spec);
    text = this.replaceRefsInRawSpec(text, schemaToKeep, schemasToRemove);
    return JSON.parse(text);
  }

  private replaceRefsInRawSpec(text: string, schemaToKeep: DereferencedSchema, schemasToRemove: DereferencedSchema[]) {
    for (const schemaToRemove of schemasToRemove) {
      text = text.replace(
        new RegExp(`"\\#\\/components\\/schemas\\/${schemaToRemove.key}"`, "g"),
        `"#/components/schemas/${schemaToKeep.key}"`,
      );
    }
    return text;
  }

  /**
   * Find which schema to remove out of the list of schemas.
   * @param spec Spec.
   * @param schemas List of duplicate schema.
   * @returns Schema to keep and list of schema to remove.
   */
  private findSchemaToRemove(
    spec: oai3.Model,
    schemas: DereferencedSchema[],
  ): { keep: DereferencedSchema; remove: DereferencedSchema[] } {
    const nonRefSchema = schemas.find((x) => spec.components?.schemas?.[x.key].$ref === undefined);
    if (nonRefSchema) {
      return { keep: nonRefSchema, remove: schemas.filter((x) => x.key !== nonRefSchema.key) };
    } else {
      throw new Error(`Unexpected error. All the duplicate schemas ${schemas[0].value.name} are $ref`);
    }
  }

  private isObjectOrEnum(schema: Schema) {
    switch (schema.type) {
      case JsonType.Array:
      case JsonType.Boolean:
      case JsonType.Number:
        return false;

      case JsonType.String:
        return schema.enum || schema["x-ms-enum"];

      case JsonType.Object:
        // empty objects don't worry.
        if (length(schema.properties) === 0 && length(schema.allOf) === 0) {
          return false;
        }
        return true;

      default:
        return length(schema.properties) > 0 || length(schema.allOf) > 0 ? true : false;
    }
  }
}

interface DereferencedSchema {
  key: string;
  value: Dereferenced<Schema>;
}

function visit(obj: any, visitor: (obj: any) => boolean) {
  if (!obj) {
    return undefined;
  }

  if (visitor(obj)) {
    return;
  }

  if (Array.isArray(obj)) {
    for (const item of obj) {
      visit(item, visitor);
    }
  } else if (typeof obj === "object") {
    for (const [key, item] of Object.entries(obj)) {
      if (key === "x-ms-examples") {
        continue;
      }

      visit(item, visitor);
    }
  }
  return false;
}
