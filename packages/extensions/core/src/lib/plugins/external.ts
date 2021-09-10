import { LogLevel } from "@autorest/common";
import { DataHandle, QuickDataSource, mergePipeStates } from "@azure-tools/datastore";
import { Channel, Message } from "../message";
import { PipelinePlugin } from "../pipeline/common";
import { AutoRestExtension } from "../pipeline/plugin-endpoint";

/* @internal */
export function createExternalPlugin(host: AutoRestExtension, pluginName: string): PipelinePlugin {
  return async (context, input, sink) => {
    const extension = await host;
    const pluginNames = await extension.GetPluginNames(context.CancellationToken);
    if (pluginNames.indexOf(pluginName) === -1) {
      throw new Error(`Plugin ${pluginName} not found.`);
    }
    let shouldSkip: boolean | undefined;

    const results: DataHandle[] = [];
    const result = await extension.Process(
      pluginName,
      (key) => context.GetEntry(key),
      context,
      input,
      sink,
      (f) => results.push(f),
      (message: Message) => {
        switch (message.Channel) {
          case Channel.Debug:
          case Channel.Verbose:
          case Channel.Information:
          case Channel.Warning:
          case Channel.Error:
          case Channel.Fatal:
            context.log({
              level: message.Channel.toString() as LogLevel,
              message: message.Text,
              code: message.Key ? [...message.Key].join("/") : undefined,
              details: message.Details,
              source: message.Source?.map((x) => ({ document: x.document, position: x.Position as any })),
            });
            break;
          case Channel.Control:
            if (message.Details && message.Details.skip !== undefined) {
              shouldSkip = message.Details.skip;
            }
            break;
          case Channel.Protect:
            context.protectFiles(message.Details);
            break;
          default:
          // Other channels are handled by the pipeline.
        }
      },

      context.CancellationToken,
    );
    if (!result) {
      throw new Error(`Plugin ${pluginName} reported failure.`);
    }
    return new QuickDataSource(results, mergePipeStates(input.pipeState, { skipping: shouldSkip }));
  };
}
