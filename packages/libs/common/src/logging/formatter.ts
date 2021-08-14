import { serializeJsonPointer } from "@azure-tools/json";
import { EnhancedPosition } from "@azure-tools/datastore";
import { EnhancedLogInfo, EnhancedSourceLocation } from "./types";
import { color } from "../utils";

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

export class PrettyLogFormatter implements LogFormatter {
  private options: { color: boolean; timestamp: boolean };

  public constructor(options: FormatterOptions) {
    this.options = { ...defaultOptions, ...options };
  }

  public log(log: EnhancedLogInfo): string {
    const addTimestamp = this.options.timestamp && (log.level === "debug" || log.level === "verbose");
    const t = addTimestamp ? ` [${getUpTime()} s]` : "";
    let text = `${log.level.toUpperCase()}${log.code ? ` (${log.code})` : ""}${t}: ${log.message}`;
    for (const source of log.source ?? []) {
      text += this.formatSource(source);
    }
    return this.options.color ? color(text) : text;
  }

  private formatSource(source: EnhancedSourceLocation): string {
    if (!source.position) {
      return "";
    }
    try {
      return `\n    - ${source.document}${this.formatPosition(source.position)}`;
    } catch (e) {
      // no friendly name, so nothing more specific to show
      return "";
    }
  }

  private formatPosition(position: EnhancedPosition) {
    let text = "";
    if (position.line !== undefined) {
      text += `:${position.line}`;
      if (position.column !== undefined) {
        text += `:${position.column}`;
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
function getUpTime(): number {
  return Math.floor(process.uptime() * 100) / 100;
}
