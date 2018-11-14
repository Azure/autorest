/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, QuickDataSource, ProxyObject, } from '@microsoft.azure/datastore';

import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { Dictionary } from '../../../../../perks/libraries/linq/dist/main';

export class Deduplicator extends Processor<oai.Model, oai.Model> {

  uniqueSchemas = new Array<any>();

  process(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      switch (key) {
        case 'components':
          this.visitComponents(this.newObject(targetParent, key, pointer), children);
          break;
        default:
          this.copy(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {
    let index = 0;
    for (const { key, value, pointer, children } of nodes) {
      if (this.uniqueSchemas.indexOf(value) !== -1) {
        this.uniqueSchemas.push(value);
        this.copy(components, index, pointer, value);
        index++;
      }
    }
  }
}

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new Deduplicator(each);
    result.push(await sink.WriteObject(each.Description, processor.output, each.Identity, each.GetArtifact(), processor.sourceMappings));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}
