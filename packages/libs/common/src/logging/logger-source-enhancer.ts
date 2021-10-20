import { DataStore } from "@azure-tools/datastore";
import { LogSourceEnhancer } from "./log-source-enhancer";
import { AutorestLogger, LoggerAsyncProcessor, LogInfo } from "./types";

export interface AutorestCoreLoggerOptions {
  logger: AutorestLogger;
}

export class AutorestLoggerSourceEnhancer implements LoggerAsyncProcessor {
  private logInfoEnhancer: LogSourceEnhancer;
  public constructor(dataStore: DataStore) {
    this.logInfoEnhancer = new LogSourceEnhancer(dataStore);
  }

  public async process(log: LogInfo): Promise<LogInfo | undefined> {
    const enhancedLog = await this.logInfoEnhancer.process(log);
    return enhancedLog as any;
  }
}
