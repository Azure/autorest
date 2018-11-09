import { PipelinePlugin } from '../common';

/*@internal */
export function createIdentityPlugin(): PipelinePlugin {
  return async (config, input) => input;
}
