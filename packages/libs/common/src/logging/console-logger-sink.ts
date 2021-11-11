import progressBar from "cli-progress";
import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestSyncLogger } from "./logger";
import { LoggerSink, LogInfo, ProgressTracker } from "./types";

export interface ConsoleLoggerSinkOptions {
  format?: "json" | "regular";
  color?: boolean;
  timestamp?: boolean;
}

/**
 * Logger sink to output logs to the console.
 */
export class ConsoleLoggerSink implements LoggerSink {
  private formatter: LogFormatter;

  public constructor(options: ConsoleLoggerSinkOptions = {}) {
    this.formatter = createLogFormatter(options.format, options);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);
    // eslint-disable-next-line no-console
    console.log(line);
  }

  public startProgress(): ProgressTracker {
    const cli = new progressBar.SingleBar({}, progressBar.Presets.legacy);
    cli.start(100, 0);
    const update = (progress: number) => {
      cli.update(progress);
    };

    const stop = () => {
      cli.stop();
    };

    return {
      update,
      stop,
    };
  }
}

/**
 * Simple logger which takes log info as it is and logs it.
 * Doesn't resolve original source locations.
 */
export class ConsoleLogger extends AutorestSyncLogger {
  public constructor(options: ConsoleLoggerSinkOptions = {}) {
    super({ sinks: [new ConsoleLoggerSink(options)] });
  }
}
