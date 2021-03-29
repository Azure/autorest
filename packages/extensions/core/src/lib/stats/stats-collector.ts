import { merge } from "lodash";

export type StatGroup = { [key: string]: Stat };
export type Stat = number | StatGroup;

export class StatsCollector {
  private stats: { [key: string]: Stat } = {};

  public track(value: Stat) {
    merge(this.stats, value);
  }

  public getAll() {
    return this.stats;
  }
}
