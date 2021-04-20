import { AutorestContext, getExtension } from "../context";
import { CORE_PLUGIN_MAP } from "../plugins";
import { createExternalPlugin } from "../plugins/external";
import { PipelinePlugin } from "./common";
import { AutoRestExtension } from "./plugin-endpoint";

export interface PipelinePluginDefinition {
  /**
   * Name of the plugin.
   */
  readonly name: string;

  /**
   * Plugin function.
   */
  readonly plugin: PipelinePlugin;

  /**
   * Extension defining plugin or undefined if built-in.
   */
  readonly extension: AutoRestExtension | undefined;

  /**
   * If this plugin is built-in inside of @autorest/core.
   */
  readonly builtIn: boolean;
}

/**
 * Resolve all the plugins defined in core and loaded extensions.
 * @param context AutorestContext
 * @returns Map of plugin name to plugin definition.
 */
export async function loadPlugins(
  context: AutorestContext,
): Promise<{ [pluginName: string]: PipelinePluginDefinition }> {
  const plugins: { [pluginName: string]: PipelinePluginDefinition } = {};

  for (const [name, plugin] of Object.entries(CORE_PLUGIN_MAP)) {
    plugins[name] = { name, plugin, builtIn: true, extension: undefined };
  }

  for (const useExtensionQualifiedName of context.config["used-extension"] || []) {
    const extension = await getExtension(useExtensionQualifiedName);
    for (const name of await extension.GetPluginNames(context.CancellationToken)) {
      if (!plugins[name]) {
        plugins[name] = {
          name,
          plugin: createExternalPlugin(extension, name),
          builtIn: false,
          extension: extension,
        };
      }
    }
  }

  return plugins;
}
