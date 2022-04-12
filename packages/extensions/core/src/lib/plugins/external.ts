import { LogLevel } from "@autorest/common";
import {
  DataHandle,
  QuickDataSource,
  mergePipeStates,
  EnhancedPosition,
  Position,
  PathPosition,
} from "@azure-tools/datastore";
import { parseJsonPointer } from "@azure-tools/json";
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
              source: message.Source?.map((x) => ({
                document: x.document,
                position: processPosition(x.Position),
              })),
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

function processPosition(position: EnhancedPosition): Position | PathPosition {
  if (position.path) {
    if (typeof position.path === "string") {
      try {
        return { path: parseJsonPointer(position.path) };
      } catch (e) {
        return { path: [] };
      }
    }
    return { path: position.path };
  } else if (position.line) {
    return { column: position.column ?? 1, line: position.line };
  }

  return { path: [] };
}
