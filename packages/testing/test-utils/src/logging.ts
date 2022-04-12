import {
  AutorestLogger,
  AutorestLoggerBase,
  LogInfo,
  LogLevel,
  LoggerProcessor,
  AutorestDiagnostic,
} from "@autorest/common";

export function createMockLogger(overrides: Partial<AutorestLogger> = {}): AutorestLogger {
  const logger: AutorestLogger = {
    debug: jest.fn(),
    info: jest.fn(),
    verbose: jest.fn(),
    fatal: jest.fn(),
    trackWarning: jest.fn(),
    trackError: jest.fn(),
    log: jest.fn(),
    with: jest.fn(() => logger),
    startProgress: jest.fn(() => ({
      update: jest.fn(),
      stop: jest.fn(),
    })),
    diagnostics: [],
    ...overrides,
  };
  return logger;
}

export class AutorestTestLogger extends AutorestLoggerBase<LoggerProcessor> {
  public logs: Record<LogLevel | "all", LogInfo[]> = {
    all: [],
    debug: [],
    verbose: [],
    information: [],
    warning: [],
    error: [],
    fatal: [],
  };

  public constructor() {
    super({
      sinks: [
        {
          log: (x) => this.log(x),
          startProgress: jest.fn(() => ({
            update: jest.fn(),
            stop: jest.fn(),
          })),
        },
      ],
    });
  }

  public log(log: LogInfo): void {
    this.logs[log.level].push(log);
    this.logs.all.push(log);
  }

  public trackDiagnostic(diagnostic: AutorestDiagnostic): void {
    this.log(diagnostic);
  }

  public with(...processors: LoggerProcessor[]): AutorestLogger {
    return this;
  }
}
