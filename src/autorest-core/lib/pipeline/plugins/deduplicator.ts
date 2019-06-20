/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from '@microsoft.azure/datastore';
import { Deduplicator } from '@microsoft.azure/deduplication';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { Dictionary, values, keys, items } from '@microsoft.azure/linq';

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of values(inputs).linq.where(input => input.artifactType !== 'profile-filter-log')) {
    const deduplicator = new Deduplicator(await each.ReadObject());

    result.push(await sink.WriteObject('model-deduplicated-oai3-doc', deduplicator.output, each.identity, 'deduplicated-oai3', [/* fix-me: Construct source map from the mappings returned by the deduplicator.s*/]));
  }

  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}
