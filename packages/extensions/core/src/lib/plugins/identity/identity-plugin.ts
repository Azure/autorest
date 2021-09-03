import { QuickDataSource } from "@azure-tools/datastore";
import { PipelinePlugin } from "../../pipeline/common";

export function createIdentityPlugin(): PipelinePlugin {
  return async (config, input) => input;
}

export function createNullPlugin(): PipelinePlugin {
  return async (config, input) => new QuickDataSource([]);
}
