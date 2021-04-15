import { Session } from "@autorest/extension-base";
import { items, length, values } from "@azure-tools/linq";
import oai3, { dereference, Dereferenced, JsonType, Schema } from "@azure-tools/openapi";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { getDiff } from "recursive-diff";

export class DuplicateSchemaChecker {
  public constructor(private session: Session<oai3.Model>, private options: ModelerFourOptions) {}

  public findDuplicateSchemas(): oai3.Model {
    let spec = this.session.model;

    // Returns true if scanning should be restarted
    const innerCheckForDuplicateSchemas = (): any => {
      const errors = new Set<string>();
      if (spec.components?.schemas) {
        const dupedNames = items(spec.components?.schemas)
          .select((s) => ({ key: s.key, value: dereference(spec, s.value) }))
          .groupBy(
            // Make sure to check x-ms-client-name first to see if the schema is already being renamed
            (each) => each.value.instance["x-ms-client-name"] || each.value.instance["x-ms-metadata"]?.name,
            (each) => each,
          );

        for (const [name, schemas] of dupedNames.entries()) {
          if (name && schemas.length > 1) {
            const diff = getDiff(schemas[0].value.instance, schemas[1].value.instance).filter(
              (each) => each.path[0] !== "description" && each.path[0] !== "x-ms-metadata",
            );

            if (diff.length === 0) {
              // found two schemas that are indeed the same.
              // stop, find all the $refs to the second one, and rewrite them to go to the first one.
              // then go back and start again.
              spec = this.removeDuplicateSchemas(spec, name, schemas[0], schemas[1]);
              // Restart the scan now that the duplicate has been removed
              return true;
            }

            // it may not be identical, but if it's not an object, I'm not sure we care too much.
            if (values(schemas).any((each) => this.isObjectOrEnum(each.value.instance))) {
              const rdiff = getDiff(schemas[1].value.instance, schemas[0].value.instance).filter(
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
                continue;
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
    };

    let count = 0;
    while (innerCheckForDuplicateSchemas()) {
      count++;
      // Loop until the scan is complete
    }
    this.session.verbose(`Found and removed ${count} duplicate schema`, {});

    return spec;
  }

  private removeDuplicateSchemas(
    spec: oai3.Model,
    name: string,
    schema1: DereferencedSchema,
    schema2: DereferencedSchema,
  ): oai3.Model {
    const { keep: schemaToKeep, remove: schemaToRemove } = this.findSchemaToRemove(spec, schema1, schema2);
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    delete spec.components!.schemas![schemaToRemove.key];
    const text = JSON.stringify(spec);
    const newSpec = JSON.parse(
      text.replace(
        new RegExp(`"\\#\\/components\\/schemas\\/${schemaToRemove.key}"`, "g"),
        `"#/components/schemas/${schemaToKeep.key}"`,
      ),
    );

    // update metadata to match
    const schema = newSpec?.components?.schemas?.[schemaToKeep.key];
    if (schema) {
      const primarySchema = dereference(spec, schema);
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

    this.session.verbose(
      `Schema ${name} has multiple identical declarations, reducing to just one - removing: ${schemaToRemove.key}, keeping: ${schemaToKeep.key}`,
      ["PreCheck", "ReducingSchema"],
    );

    return newSpec;
  }

  private findSchemaToRemove(
    spec: oai3.Model,
    schema1: DereferencedSchema,
    schema2: DereferencedSchema,
  ): { keep: DereferencedSchema; remove: DereferencedSchema } {
    const schema1Ref = spec.components?.schemas?.[schema1.key].$ref;
    // If schema1 is pointing to schema2 then we should delete schema1
    if (schema1Ref && schema1Ref === `#/components/schemas/${schema2.key}`) {
      return { remove: schema1, keep: schema2 };
    }
    return { remove: schema2, keep: schema1 };
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
