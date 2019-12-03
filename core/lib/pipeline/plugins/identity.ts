import { PipelinePlugin } from '../common';
import { ConfigurationView } from '../../configuration';
import { DataSource, DataSink, DataHandle, QuickDataSource } from '@azure-tools/datastore';

/*@internal */
export function createIdentityPlugin(): PipelinePlugin {
  return async (config, input) => input;
}

async function resetIdentity(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    result.push(await sink.WriteObject(config.name, await each.ReadObject<any>(), each.identity, config.to));
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createIdentityResetPlugin(): PipelinePlugin {
  return resetIdentity;
}