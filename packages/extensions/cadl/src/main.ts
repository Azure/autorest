import { AutoRestExtension } from "@autorest/extension-base";
import { setupCadlCompilerPlugin } from "./cadl-compiler-plugin.js";

export async function initializePlugins(pluginHost: AutoRestExtension) {
  pluginHost.add("cadl-compiler", setupCadlCompilerPlugin);
}

async function main() {
  const pluginHost = new AutoRestExtension();
  await initializePlugins(pluginHost);
  await pluginHost.run();
}

main().catch((e) => {
  // eslint-disable-next-line no-console
  console.error("Unexpected Error while running modelerfour extension", e);
  // eslint-disable-next-line no-process-exit
  process.exit(1);
});
