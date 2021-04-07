import { PipelinePlugin } from "../../pipeline/common";
import { QuickDataSource } from "@azure-tools/datastore";

export function createIdentityPlugin(): PipelinePlugin {
  return async (config, input) => input;
}

export function createNullPlugin(): PipelinePlugin {
  return async (config, input) => new QuickDataSource([]);
}
