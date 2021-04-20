import { DataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { PipelinePlugin } from "../../pipeline/common";
import * as oai3 from "@azure-tools/openapi";

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

      const specStat = {
        lineCount: rawContent.split("\n").length,
        operations: {
          total: countOperations(spec),
          longRunning: countLongRunningOperations(spec),
          pageable: countPageableOperations(spec),
        },
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
}

/**
 * @param spec OpenAPI spec
 * @returns number of operations(path + methods) defined in the spec.
 */
function countOperations(spec: oai3.Model): number {
  return Object.values(spec.paths).reduce((count, operation) => {
    return Object.keys(operation).length + count;
  }, 0);
}

/**
 * @param spec OpenAPI spec
 * @returns number of long runnning operations(defined with x-ms-long-running-operation: true) defined in the spec.
 */
function countLongRunningOperations(spec: oai3.Model): number {
  return Object.values(spec.paths).reduce((count, operation) => {
    return Object.values(operation).filter(isLongRunningOperation).length + count;
  }, 0);
}

function isLongRunningOperation(operation: oai3.HttpOperation): boolean {
  return operation["x-ms-long-running-operation"];
}

/**
 * @param spec OpenAPI spec
 * @returns number of long runnning operations(defined with x-ms-long-running-operation: true) defined in the spec.
 */
function countPageableOperations(spec: oai3.Model): number {
  return Object.values(spec.paths).reduce((count, operation) => {
    return Object.values(operation).filter(isPageableOperation).length + count;
  }, 0);
}

function isPageableOperation(operation: oai3.HttpOperation): boolean {
  return operation["x-ms-pageable"];
}

export function createOpenAPIStatsCollectorPlugin(): PipelinePlugin {
  return async (context, dataSource, sink) => {
    await collectOpenAPIStats(context, dataSource);
    return dataSource;
  };
}
