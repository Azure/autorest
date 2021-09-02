import { AutoRestExtension } from "@autorest/extension-base";
import { setupAdlCompilerPlugin } from "./adl-compiler-plugin.js";

export async function initializePlugins(pluginHost: AutoRestExtension) {
  pluginHost.Add("adl-compiler", setupAdlCompilerPlugin);
}

async function main() {
  const pluginHost = new AutoRestExtension();
  await initializePlugins(pluginHost);
  await pluginHost.Run();
}

main().catch((e) => {
  // eslint-disable-next-line no-console
  console.error("Unexpected Error while running modelerfour extension", e);
  // eslint-disable-next-line no-process-exit
  process.exit(1);
});
