import { TelemetryClient } from "applicationinsights";
import { VERSION } from "./lib/constants";

const APPLICATION_INSIGHTS_IKEY = "bd4694df-6d6d-490e-ac2c-51175d08e2d9";

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
