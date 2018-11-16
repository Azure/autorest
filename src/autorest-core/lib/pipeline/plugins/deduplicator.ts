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
export class DeduplicatorProcessor extends Processor<oai.Model, oai.Model> {

  process(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      switch (key) {
        case 'components':
          this.visitComponents(this.newObject(targetParent, key, pointer), children);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {

    for (const { key, value, pointer, childIterator } of nodes) {
      switch (key) {
        case 'schemas':
          this.visitComponent(key, this.newObject(components, key, pointer), childIterator);
          break;
        default:
          this.clone(components, key, pointer, value);
          break;
      }

    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: () => Iterable<Node>) {
    const deduplicatedSchemaKeys: Array<string> = [];
    for (const { key, value: currentSchema, pointer, children } of nodes()) {
      if (!deduplicatedSchemaKeys.includes(key)) {
        let apiVersions = currentSchema['x-ms-metadata'].apiVersions;
        let filename = currentSchema['x-ms-metadata'].filename;
        let originalLocations = currentSchema['x-ms-metadata'].originalLocations;
        const name = currentSchema['x-ms-metadata'].name;
        const { 'x-ms-metadata': metadataCurrent, ...filteredCurrentSchema } = currentSchema;
        for (const { key: k, value: schema } of nodes()) {
          const { 'x-ms-metadata': metadataSchema, ...filteredSchema } = schema;
          if (deepEqual(filteredSchema, filteredCurrentSchema) && schema['x-ms-metadata'].name === currentSchema['x-ms-metadata'].name) {
            deduplicatedSchemaKeys.push(k);
            apiVersions = apiVersions.concat(schema['x-ms-metadata'].apiVersions);
            filename = filename.concat(schema['x-ms-metadata'].filename);
            originalLocations = originalLocations.concat(schema['x-ms-metadata'].originalLocations);
          }
        }

        const component: AnyObject = this.newObject(container, key, pointer);

        component['x-ms-metadata'] = {
          value: {
            apiVersions: [...new Set([...apiVersions])],
            filename: [...new Set([...filename])],
            name,
            originalLocations: [...new Set([...originalLocations])]
          }, pointer
        };

        for (const child of children) {
          if (child.key !== 'x-ms-metadata') {
            this.clone(component, child.key, child.pointer, child.value);
          }
        }
      }
    }
  }
}

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new DeduplicatorProcessor(each);
    result.push(await sink.WriteObject(each.Description, processor.output, each.Identity, each.GetArtifact(), processor.sourceMappings));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}

export class Deduplicator {
  private refs = new Dictionary<string>();
  private target;
  public mappings = new Dictionary<string>();
  private schemasVisited = new Array<string>();
  private hasRun = false;
  private deduplicatedSchemas = Array<string>();
  private crawledSchemas = Array<string>();
  private visitedSchemas = Array<string>(); // to handle circular references
  constructor(originalFile: DataHandle) {
    this.target = originalFile.ReadObject();
  }

  init() {
    if (this.target.components.schemas !== undefined) {
      this.deduplicateSchemas();
    }
  }


  deduplicateSchemas() {
    for (const schema of visit(this.target.components.schemas)) {
      if (!this.deduplicatedSchemas.includes(schema.key)) {
        if (!this.crawledSchemas.includes(schema.key)) {
          // crawl the schema first.
          this.crawlSchema(schema.value, schema.key, schema.children);
        }
        // after crawled deduplicate.
        // update references
        // update mappings
        this.deduplicatedSchemas.push(schema.key);
      }
    }
  }

  crawlSchema(targetParent: AnyObject, uid: string, originalNodes: Iterable<Node>) {
    if (!this.visitedSchemas.includes(uid)) {
      this.visitedSchemas.push(uid);
      this.crawlObject(targetParent, originalNodes);
    }

    this.crawledSchemas.push(uid);
  }

  crawlObject(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, children } of originalNodes) {
      if (key === '$ref' && value.match(/#\/components\/schemas\/.+/g)) {
        const refParts = value.split('/');
        const schemaUid = refParts.pop();
        this.crawlSchema(this.target.components.schemas[schemaUid], schemaUid, visit(this.target.components.schemas[schemaUid]));
        // deduplicate schema.
        // update references.
      } else if (Array.isArray(key) || typeof (value) === 'object') {
        this.crawlObject(value, children);
      }
    }
  }


  private updateMappings(oldPointer: string, newPointer: string) {
    this.mappings[oldPointer] = newPointer;
    for (const [key, value] of Object.entries(this.mappings)) {
      if (value === oldPointer) {
        this.mappings[key] = newPointer;
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
