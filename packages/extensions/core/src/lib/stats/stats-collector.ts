import { DeepPartial } from "@azure-tools/codegen";
import { merge } from "lodash";
import { StatGroup, Stat, AutorestStats } from "./stats";

function addStats(item: StatGroup, result: StatGroup) {
  for (const [key, value] of Object.entries(item)) {
    if (typeof value === "number") {
      if (key in result) {
        (result[key] as number) += value;
      } else {
        result[key] = value;
      }
    } else {
      if (!(key in result)) {
        result[key] = {};
      }
      addStats(value, result[key] as StatGroup);
    }
  }
}

/**
 * Deos a deep merge of the objects by summing the properties
 * @param items Items.
 * @returns
 */
function mergeSum<T extends StatGroup>(items: T[]): T {
  const result: StatGroup = {};
  for (const item of items) {
    addStats(item, result);
  }
  return result as T;
}

function createStats() {
  const stats = {
    openapi: {
      specs: {} as AutorestStats["openapi"]["specs"],
      get overall() {
        return mergeSum(Object.values(stats.openapi.specs));
      },
    },
  };
  return stats;
}

export class StatsCollector {
  private stats: { [key: string]: Stat } = createStats();

  public track(value: DeepPartial<AutorestStats>) {
    merge(this.stats, value);
  }

  public getAll() {
    return this.stats;
  }
}
