import "source-map-support/register";
import { AutoRestExtension } from "@autorest/extension-base";
import { processRequest as modelerfour } from "./modeler/plugin-modelerfour";
import { processRequest as preNamer } from "./prenamer/plugin-prenamer";
import { processRequest as flattener } from "./flattener/plugin-flattener";
import { processRequest as grouper } from "./grouper/plugin-grouper";
import { processRequest as checker } from "./checker/plugin-checker";
import { processRequest as prechecker } from "./quality-precheck/prechecker";

export async function initializePlugins(pluginHost: AutoRestExtension) {
  pluginHost.Add("prechecker", prechecker);
  pluginHost.Add("modelerfour", modelerfour);
  pluginHost.Add("grouper", grouper);
  pluginHost.Add("pre-namer", preNamer);
  pluginHost.Add("flattener", flattener);
  pluginHost.Add("checker", checker);
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
