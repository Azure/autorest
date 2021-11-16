import "source-map-support/register";
import { AutoRestExtension } from "@autorest/extension-base";
import { processRequest as checker } from "./checker/plugin-checker";
import { processRequest as flattener } from "./flattener/plugin-flattener";
import { processRequest as grouper } from "./grouper/plugin-grouper";
import { processRequest as modelerfour } from "./modeler/plugin-modelerfour";
import { processRequest as preNamer } from "./prenamer/plugin-prenamer";
import { processRequest as prechecker } from "./quality-precheck/prechecker";

export async function initializePlugins(pluginHost: AutoRestExtension) {
  pluginHost.add("prechecker", prechecker);
  pluginHost.add("modelerfour", modelerfour);
  pluginHost.add("grouper", grouper);
  pluginHost.add("pre-namer", preNamer);
  pluginHost.add("flattener", flattener);
  pluginHost.add("checker", checker);
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
