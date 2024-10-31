import { EnhancedPosition } from "@azure-tools/datastore";
import { serializeJsonPointer } from "@azure-tools/json";
import chalk, { level } from "chalk";
import { color } from "../utils";
import { EnhancedLogInfo, EnhancedSourceLocation } from "./types";
import { LogLevel } from ".";

export interface LogFormatter {
  log(log: EnhancedLogInfo): string;
}

export interface FormatterOptions {
  color?: boolean;
  timestamp?: boolean;
}

const defaultOptions = {
  color: true,
  timestamp: true,
};

export function createLogFormatter(format: "json" | "regular" | undefined, options = {}): LogFormatter {
  return format === "json" ? new JsonLogFormatter(options) : new PrettyLogFormatter(options);
}

const LEVEL_STR: Record<LogLevel, string> = {
  debug: "debug".padEnd(7),
  verbose: "verbose".padEnd(7),
  information: "info".padEnd(7),
  warning: "warning".padEnd(7),
  error: "error".padEnd(7),
  fatal: "fatal".padEnd(7),
};

const LEVEL_COLORED_STR: Record<LogLevel, string> = {
  debug: chalk.blue(LEVEL_STR.debug),
  verbose: chalk.gray(LEVEL_STR.verbose),
  information: chalk.green(LEVEL_STR.information),
  warning: chalk.yellow.bold(LEVEL_STR.warning),
  error: chalk.red.bold(LEVEL_STR.error),
  fatal: chalk.redBright.bold(LEVEL_STR.fatal),
};

export class PrettyLogFormatter implements LogFormatter {
  private options: { color: boolean; timestamp: boolean };

  public constructor(options: FormatterOptions = {}) {
    this.options = { ...defaultOptions, ...options };
  }

  public log(log: EnhancedLogInfo): string {
    const useColor = this.options.color;
    const t = this.formatTimestamp(log.level);
    const level = useColor ? LEVEL_COLORED_STR[log.level] : LEVEL_STR[log.level];
    const message = useColor ? color(log.message) : log.message;

    let text = `${level} |${this.formatCode(log.code)}${t} ${message}`;
    for (const source of log.source ?? []) {
      text += this.formatSource(source);
    }
    return text;
  }

  private formatCode(code: string | undefined): string {
    if (!code) {
      return "";
    }

    return ` ${this.color(code, chalk.green)} |`;
  }

  private formatTimestamp(level: LogLevel): string {
    if (!(this.options.timestamp && (level === "debug" || level === "verbose"))) {
      return "";
    }
    const colored = this.color(`[${getUpTime()} s]`, chalk.yellow);
    return ` ${colored}`;
  }

  private color(text: string, color: (text: string) => string) {
    return this.options.color ? color(text) : text;
  }

  private formatSource(source: EnhancedSourceLocation): string {
    if (!source.position) {
      return "";
    }
    try {
      return `\n    - ${this.color(source.document, chalk.cyan)}${this.formatPosition(source.position)}`;
    } catch (e) {
      // no friendly name, so nothing more specific to show
      return "";
    }
  }

  private formatPosition(position: EnhancedPosition) {
    let text = "";
    if (position.line !== undefined) {
      text += `:${this.color(position.line.toString(), chalk.cyan.bold)}`;
      if (position.column !== undefined) {
        text += `:${this.color(position.column.toString(), chalk.cyan.bold)}`;
      }
    }

    const path = position.path ? ` (${serializeJsonPointer(position.path)})` : "";
    return `${text}${path}`;
  }
}

export class JsonLogFormatter implements LogFormatter {
  private options: { timestamp: boolean };
  public constructor(options: { timestamp?: boolean }) {
    this.options = { timestamp: true, ...options };
  }
  public log(log: EnhancedLogInfo): string {
    const addTimestamp = this.options.timestamp && (log.level === "debug" || log.level === "verbose");

    const data = addTimestamp ? { ...log, uptime: getUpTime() } : log;
    return JSON.stringify(data);
  }
}

/**
 * @returns uptime of process in seconds
 */
function getUpTime(): string {
  return process.uptime().toFixed(2);
}
