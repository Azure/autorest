/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AnyObject, Data, DataHandle, DataSink, DataSource, Mapping, Node, Processor, ProxyObject, QuickDataSource, visit, } from '@microsoft.azure/datastore';
import { Dictionary, items, values } from '@microsoft.azure/linq';
import { areSimilar } from '@microsoft.azure/object-comparison';
import * as deepEqual from 'deep-equal';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    // const processor = new DeduplicatorProcessor(each);
    // result.push(await sink.WriteObject(each.Description, processor.output, each.Identity, each.GetArtifact(), processor.sourceMappings));
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

  // Set containing uids of deduplicated schemas
  private deduplicatedSchemas = new Set<string>();

  // array containing uids of schemas already crawled
  private crawledSchemas = new Set<string>();

  // array containing uids of schemas already visited, but not necessarily crawled.
  // this prevents circular reference locks
  private visitedSchemas = new Set<string>();

  // initially the target is the same as the original object
  private target;
  constructor(originalFile: DataHandle) {
    this.target = originalFile.ReadObject();
  }

  init() {
    if (this.target.components.schemas !== undefined) {
      // construct initial table of schemaRefs
      for (const child of visit(this.target.components.schemas)) {
        this.schemaRefs[`#/components/schemas/${child.key}`] = `#/components/schemas/${child.key}`;
      }

      this.deduplicateSchemas();
    }
  }

  private deduplicateSchemas() {
    for (const { key: schemaUid } of visit(this.target.components.schemas)) {
      if (!this.deduplicatedSchemas.has(schemaUid)) {
        if (!this.crawledSchemas.has(schemaUid)) {
          this.crawlSchema(schemaUid);
        }
        this.deduplicateSchema(schemaUid);
      }
    }
  }

  private crawlSchema(uid: string) {
    if (!this.visitedSchemas.has(uid)) {
      // use a set instead of array for all visited stuff
      this.visitedSchemas.add(uid);
      this.crawlObject(this.target.components.schemas[uid]);
    }

    this.crawledSchemas.add(uid);
  }

  private crawlObject(obj: AnyObject) {
    for (const { key, value } of visit(obj)) {
      if (key === '$ref' && value.match(/#\/components\/schemas\/.+/g)) {
        const refParts = value.split('/');
        const schemaUid = refParts.pop();
        if (!this.deduplicatedSchemas.has(schemaUid)) {
          if (!this.crawledSchemas.has(schemaUid)) {
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
        if (areSimilar(filteredSchema, filteredReferencedSchema) && schema['x-ms-metadata'].name === currentSchema['x-ms-metadata'].name) {
          apiVersions = apiVersions.concat(schema['x-ms-metadata'].apiVersions);
          filename = filename.concat(schema['x-ms-metadata'].filename);
          originalLocations = originalLocations.concat(schema['x-ms-metadata'].originalLocations);
          delete this.target.components.schemas[key];
          this.schemaRefs[`#/components/schemas/${key}`] = `#/components/schemas/${uid}`;
          this.updateRefs(this.target);
          this.updateMappings(`/components/schemas/${key}`, `/components/schemas/${uid}`);
          this.deduplicatedSchemas.add(key);
        }
      }
    }

    currentSchema['x-ms-metadata'] = {
      apiVersions: [...new Set([...apiVersions])],
      filename: [...new Set([...filename])],
      name,
      originalLocations: [...new Set([...originalLocations])]
    };
    this.deduplicatedSchemas.add(uid);
  }

  private updateMappings(oldPointer: string, newPointer: string) {
    this.mappings[oldPointer] = newPointer;
    for (const [key, value] of Object.entries(this.mappings)) {
      if (value === oldPointer) {
        this.mappings[key] = newPointer;
      }
    }
  }

  private updateRefs(node: any) {
    for (const { key, value } of visit(node)) {
      if (typeof value === 'object') {
        const ref = value.$ref;
        if (ref && ref.match(/#\/components\/schemas\/.+/g)) {
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
