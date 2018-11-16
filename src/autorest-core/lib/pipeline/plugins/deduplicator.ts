/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, QuickDataSource, Data, visit, Mapping, } from '@microsoft.azure/datastore';
import * as oai from '@microsoft.azure/openapi';
import * as deepEqual from "deep-equal";
import { Dictionary, values, items } from '@microsoft.azure/linq';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { type } from 'os';
// export class DeduplicatorProcessor extends Processor<oai.Model, oai.Model> {

//   process(targetParent: AnyObject, nodes: Iterable<Node>) {
//     for (const { key, value, pointer, children } of nodes) {
//       switch (key) {
//         case 'components':
//           this.visitComponents(this.newObject(targetParent, key, pointer), children);
//           break;
//         default:
//           this.clone(targetParent, key, pointer, value);
//           break;
//       }
//     }
//   }

//   visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {

//     for (const { key, value, pointer, childIterator } of nodes) {
//       switch (key) {
//         case 'schemas':
//           this.visitComponent(key, this.newObject(components, key, pointer), childIterator);
//           break;
//         default:
//           this.clone(components, key, pointer, value);
//           break;
//       }

//     }
//   }

//   visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: () => Iterable<Node>) {
//     const deduplicatedSchemaKeys: Array<string> = [];
//     for (const { key, value: currentSchema, pointer, children } of nodes()) {
//       if (!deduplicatedSchemaKeys.includes(key)) {
//         let apiVersions = currentSchema['x-ms-metadata'].apiVersions;
//         let filename = currentSchema['x-ms-metadata'].filename;
//         let originalLocations = currentSchema['x-ms-metadata'].originalLocations;
//         const name = currentSchema['x-ms-metadata'].name;
//         const { 'x-ms-metadata': metadataCurrent, ...filteredCurrentSchema } = currentSchema;
//         for (const { key: k, value: schema } of nodes()) {
//           const { 'x-ms-metadata': metadataSchema, ...filteredSchema } = schema;
//           if (deepEqual(filteredSchema, filteredCurrentSchema) && schema['x-ms-metadata'].name === currentSchema['x-ms-metadata'].name) {
//             deduplicatedSchemaKeys.push(k);
//             apiVersions = apiVersions.concat(schema['x-ms-metadata'].apiVersions);
//             filename = filename.concat(schema['x-ms-metadata'].filename);
//             originalLocations = originalLocations.concat(schema['x-ms-metadata'].originalLocations);
//           }
//         }

//         const component: AnyObject = this.newObject(container, key, pointer);

//         component['x-ms-metadata'] = {
//           value: {
//             apiVersions: [...new Set([...apiVersions])],
//             filename: [...new Set([...filename])],
//             name,
//             originalLocations: [...new Set([...originalLocations])]
//           }, pointer
//         };

//         for (const child of children) {
//           if (child.key !== 'x-ms-metadata') {
//             this.clone(component, child.key, child.pointer, child.value);
//           }
//         }
//       }
//     }
//   }
// }

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    // const processor = new DeduplicatorProcessor(each);
    // result.push(await sink.WriteObject(each.Description, processor.output, each.identity, each.artifactType, processor.sourceMappings));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}

export class Deduplicator {
  private hasRun = false;

  // table:
  // prevPointers -> newPointers
  public mappings = new Dictionary<string>();

  // table:
  // oldRefs -> newRef
  private schemaRefs = new Dictionary<string>();

  // array containing uids of deduplicated schemas
  private deduplicatedSchemas = Array<string>();

  // array containing uids of schemas already crawled
  private crawledSchemas = Array<string>();

  // array containing uids of schemas already visited, but not necessarily crawled.
  // this prevents circular reference locks
  private visitedSchemas = Array<string>();

  // initially the target is the same as the original object
  private target;
  constructor(originalFile: DataHandle) {
    this.target = originalFile.ReadObject();
  }

