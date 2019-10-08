/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink, DataSource, QuickDataSource } from '@azure-tools/datastore';
import { Deduplicator } from '@azure-tools/deduplication';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { Dictionary, values, keys, items } from '@azure-tools/linq';

async function deduplicate(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of values(inputs).where(input => input.artifactType !== 'profile-filter-log')) {
    const deduplicator = new Deduplicator(await each.ReadObject());

    result.push(await sink.WriteObject('oai3.model-deduplicated.json', await deduplicator.getOutput(), each.identity, 'openapi-document-deduplicated', [/* fix-me: Construct source map from the mappings returned by the deduplicator.s*/]));
  }

  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createDeduplicatorPlugin(): PipelinePlugin {
  return deduplicate;
}
