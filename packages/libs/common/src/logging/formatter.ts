import { serializeJsonPointer } from "@azure-tools/json";
import { EnhancedPosition } from "../../../datastore/dist/source-map";
import { LogLevel } from "./logger";

export interface EnhancedSourceLocation {
  document: string;
  position: EnhancedPosition;
}
export interface LogInfo {
  readonly level: LogLevel;
  readonly message: string;
  readonly code?: string;
  readonly source?: EnhancedSourceLocation[];
  readonly details?: Error | unknown;
}

export interface LogFormatter {
  log(log: LogInfo): string;
}

export class PrettyLogFormatter implements LogFormatter {
  public log(log: LogInfo): string {
    const t = log.level === "debug" || log.level === "verbose" ? ` [${getUpTime()} s]` : "";
    let text = `${log.level.toUpperCase()}${log.code ? ` (${log.code})` : ""}${t}: ${log.message}`;
    for (const source of log.source ?? []) {
      text += this.formatSource(source);
    }
    return text;
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
  public log(log: LogInfo): string {
    const data = log.level === "verbose" || log.level === "debug" ? { ...log, uptime: getUpTime() } : log;
    return JSON.stringify(data, null, 2);
  }
}

/**
 * @returns uptime of process in seconds
 */
function getUpTime(): number {
  return Math.floor(process.uptime() * 100) / 100;
}
