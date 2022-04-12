import { WriteStream } from "tty";
import progressBar from "cli-progress";
import { createLogFormatter, LogFormatter } from "./formatter";
import { AutorestSyncLogger } from "./logger";
import { LoggerSink, LogInfo, Progress, ProgressTracker } from "./types";

export interface ConsoleLoggerSinkOptions {
  /**
   * Stream to use for output. (@default stdout)
   */
  stream?: NodeJS.WritableStream;

  format?: "json" | "regular";
  color?: boolean;
  timestamp?: boolean;

  /**
   * Enable output for non TTY output(e.g. file) for the progress file.
   */
  progressNoTTYOutput?: boolean;
}

const ProgressBarUnavailable = Symbol("NoBar");

/**
 * Logger sink to output logs to the console.
 */
export class ConsoleLoggerSink implements LoggerSink {
  private formatter: LogFormatter;
  private currentProgressBar: progressBar.MultiBar | undefined;
  private bars: progressBar.SingleBar[] = [];
  private pendingLogs: string[] = [];
  private format: "json" | "regular";
  private stream: NodeJS.WritableStream;

  public constructor(private options: ConsoleLoggerSinkOptions = {}) {
    this.stream = options.stream ?? process.stdout;
    this.format = options.format ?? "regular";
    this.formatter = createLogFormatter(options.format, options);
  }

  public log(log: LogInfo) {
    const line = this.formatter.log(log);
    if (this.currentProgressBar) {
      this.pendingLogs.push(line);
    } else {
      this.writeLine(line);
    }
  }

  public startProgress(initialName?: string): ProgressTracker {
    if (this.format === "regular") {
      return this.startProgressBar(initialName);
    } else {
      return NoopProgress;
    }
  }

  private isTTY(): boolean {
    return (this.stream as any).isTTY;
  }

  private startProgressBar(initialName?: string): ProgressTracker {
    // If in a non TTY stream do not even start the progress bar.
    if (!this.isTTY() && !this.options.progressNoTTYOutput) {
      return {
        update: (progress: Progress) => {},
        stop: () => {},
      };
    }

    if (this.currentProgressBar === undefined) {
      this.currentProgressBar = new progressBar.MultiBar(
        {
          hideCursor: true,
          stream: this.stream,
          noTTYOutput: this.options.progressNoTTYOutput,
          format: "{name} [{bar}] {percentage}% | {value}/{total}",
          forceRedraw: true, // without this the bar is flickering,
        },
        progressBar.Presets.legacy,
      );
    }
    const multiBar = this.currentProgressBar;

    multiBar.on("redraw-pre", () => {
      if (this.pendingLogs.length > 0) {
        if ("clearLine" in this.stream) {
          (this.stream as WriteStream).clearLine(1);
        }
      }
      while (this.pendingLogs.length > 0) {
        this.writeLine(this.pendingLogs.shift());
      }
    });

    multiBar.on("stop", () => {
      this.currentProgressBar = undefined;
      while (this.pendingLogs.length > 0) {
        this.writeLine(this.pendingLogs.shift());
      }
    });

    let bar: progressBar.SingleBar | typeof ProgressBarUnavailable | undefined;

    const update = (progress: Progress) => {
      if (bar === ProgressBarUnavailable) {
        return;
      }
      const name = progress.name ?? initialName ?? "progress";
      if (bar === undefined) {
        const createdBar = multiBar.create(progress.total, 0, { name });
        // Can return undefined if the stream is not TTY.
        if (createdBar === undefined) {
          bar = ProgressBarUnavailable;
          return;
        } else {
          bar = createdBar;
          this.bars.push(bar);
        }
      } else {
        bar.setTotal(progress.total);
      }

      bar.update(progress.current, { name });
    };

    const stop = () => {
      if (bar && bar !== ProgressBarUnavailable) {
        bar.update(bar.getTotal());
        bar.render();
        bar.stop();
        multiBar.remove(bar);
        this.bars = this.bars.filter((x) => x !== bar);
      }

      if (this.bars.length === 0) {
        multiBar.stop();
        this.currentProgressBar = undefined;
      }
    };

    return {
      update,
      stop,
    };
  }

  private writeLine(line: string | undefined) {
    if (line !== undefined) {
      this.stream.write(Buffer.from(`${line}\n`));
    }
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

const NoopProgress = {
  update: () => null,
  stop: () => null,
};
