/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, Node, Processor, QuickDataSource, } from '@microsoft.azure/datastore';

import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

export class Deduplicator extends Processor<oai.Model, oai.Model> {

  process(targetParent: any, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:

  }
}

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
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
