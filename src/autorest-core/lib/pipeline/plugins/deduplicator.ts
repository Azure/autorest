/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, QuickDataSource, Data, visit, Mapping, } from '@microsoft.azure/datastore';
import * as deepEqual from "deep-equal";
import { Dictionary, values, items } from '../../../../../perks/libraries/linq/dist/main';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
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

  private original;
  private refs = new Dictionary<string>();
  public deduplicated;
  public mappings = new Dictionary<string>();
  private schemasVisited = new Array<string>();
  constructor(originalFile: DataHandle) {
    this.original = originalFile.ReadObject();
  }

  public deduplicate() {
    for (const { key, value, pointer } of visit(this.original)) {
      this.copy(this.original, key, pointer, value);
    }
  }

  private copy(target: any, member: string, pointer: string, value: any) {
    for (const { key, value: v } of visit(target[member])) {
      this.copy(target[member], key, v.pointer, v);
    }
    target[member] = value;
    this.updateMappings(pointer, value.pointer);
  }

  private updateMappings(oldPointer: string, newPointer: string) {
    this.mappings[oldPointer] = newPointer;
    for (const [key, value] of Object.entries(this.mappings)) {
      if (value === oldPointer) {
        this.mappings[key] = newPointer;
      }
    }
  }
}
