import { AutorestLogger, AutorestLoggerBase, LogInfo, LogLevel } from "@autorest/common";

export function createMockLogger(overrides: Partial<AutorestLogger> = {}): AutorestLogger {
  return {
    info: jest.fn(),
    verbose: jest.fn(),
    fatal: jest.fn(),
    trackWarning: jest.fn(),
    trackError: jest.fn(),
    log: jest.fn(),
    diagnostics: [],
    ...overrides,
  };
}

export class AutorestTestLogger extends AutorestLoggerBase {
  public logs: Record<LogLevel | "all", LogInfo[]> = {
    all: [],
    debug: [],
    verbose: [],
    information: [],
    warning: [],
    error: [],
    fatal: [],
  };

  public log(log: LogInfo): void {
    this.logs[log.level].push(log);
    this.logs.all.push(log);
  }
}
