import { TelemetryClient } from "applicationinsights";
import { VERSION } from "./lib/constants";

const inWebpack = typeof __webpack_require__ === "function";

const APPLICATION_INSIGHTS_IKEY_DEV = "bd4694df-6d6d-490e-ac2c-51175d08e2d9";
const APPLICATION_INSIGHTS_IKEY_PROD = "bd4694df-6d6d-490e-ac2c-51175d08e2d9";

const APPLICATION_INSIGHTS_IKEY = inWebpack ? APPLICATION_INSIGHTS_IKEY_PROD : APPLICATION_INSIGHTS_IKEY_DEV;

export interface TelemetryOptions {
  disable?: boolean;
}

export function createTelemetryClient(options: TelemetryOptions) {
  const client = new TelemetryClient(process.env.AUTOREST_AI_IKEY || APPLICATION_INSIGHTS_IKEY);
  if (options.disable || process.env.AUTOREST_DISABLE_TELEMETRY) {
    client.config.disableAppInsights = true;
  }
  client.setAutoPopulateAzureProperties(false);

  // Clear data that shouldn't be added
  client.context.tags[client.context.keys.cloudRole] = "";
  client.context.tags[client.context.keys.cloudRoleInstance] = "";

  // Add new fields
  client.commonProperties["coreVersion"] = VERSION;
  return client;
}
