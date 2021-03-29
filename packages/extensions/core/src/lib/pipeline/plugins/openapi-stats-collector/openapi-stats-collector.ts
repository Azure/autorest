import { DataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../../../configuration";
import { PipelinePlugin } from "../../common";
import * as oai3 from "@azure-tools/openapi";
import { StatGroup } from "../../../stats";
import { inspect } from "util";

interface OpenAPISpecCount extends StatGroup {
  lineCount: number;
  schemaCount: number;
  operationCount: number;
  longRunningOperationCount: number;
}

export async function collectOpenAPIStats(context: AutorestContext, dataSource: DataSource) {
  const inputs = await dataSource.enum();
  context.stats.track({
    openapi: {
      inputCount: inputs.length,
    },
  });

  for (const input of inputs) {
    const data = await dataSource.read(input);
    if (data) {
      const rawContent = await data.readData();
      const spec = await data.readObject<oai3.Model>();

      const specStat: OpenAPISpecCount = {
        lineCount: rawContent.split("\n").length,
        schemaCount: Object.keys(spec?.components?.schemas ?? {}).length,
        operationCount: countOperations(spec),
        longRunningOperationCount: countLongRunningOperations(spec),
      };

      context.stats.track({
        openapi: {
          specs: {
            [data.description]: specStat,
          },
        },
      });
    }
  }
  console.log("Stats", inspect(context.stats.getAll(), { depth: null, colors: true }));
}

function countOperations(spec: oai3.Model) {
  return Object.values(spec.paths).reduce((count, operation) => {
    return Object.keys(operation).length + count;
  }, 0);
}

function countLongRunningOperations(spec: oai3.Model) {
  return Object.values(spec.paths).reduce((count, operation) => {
    return Object.values(operation).filter(isLongRunningOperation).length + count;
  }, 0);
}

function isLongRunningOperation(operation: oai3.HttpOperation): boolean {
  return operation["x-ms-long-running-operation"];
}

export function createOpenAPIStatsCollectorPlugin(): PipelinePlugin {
  return async (context, dataSource, sink) => {
    await collectOpenAPIStats(context, dataSource);
    return dataSource;
  };
}
