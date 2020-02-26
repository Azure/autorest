import { PipelinePlugin } from '../common';
import { ConfigurationView } from '../../configuration';
import { DataSource, DataSink, DataHandle, QuickDataSource } from '@azure-tools/datastore';
import { values } from '@azure-tools/linq';

/*@internal */
export function createIdentityPlugin(): PipelinePlugin {
  return async (config, input) => input;
}

export function createNullPlugin(): PipelinePlugin {
  return async (config, input) => new QuickDataSource([]);
}

async function resetIdentity(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  const numberEachFile = inputs.length > 1 && values(inputs).distinct(each => each.Description);
  let i = 0;
  for (const each of inputs) {
    let name = `${config.name || each.Description}`;
    if (numberEachFile) {
      let p = name.lastIndexOf('.');
      p = p === -1 ? name.length : p;
      name = `${name.substring(0, p)}-${i++}${name.substring(p)}`;
    }

    result.push(await sink.WriteData(name, await each.ReadData(), each.identity, config.to));
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createIdentityResetPlugin(): PipelinePlugin {
  return resetIdentity;
}