  init() {
    if (this.target.components.schemas !== undefined) {
      // construct initial table of refs
      for (const child of visit(this.target.components.schemas)) {
        this.schemaRefs[`#/components/schemas/${child.key}`] = `#/components/schemas/${child.key}`;
      }

      this.deduplicateSchemas();
    }
  }

  private deduplicateSchemas() {
    for (const { key: schemaUid } of visit(this.target.components.schemas)) {
      if (!this.deduplicatedSchemas.includes(schemaUid)) {
        if (!this.crawledSchemas.includes(schemaUid)) {
          this.crawlSchema(schemaUid);
        }
        this.deduplicateSchema(schemaUid);
      }
    }
  }

  private crawlSchema(uid: string) {
    if (!this.visitedSchemas.includes(uid)) {
      this.visitedSchemas.push(uid);
      this.crawlObject(this.target.components.schemas[uid]);
    }

    this.crawledSchemas.push(uid);
  }

  private crawlObject(obj: AnyObject) {
    for (const { key, value } of visit(obj)) {
      if (key === '$ref' && value.match(/#\/components\/schemas\/.+/g)) {
        const refParts = value.split('/');
        const schemaUid = refParts.pop();
        if (!this.deduplicatedSchemas.includes(schemaUid)) {
          if (!this.crawledSchemas.includes(schemaUid)) {
            this.crawlSchema(schemaUid);
          }
          this.deduplicateSchema(schemaUid);
        }
      } else if (Array.isArray(key) || typeof (value) === 'object') {
        this.crawlObject(value);
      }
    }
  }

  private deduplicateSchema(uid: string) {
    const currentSchema = this.target.components.schemas[uid];
    let apiVersions = currentSchema['x-ms-metadata'].apiVersions;
    let filename = currentSchema['x-ms-metadata'].filename;
    let originalLocations = currentSchema['x-ms-metadata'].originalLocations;
    const name = currentSchema['x-ms-metadata'].name;
    const { 'x-ms-metadata': metadataCurrent, ...filteredReferencedSchema } = currentSchema;
    for (const { key, value: schema } of visit(this.target.components.schemas)) {
      if (uid !== key) {
        const { 'x-ms-metadata': metadataSchema, ...filteredSchema } = schema;
        if (deepEqual(filteredSchema, filteredReferencedSchema) && schema['x-ms-metadata'].name === currentSchema['x-ms-metadata'].name) {
          apiVersions = apiVersions.concat(schema['x-ms-metadata'].apiVersions);
          filename = filename.concat(schema['x-ms-metadata'].filename);
          originalLocations = originalLocations.concat(schema['x-ms-metadata'].originalLocations);
          delete this.target.components.schemas[key];
          this.schemaRefs[`#/components/schemas/${key}`] = `#/components/schemas/${uid}`;
          this.updateRefs(this.target);
          this.updateMappings(`/components/schemas/${key}`, `/components/schemas/${uid}`);
          this.deduplicatedSchemas.push(key);
        }
      }
    }

    currentSchema['x-ms-metadata'] = {
      apiVersions: [...new Set([...apiVersions])],
      filename: [...new Set([...filename])],
      name,
      originalLocations: [...new Set([...originalLocations])]
    };
    this.deduplicatedSchemas.push(uid);
  }

  private updateMappings(oldPointer: string, newPointer: string) {
    this.mappings[oldPointer] = newPointer;
    for (const [key, value] of Object.entries(this.mappings)) {
      if (value === oldPointer) {
        this.mappings[key] = newPointer;
      }
    }
  }

  // TODO: change this to handle just schema refs.
  private updateRefs(node: any) {
    for (const { key, value } of visit(node)) {
      if (typeof value === 'object') {
        const ref = value.$ref;
        if (ref) {
          // see if this object has a $ref
          const newRef = this.schemaRefs[ref];
          if (newRef) {
            value.$ref = newRef;
          } else {
            throw new Error(`$ref to original location '${ref}' is not found in the new refs collection`);
          }
        }
        // now, recurse into this object
        this.updateRefs(value);
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
