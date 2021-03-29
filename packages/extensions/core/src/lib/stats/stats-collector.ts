export class StatsCollector {
  private stats: { [key: string]: number } = {};

  public track(name: string, value: number) {
    this.stats[name] = value;
  }

  public getAll() {
    return this.stats;
  }
}
