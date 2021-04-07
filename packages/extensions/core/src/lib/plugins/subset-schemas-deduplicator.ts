import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  Transformer,
  ProxyObject,
  QuickDataSource,
  visit,
} from "@azure-tools/datastore";
import { clone, Dictionary, values } from "@azure-tools/linq";
import { areSimilar } from "@azure-tools/object-comparison";
import * as oai from "@azure-tools/openapi";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";
import { toSemver, maximum, gt, lt } from "@azure-tools/codegen";
import { Channel } from "../message";

/* eslint-disable @typescript-eslint/no-use-before-define */

export class SubsetSchemaDeduplicator extends Transformer<any, oai.Model> {
  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "components":
          {
            const components =
              <oai.Components>targetParent.components || this.newObject(targetParent, "components", pointer);
            this.visitComponents(components, children);
          }
          break;

        // copy these over without worrying about moving things down to components.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
    // mark this schemaReduced.
    this.generated.info["x-ms-metadata"].schemaReduced = true;
  }

  visitComponents(components: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, childIterator } of originalNodes) {
      switch (key) {
        case "schemas":
          if (components[key] === undefined) {
            this.newObject(components, key, pointer);
          }
          this.visitSchemas(components[key], childIterator);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(components, key, pointer, value);
          break;
      }
    }
  }

  visitSchemas<T>(container: ProxyObject<Dictionary<T>>, originalNodes: () => Iterable<Node>) {
    const xMsMetadata = "x-ms-metadata";
    const updatedSchemas: any = {};

    // get all the schemas and associate them with their uid
    // this will allow us to place the value in the right place at the end
    const schemas: Array<AnyObject> = [];
    for (const { key, value } of originalNodes()) {
      if (value.type === "object" || value.type === undefined) {
        // only do subset reduction on objects
        schemas.push({ value, uid: key });
      } else {
        updatedSchemas[key] = value;
      }
    }

    // sort by apiVersion from latest to oldest
    schemas.sort((a, b) => {
      const aMaxVersion = maximum(a.value[xMsMetadata].apiVersions);
      const bMaxVersion = maximum(b.value[xMsMetadata].apiVersions);
      return gt(aMaxVersion, bMaxVersion) ? -1 : lt(aMaxVersion, bMaxVersion) ? 1 : 0;
    });

    // deduplicate/reduce
    for (const { value: currentSchema } of visit(schemas)) {
      for (const { value: anotherSchema } of visit(schemas)) {
        const currentSchemaName = currentSchema.value[xMsMetadata].name;
        const anotherSchemaName = anotherSchema.value[xMsMetadata].name;
        if (currentSchemaName === anotherSchemaName && currentSchema.uid !== anotherSchema.uid) {
          const skipList = ["description", "enum", "readOnly", "required", "x-ms-original", "x-ms-examples"];
          const additiveFieldsList = ["properties", "allOf", "required"];

          // filter out metadata
          const { "x-ms-metadata": metadataAnotherSchema, ...filteredAnotherSchema } = anotherSchema.value;
          const { "x-ms-metadata": metadataCurrentSchema, ...filteredCurrentSchema } = currentSchema.value;

          const subsetRelation = getSubsetRelation(
            filteredAnotherSchema,
            filteredCurrentSchema,
            additiveFieldsList,
            skipList,
          );
          if (subsetRelation.isSubset !== false) {
            const supersetEquivSchema = getSupersetSchema(
              filteredAnotherSchema,
              filteredCurrentSchema,
              additiveFieldsList,
              subsetRelation,
              `#/components/schemas/${anotherSchema.uid}`,
            );
            const subsetEquivSchema = getSubsetSchema(filteredAnotherSchema, subsetRelation);

            // gs: added -- ensure that properties left beg
            if (currentSchema.value.required && supersetEquivSchema.properties) {
              const sesNames = Object.getOwnPropertyNames(supersetEquivSchema.properties);
              supersetEquivSchema.required = currentSchema.value.required.filter(
                (each: any) => sesNames.indexOf(each) > -1,
              );
            }

            // replace with equivalent schema and put back metadata.
            currentSchema.value = { "x-ms-metadata": metadataCurrentSchema, ...supersetEquivSchema };
            anotherSchema.value = { "x-ms-metadata": metadataAnotherSchema, ...subsetEquivSchema };
          }
        }
      }
    }

    // get back updated schemas

    for (const schema of schemas) {
      updatedSchemas[schema.uid] = schema.value;
    }

    // finish up
    for (const { key, pointer } of originalNodes()) {
      container[key] = { value: updatedSchemas[key], pointer, recurse: true };
    }
  }
}

