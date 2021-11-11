import progressBar from "cli-progress";
import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestSyncLogger } from "./logger";
import { LoggerSink, LogInfo, Progress, ProgressTracker } from "./types";

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

  public startProgress(initialName?: string): ProgressTracker {
    const cli = new progressBar.SingleBar(
      {
        format: "{name} [{bar}] {percentage}% | ETA: {eta}s | {value}/{total}",
      },
      progressBar.Presets.legacy,
    );

    let started = false;
    const update = (progress: Progress) => {
      const name = progress.name ?? initialName ?? "progress";
      if (!started) {
        started = true;
        cli.start(progress.total, 0, { name });
      } else {
        cli.setTotal(progress.total);
      }
      cli.update(progress.current, { name });
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
