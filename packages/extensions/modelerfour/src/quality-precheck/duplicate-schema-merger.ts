import { Session } from "@autorest/extension-base";
import { length } from "@azure-tools/linq";
import oai3, { dereference, Dereferenced, JsonType, Schema } from "@azure-tools/openapi";
import { groupBy } from "lodash";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { getDiff, rdiffResult } from "recursive-diff";

export class DuplicateSchemaMerger {
  public constructor(private session: Session<oai3.Model>, private options: ModelerFourOptions) {}

  public findDuplicateSchemas(spec: oai3.Model): oai3.Model {
    if (!spec.components?.schemas) {
      return spec;
    }
    let count = 0;

    // Need to iterate until we find no duplicate.
    // This ensure that if 2 schema have properties referencing to schemas that get merged those schemas can also be merged.
    for (;;) {
      const result = this.findAndRemoveDuplicateSchemas(spec);
      spec = result.spec;
      count += result.removedCount;
      if (result.removedCount === 0) {
        break;
      }
    }
    this.session.verbose(`Found and removed ${count} duplicate schema`, {});
    this.findDifferentSchemasWithSameName(spec);

    return spec;
  }

  /**
   * Find all the schemas and group by name.
   * @param spec OpenAPI Spec.
   * @returns Map of schema name to schema using this name.
   */
  private groupSchemasByName(spec: oai3.Model): { [name: string]: DereferencedSchema[] } {
    const schemas = Object.entries(spec.components?.schemas ?? []).map(([key, value]) => ({
      key: key,
      value: dereference(spec, value),
    }));

    return groupBy(
      schemas,
      // Make sure to check x-ms-client-name first to see if the schema is already being renamed
      (each) => each.value.instance["x-ms-client-name"] || each.value.instance["x-ms-metadata"]?.name,
    );
  }

  private findAndRemoveDuplicateSchemas(spec: oai3.Model): { spec: oai3.Model; removedCount: number } {
    const dupedNames = this.groupSchemasByName(spec);

    let count = 0;
    for (const [name, schemas] of Object.entries(dupedNames)) {
      if (name && schemas.length > 1) {
        const result = this.resolveDuplicateSchemas(spec, name, schemas);

        count += result.removedCount;
        spec = result.spec;
      }
    }

    return { spec, removedCount: count };
  }

  /**
   * Find the differences between schemas with the same name and convert those to errors.
   * @param spec Spec
   */
  private findDifferentSchemasWithSameName(spec: oai3.Model) {
    const dupedNames = this.groupSchemasByName(spec);
    const errors = new Set<string>();
    for (const [name, schemas] of Object.entries(dupedNames)) {
      if (name && schemas.length > 1) {
        const [baseSchema, ...otherSchemas] = schemas;

        for (const otherSchema of otherSchemas) {
          if (schemas.find((x) => this.isObjectOrEnum(x.value.instance))) {
            const diff = diffSchemas(baseSchema.value.instance, otherSchema.value.instance);
            if (diff.length > 0) {
              const details = diff
                .map((each) => {
                  const path = each.path.join(".");
                  const oldValue = each.op === "add" ? "<none>" : JSON.stringify(each.oldVal);
                  const newValue = each.op === "delete" ? "<none>" : JSON.stringify(each.val);
                  return `  - ${path}: ${oldValue} => ${newValue}`;
                })
                .join("\n");
              errors.add(`Duplicate Schema named '${name}' (${diff.length} differences):\n${details}`);
            }
          }
        }
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
  }

  private resolveDuplicateSchemas(
    spec: oai3.Model,
    name: string,
    schemas: DereferencedSchema[],
  ): { spec: oai3.Model; removedCount: number } {
    const [baseSchema, ...otherSchemas] = schemas;
    const sameSchemas = otherSchemas.filter((otherSchema) => {
      const diff = diffSchemas(baseSchema.value.instance, otherSchema.value.instance);
      return diff.length === 0;
    });

    const newSpec = this.removeDuplicateSchemas(spec, name, [baseSchema, ...sameSchemas]);

    return {
      spec: newSpec,
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

/**
 * Get the list of difference between 2 schemas ignoring description and metadata.
 * @param baseSchema Baseline schema
 * @param otherSchema Schema to compare
 * @returns List of differences.
 */
function diffSchemas(baseSchema: oai3.Schema, otherSchema: oai3.Schema): rdiffResult[] {
  return getDiff(baseSchema, otherSchema, true).filter(
    (x) => x.path[0] !== "description" && x.path[0] !== "x-ms-metadata",
  );
}