export function getSubsetRelation(
  oldSchema: any,
  newSchema: any,
  additiveFieldsList: Array<string>,
  skipList: Array<string>,
): SubsetCheckResult {
  const result: SubsetCheckResult = { isSubset: true, nonAdditiveFieldsUpdates: {}, additiveFieldsMatches: {} };
  const failResult = { isSubset: false, nonAdditiveFieldsUpdates: {}, additiveFieldsMatches: {} };
  const skipSet = new Set(skipList);
  const additiveFieldsSet = new Set(additiveFieldsList);
  const oldSchemaFields = Object.keys(oldSchema);
  for (const fieldName of oldSchemaFields) {
    // if the newSchema does not contain a field from the oldSchema, it is not a subset
    if (newSchema[fieldName] === undefined) {
      return failResult;
    }

    // skip Fields have priority over additive fields
    if (skipSet.has(fieldName) && !areSimilar(oldSchema[fieldName], newSchema[fieldName], ...skipList)) {
      if (Array.isArray(oldSchema[fieldName])) {
        if (!Array.isArray(newSchema[fieldName])) {
          return failResult;
        }

        result.nonAdditiveFieldsUpdates[fieldName] = [];
        result.nonAdditiveFieldsUpdates[fieldName].push(newSchema[fieldName]);
      } else {
        result.nonAdditiveFieldsUpdates[fieldName] = {};
        result.nonAdditiveFieldsUpdates[fieldName] = newSchema[fieldName];
      }
    } else if (additiveFieldsSet.has(fieldName)) {
      // array example use case of additive field: required and allOf fields
      if (Array.isArray(oldSchema[fieldName])) {
        if (!Array.isArray(newSchema[fieldName])) {
          return failResult;
        }

        if (!result.additiveFieldsMatches[fieldName]) {
          result.additiveFieldsMatches[fieldName] = [];
        }

        let foundMatch = false;
        for (const oldValue of oldSchema[fieldName]) {
          foundMatch = false;
          for (const newValue of newSchema[fieldName]) {
            if (areSimilar(oldValue, newValue, ...skipList)) {
              result.additiveFieldsMatches[fieldName].push(newValue);
              foundMatch = true;
              break;
            }
          }
        }

        // one of the oldValues was not found in the new array.
        if (!foundMatch) {
          return failResult;
        }
      } else {
        const oldFieldKeys = Object.keys(oldSchema[fieldName]);

        for (const key of oldFieldKeys) {
          if (!newSchema[fieldName][key]) {
            return failResult;
          }

          if (!areSimilar(newSchema[fieldName][key], oldSchema[fieldName][key], ...skipList)) {
            return failResult;
          }

          if (!result.additiveFieldsMatches[fieldName]) {
            result.additiveFieldsMatches[fieldName] = {};
          }

          result.additiveFieldsMatches[fieldName][key] = newSchema[fieldName][key];
        }
      }
      // it can't be a subset if fields are different
    } else if (newSchema[fieldName] !== oldSchema[fieldName]) {
      return failResult;
    }
  }

  const newSchemaFields = Object.keys(newSchema);
  for (const fieldName of newSchemaFields) {
    // Add fields from the newSchema in the skipList that were not present in the old schema.
    // For example, a description that the latest model has but the newest does not have.
    if (
      oldSchema[fieldName] === undefined &&
      result.nonAdditiveFieldsUpdates[fieldName] === undefined &&
      result.additiveFieldsMatches[fieldName] === undefined &&
      skipSet.has(fieldName)
    ) {
      result.nonAdditiveFieldsUpdates[fieldName] = newSchema[fieldName];
    }

    // for additive fields not in the oldmodel, we should treat them as empty objects/arrays.
    // Example: if the newer schema has an allOf and the old doesn't we should still treat as a match.
    // It's equivalent to saying that the old one has also an allOf, but it's an empty array.
    if (
      oldSchema[fieldName] === undefined &&
      result.additiveFieldsMatches[fieldName] === undefined &&
      !skipSet.has(fieldName)
    ) {
      result.additiveFieldsMatches[fieldName] = newSchema[fieldName];
    }
  }

  return result;
}

