import { AnyObject, DataHandle, DataSink, DataSource, MultiProcessor, Node, ProxyObject, QuickDataSource, visit, Processor, } from '@microsoft.azure/datastore';
import { Dictionary } from '@microsoft.azure/linq';

import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';


/**
 * Prepares an OpenAPI document for the generation-2 code generators
 * (ie, anything before MultiAPI was introduced)
 *
 * This takes the Merged OpenAPI document and tweaks it so that it will work with earlier
 * Code Model-v1 generators.
 *
 * This replaces the original 'composer'
 *
 * Notably:
 *  inlines schema $refs for operation parameters because the existing modeler doesn't unwrap $ref'd schemas for parameters
 *  Inlines header $refs for responses
 *  inline produces/consumes
 *  Ensures there is but one title
 *  inlines API version as a constant parameter
 *
 */

export class NewComposer extends Processor<AnyObject, AnyObject> {

}

async function compose(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const shaker = new NewComposer(each);
    result.push(await sink.WriteObject(each.Description, shaker.output, each.identity, each.artifactType, shaker.sourceMappings));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createTreeShakerPlugin(): PipelinePlugin {
  return compose;
}
