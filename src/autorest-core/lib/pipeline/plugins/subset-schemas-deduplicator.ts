import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, QuickDataSource, visit } from '@microsoft.azure/datastore';
import { clone, Dictionary } from '@microsoft.azure/linq';
import { areSimilar } from '@microsoft.azure/object-comparison';
import * as oai from '@microsoft.azure/openapi';
import * as compareVersions from 'compare-versions';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

export class SubsetSchemaDeduplicator extends Processor<any, oai.Model> {

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'components':
          const components = <oai.Components>targetParent.components || this.newObject(targetParent, 'components', pointer);
          this.visitComponents(components, children);
          break;

        // copy these over without worrying about moving things down to components.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, childIterator } of originalNodes) {
      switch (key) {
        case 'schemas':
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
    const xMsMetadata = 'x-ms-metadata';
    const updatedSchemas = {};

    // get all the schemas and associate them with their uid
    // this will allow us to place the value in the right place at the end
    const schemas: Array<AnyObject> = [];
    for (const { key, value } of originalNodes()) {
      if (value.type === 'object' || value.type === undefined) {
        // only do subset reduction on objects
        schemas.push({ value, uid: key });
      } else {
        updatedSchemas[key] = value;
      }
    }

    // sort by apiVersion from latest to oldest
    schemas.sort((a, b) => {
      const aMaxVersion = this.getMaxApiVersion(a.value[xMsMetadata].apiVersions);
      const bMaxVersion = this.getMaxApiVersion(b.value[xMsMetadata].apiVersions);
      return (aMaxVersion > bMaxVersion) ? -1 : (aMaxVersion < bMaxVersion) ? 1 : 0;
    });

    // deduplicate/reduce
    for (const { value: currentSchema } of visit(schemas)) {
      for (const { value: anotherSchema } of visit(schemas)) {
        const currentSchemaName = currentSchema.value[xMsMetadata].name;
        const anotherSchemaName = anotherSchema.value[xMsMetadata].name;
        if (currentSchemaName === anotherSchemaName && currentSchema.uid !== anotherSchema.uid) {
          const skipList = ['description', 'enum', 'readOnly', 'required'];
          const expandableFieldsList = ['properties', 'allOf'];

          // filter out metadata
          const { 'x-ms-metadata': metadataAnotherSchema, ...filteredAnotherSchema } = anotherSchema.value;
          const { 'x-ms-metadata': metadataCurrentSchema, ...filteredCurrentSchema } = currentSchema.value;

          const subsetRelation = getSubsetRelation(filteredAnotherSchema, filteredCurrentSchema, expandableFieldsList, skipList);
          if (subsetRelation.isSubset !== false) {
            const supersetEquivSchema = getSupersetSchema(filteredAnotherSchema, filteredCurrentSchema, expandableFieldsList, subsetRelation, `#/components/schemas/${anotherSchema.uid}`);
            const subsetEquivSchema = getSubsetSchema(filteredAnotherSchema, subsetRelation);

            // replace with equivalent schema and put back metadata.
            currentSchema.value = { 'x-ms-metadata': metadataCurrentSchema, ...supersetEquivSchema };
            anotherSchema.value = { 'x-ms-metadata': metadataAnotherSchema, ...subsetEquivSchema };
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

  private getMaxApiVersion(apiVersions: Array<string>): string {
    let result = '0';
    for (const version of apiVersions) {
      if (version && compareVersions(this.getSemverEquivalent(version), this.getSemverEquivalent(result)) >= 0) {
        result = version;
      }
    }

    return result;
  }

  // azure rest specs currently use versioning of the form yyyy-mm-dd
  // to take into consideration this we convert to an equivalent of
  // semver for comparisons.
  private getSemverEquivalent(version: string) {
    let result = '';
    for (const i of version.split('-')) {
      if (!result) {
        result = i;
        continue;
      }
      result = Number.isNaN(Number.parseInt(i)) ? `${result}-${i}` : `${result}.${i}`;
    }
    return result;
  }
}

export function getSubsetRelation(oldSchema: any, newSchema: any, expandableFieldsList: Array<string>, skipList: Array<string>): SubsetCheckResult {
  const result: SubsetCheckResult = { isSubset: true, nonExpandableFieldsUpdates: {}, expandableFieldsMatches: {} };
  const failResult = { isSubset: false, nonExpandableFieldsUpdates: {}, expandableFieldsMatches: {} };
  const skipSet = new Set(skipList);
  const expandableFieldsSet = new Set(expandableFieldsList);
  const oldSchemaFields = Object.keys(oldSchema);
  for (const fieldName of oldSchemaFields) {
    // if the newSchema does not contain a field from the oldSchema, it is not a subset
    if (newSchema[fieldName] === undefined) {
      return failResult;
    }

    // skip Fields have priority over expandable fields
    if (skipSet.has(fieldName) && !areSimilar(oldSchema[fieldName], newSchema[fieldName], ...skipList)) {
      if (Array.isArray(oldSchema[fieldName])) {
        if (!Array.isArray(newSchema[fieldName])) {
          return failResult;
        }

        result.nonExpandableFieldsUpdates[fieldName] = [];
        result.nonExpandableFieldsUpdates[fieldName].push(newSchema[fieldName]);
      } else {
        result.nonExpandableFieldsUpdates[fieldName] = {};
        result.nonExpandableFieldsUpdates[fieldName] = newSchema[fieldName];
      }
    } else if (expandableFieldsSet.has(fieldName)) {

      // array example use case of expandable field: required and allOf fields
      if (Array.isArray(oldSchema[fieldName])) {
        if (!Array.isArray(newSchema[fieldName])) {
          return failResult;
        }

        if (!result.expandableFieldsMatches[fieldName]) {
          result.expandableFieldsMatches[fieldName] = [];
        }

        let foundMatch = false;
        for (const oldValue of oldSchema[fieldName]) {
          foundMatch = false;
          for (const newValue of newSchema[fieldName]) {
            if (areSimilar(oldValue, newValue, ...skipList)) {
              result.expandableFieldsMatches[fieldName].push(newValue);
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

          if (!result.expandableFieldsMatches[fieldName]) {
            result.expandableFieldsMatches[fieldName] = {};
          }

          result.expandableFieldsMatches[fieldName][key] = newSchema[fieldName][key];
        }
      }
      // it can't be a subset if fields are different
    } else if (newSchema[fieldName] !== oldSchema[fieldName]) {
      return failResult;
    }
  }

  // Add fields from the newSchema in the skipList that were not present in the old schema.
  // For example, a description that the latest model has but the newest does not have.
  const newSchemaFields = Object.keys(newSchema);
  for (const fieldName of newSchemaFields) {
    if (oldSchema[fieldName] === undefined &&
      result.nonExpandableFieldsUpdates[fieldName] === undefined &&
      result.expandableFieldsMatches[fieldName] === undefined &&
      skipSet.has(fieldName)) {
      result.nonExpandableFieldsUpdates[fieldName] = newSchema[fieldName];
    }
  }

  return result;
}

export function getSupersetSchema(subset: any, superset: any, expandableFieldsList: Array<string>, subsetCheckResult: SubsetCheckResult, supersetReference: string): AnyObject {
  const result: any = {};
  const supersetKeys = new Set(Object.keys(superset));
  const subsetKeys = new Set(Object.keys(subset));
  const nonExpandableFieldsUpdates = subsetCheckResult.nonExpandableFieldsUpdates;
  const expandableFieldsMatches = subsetCheckResult.expandableFieldsMatches;
  for (const key of subsetKeys) {
    if (Object.keys(nonExpandableFieldsUpdates).includes(key)) {
      result[key] = nonExpandableFieldsUpdates[key];
    }
  }

  // add keep only the values that are unique to the superset
  for (const field of supersetKeys) {
    if (expandableFieldsList.includes(field)) {
      for (const key of Object.keys(superset[field])) {
        if (!Object.keys(expandableFieldsMatches[field]).includes(key)) {
          if (result[field] === undefined) {
            result[field] = (Array.isArray(superset[field])) ? [] : {};
          }
          result[field][key] = superset[field][key];
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
  const nonExpandableFieldsUpdates = subsetCheckResult.nonExpandableFieldsUpdates;
  const expandableFieldsMatches = subsetCheckResult.expandableFieldsMatches;
  for (const key of subsetKeys) {
    if (!Object.keys(nonExpandableFieldsUpdates).includes(key) && !Object.keys(expandableFieldsMatches).includes(key)) {
      result[key] = subset[key];
    }
  }

  for (const key of Object.keys(nonExpandableFieldsUpdates)) {
    result[key] = nonExpandableFieldsUpdates[key];
  }

  for (const field of Object.keys(expandableFieldsMatches)) {
    result[field] = expandableFieldsMatches[field];
  }

  return result;
}

export interface SubsetCheckResult {
  isSubset: boolean;
  nonExpandableFieldsUpdates: {
    [field: string]: any;
  };
  expandableFieldsMatches: {
    [field: string]: any;
  };
}

async function deduplicateSubsetSchemas(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new SubsetSchemaDeduplicator(each);
    result.push(await sink.WriteObject('oai3-subset-schema-reduced doc...', await processor.getOutput(), each.identity, 'oi3-subset-schema-reduced', await processor.getSourceMappings()));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function subsetSchemaDeduplicatorPlugin(): PipelinePlugin {
  return deduplicateSubsetSchemas;
}
