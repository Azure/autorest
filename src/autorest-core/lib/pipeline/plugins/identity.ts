import { PipelinePlugin } from '../common';

/*@internal */
export function GetPlugin_Identity(): PipelinePlugin {
  return async (config, input) => input;
}
