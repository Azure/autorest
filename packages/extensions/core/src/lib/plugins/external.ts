import { DataHandle, QuickDataSource, mergePipeStates } from "@azure-tools/datastore";
import { Channel, Message } from "../message";
import { PipelinePlugin } from "../pipeline/common";
import { AutoRestExtension } from "../pipeline/plugin-endpoint";

/* @internal */
export function createExternalPlugin(host: AutoRestExtension, pluginName: string): PipelinePlugin {
  return async (config, input, sink) => {
    const extension = await host;
    const pluginNames = await extension.GetPluginNames(config.CancellationToken);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`Plugin ${pluginName} not found.`);
    }
    let shouldSkip: boolean | undefined;

    const results: Array<DataHandle> = [];
    const result = await extension.Process(
      pluginName,
      (key) => config.GetEntry(<any>key),
      config,
      input,
      sink,
      (f) => results.push(f),
      (message: Message) => {
        if (message.Channel === Channel.Control) {
          if (message.Details && message.Details.skip !== undefined) {
            shouldSkip = message.Details.skip;
          }
        } else {
          config.Message.bind(config)(message);
        }
      },

      config.CancellationToken,
    );
    if (!result) {
      throw new Error(`Plugin ${pluginName} reported failure.`);
    }
    return new QuickDataSource(results, mergePipeStates(input.pipeState, { skipping: shouldSkip }));
  };
}
