import { TelemetryClient } from "applicationinsights";

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

  client.context.tags[client.context.keys.cloudRole] = "";
  client.context.tags[client.context.keys.cloudRoleInstance] = "";
  return client;
}
