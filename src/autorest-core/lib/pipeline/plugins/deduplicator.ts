/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from '@microsoft.azure/datastore';
import { Deduplicator } from '@microsoft.azure/deduplication';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const deduplicator = new Deduplicator(each.ReadObject());

    // TODO: Construct source map from the mappings returned by the deduplicator.
    result.push(await sink.WriteObject(each.Description, deduplicator.output, each.identity, each.artifactType, [/*fix-me*/]));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}
