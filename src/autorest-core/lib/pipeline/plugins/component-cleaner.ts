/*--------------------------------------------------------------------------------------------
* Copyright(c) Microsoft Corporation.All rights reserved.
* Licensed under the MIT License.See License.txt in the project root for license information.
* --------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource, visit } from '@microsoft.azure/datastore';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

/**
 * components-to-keep are the ones that:
 *
 * 1 Come from a primary-file.
 * 2 Come from a secondary-file and are referenced by a primary-file component.
 * 3 Come from a secondary-file and are referenced by something in a primary file (e.g paths, security, etc).
 * 4 Come from a secondary-file and have one or more 'anyOf', 'allOf', 'oneOf', 'not' relations with a primary-file schema.
 * 5 Come from a secondary-file and have one or more 'anyOf', 'allOf', 'oneOf', 'not' relations with a file from case (4).
 *
 */

export class ComponentCleaner {
  private hasRun = false;

  // TODO: source mapping logic

  // sets containing the UIDs of already deduplicated components
  private componentsToKeep = {
    schemas: new Set<string>(),
    responses: new Set<string>(),
    parameters: new Set<string>(),
    examples: new Set<string>(),
    requestBodies: new Set<string>(),
    headers: new Set<string>(),
    securitySchemes: new Set<string>(),
    links: new Set<string>(),
    callbacks: new Set<string>()
  };

  // Initially the target is the same as the original object.
  private target: any;
  constructor(originalFile: any) {
    this.target = originalFile;
  }
  private init() {
    if (this.target.components) {
      for (const { key: fieldName } of visit(this.target)) {

        // Bring all the components that come from a primary file, and secondary-file components referenced by them.
        if (fieldName === 'components') {
          for (const { children, key: type } of visit(this.target[fieldName])) {
            for (const { value, key: componentUid } of children) {
              if (!value['x-ms-metadata']['x-ms-secondary-file'] && !this.componentsToKeep[type].has(componentUid)) {
                this.componentsToKeep[type].add(componentUid);
                this.crawlObject(value);
              }
            }
          }
        } else {
          for (const { value } of visit(this.target[fieldName])) {
            this.crawlObject(value);
          }
        }
      }

      // Secondary-file schemas which have an allOf, anyOf, oneOf or 'not' relationship with the schemas included in the files to keep.
      const schemas = this.target.components.schemas;
      if (schemas) {
        this.visitSecondaryFileSchemas();
      }

      //  Finally, Delete all the components that are not included in the list of components-to-keep.
      for (const { children, key: type } of visit(this.target.components)) {
        for (const { key: componentUid } of children) {
          if (!this.componentsToKeep[type].has(componentUid)) {
            delete this.target.components[type][componentUid];
          }
        }
      }
    }
  }

  visitSecondaryFileSchemas() {
    const schemas = this.target.components.schemas;
    for (const { key: uid } of visit(schemas)) {
      if (schemas[uid]['x-ms-metadata']['x-ms-secondary-file'] && !this.componentsToKeep.schemas.has(uid)) {
        const schema = schemas[uid];
        const keysOfInterest = ['allOf', 'anyOf', 'oneOf', 'not'];
        for (const key of keysOfInterest) {
          const container = schema[key];
          if (container) {
            let matchFound = false;
            if (!Array.isArray(container)) {
              const ref = container.$ref;
              if (ref) {
                const refParts = ref.split('/');
                const componentUid = refParts.pop();
                const componentType = refParts.pop();
                matchFound = this.componentsToKeep[componentType].has(componentUid);
              }
            } else {
              matchFound = container.some((element) => {
                const ref = element.$ref;
                if (ref) {
                  const refParts = ref.split('/');
                  const componentUid = refParts.pop();
                  const componentType = refParts.pop();
                  return this.componentsToKeep[componentType].has(componentUid);
                }
                return false;
              });
            }

            if (matchFound && !this.componentsToKeep.schemas.has(uid)) {
              this.componentsToKeep.schemas.add(uid);
              this.crawlObject(schemas[uid]);

              // restart search because there could be an 'allOf', 'anyOf', 'oneOf', 'not' relation
              // to this schema by another schema already checked.
              this.visitSecondaryFileSchemas();
            }
          }
        }
      }
    }
  }

  crawlObject(obj: any) {
    for (const { key, value } of visit(obj)) {
      if (key === '$ref') {
        const refParts = value.split('/');
        const componentUid = refParts.pop();
        const type = refParts.pop();
        if (!this.componentsToKeep[type].has(componentUid)) {
          this.componentsToKeep[type].add(componentUid);
          this.crawlObject(this.target.components[type][componentUid]);
        }
      } else if (value && typeof (value) === 'object') {
        this.crawlObject(value);
      }
    }
  }

  public get output() {
    if (!this.hasRun) {
      this.init();
      this.hasRun = true;
    }
    return this.target;
  }
}

async function cleanComponents(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const cleaner = new ComponentCleaner(each.ReadObject());

    // TODO: Construct source map from the mappings returned by the deduplicator.
    result.push(await sink.WriteObject(each.Description, cleaner.output, each.identity, each.artifactType, [/*fix-me*/]));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createComponentCleanerPlugin(): PipelinePlugin {
  return cleanComponents;
}