export function getSupersetSchema(
  subset: any,
  superset: any,
  additiveFieldsList: Array<string>,
  subsetCheckResult: SubsetCheckResult,
  supersetReference: string,
): AnyObject {
  const result: any = {};
  const supersetKeys = new Set(Object.keys(superset));
  const subsetKeys = new Set(Object.keys(subset));
  const nonAdditiveFieldsUpdates = subsetCheckResult.nonAdditiveFieldsUpdates;
  const additiveFieldsMatches = subsetCheckResult.additiveFieldsMatches;
  for (const key of subsetKeys) {
    if (Object.keys(nonAdditiveFieldsUpdates).includes(key)) {
      result[key] = nonAdditiveFieldsUpdates[key];
    }
  }

  // keep only the values that are unique to the superset
  for (const field of supersetKeys) {
    if (additiveFieldsList.includes(field)) {
      for (const [key, value] of Object.entries(superset[field])) {
        // in the case of additive array fields like allOf we need to check to see if the things
        // inside are contained, not if the property names are.
        if (Array.isArray(additiveFieldsMatches[field])) {
          const arrayContainsSimilarObject = (arr: Array<any>, obj: any) => {
            for (const element of arr) {
              if (areSimilar(element, obj)) {
                return true;
              }
            }

            return false;
          };

          if (!arrayContainsSimilarObject(additiveFieldsMatches[field], value)) {
            if (result[field] === undefined) {
              result[field] = [];
            }
            result[field][key] = superset[field][key];
          }
        } else {
          if (!(additiveFieldsMatches[field] && Object.keys(additiveFieldsMatches[field]).includes(key))) {
            if (result[field] === undefined) {
              result[field] = {};
            }
            result[field][key] = superset[field][key];
          }
        }
      }
    }
  }

  // add allOf reference to the subset schema
  if (result.allOf === undefined) {
    result.allOf = [];
  }

  result.allOf.push({ $ref: supersetReference });

  return result;
}

export function getSubsetSchema(subset: any, subsetCheckResult: SubsetCheckResult): AnyObject {
  const result: any = {};
  const subsetKeys = new Set(Object.keys(subset));
  const nonAdditiveFieldsUpdates = subsetCheckResult.nonAdditiveFieldsUpdates;
  const additiveFieldsMatches = subsetCheckResult.additiveFieldsMatches;
  for (const key of subsetKeys) {
    if (!Object.keys(nonAdditiveFieldsUpdates).includes(key) && !Object.keys(additiveFieldsMatches).includes(key)) {
      result[key] = subset[key];
    }
  }

  for (const key of Object.keys(nonAdditiveFieldsUpdates)) {
    result[key] = nonAdditiveFieldsUpdates[key];
  }

  for (const field of Object.keys(additiveFieldsMatches)) {
    result[field] = additiveFieldsMatches[field];
  }

  return result;
}

export interface SubsetCheckResult {
  isSubset: boolean;
  nonAdditiveFieldsUpdates: {
    [field: string]: any;
  };
  additiveFieldsMatches: {
    [field: string]: any;
  };
}

async function deduplicateSubsetSchemas(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const model = <any>await each.ReadObject();
    /*
    Disabling for now -- not sure if we need to skip this in the simple case anyway.

    if ([...values(model?.info?.['x-ms-metadata']?.apiVersions).distinct()].length < 2) {
      // if there is a single API version in the doc, let's not bother.
      config.Message({ Channel: Channel.Verbose, Text: `Skipping subset deduplication on single-api-version file ${each.identity}` });
      result.push(await sink.WriteObject('oai3.subset-schema-reduced.json', model, each.identity, 'openapi-document-schema-reduced', []));
      continue;
    }
    config.Message({ Channel: Channel.Verbose, Text: `Processing subset deduplication on file ${each.identity}` });
    */
    if (model.info?.["x-ms-metadata"]?.schemaReduced) {
      result.push(
        await sink.WriteObject(
          "oai3.subset-schema-reduced.json",
          model,
          each.identity,
          "openapi-document-schema-reduced",
          [],
        ),
      );
      continue;
    }
    const processor = new SubsetSchemaDeduplicator(each);
    result.push(
      await sink.WriteObject(
        "oai3.subset-schema-reduced.json",
        await processor.getOutput(),
        each.identity,
        "openapi-document-schema-reduced",
        await processor.getSourceMappings(),
      ),
    );
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function subsetSchemaDeduplicatorPlugin(): PipelinePlugin {
  return deduplicateSubsetSchemas;
}
