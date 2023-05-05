import { matches, PathPosition } from "@azure-tools/datastore";
import { JsonPointerTokens } from "@azure-tools/json";
import { arrayify } from "../utils";
import { LogInfo, LogLevel } from "./types";
import { LoggerProcessor } from ".";

export interface LogSuppression {
  code: string;
  from?: string[] | string;
  where?: string[] | string;
}

export interface FilterLoggerOptions {
  level: LogLevel;
  suppressions?: LogSuppression[];
}

/**
 * Logger adding filtering functionality based on:
 *  - level: only show log with level higher than the configuration.
 *  - suppression: List of code that should not be logged.
 */
export class FilterLogger implements LoggerProcessor {
  private level: LogLevel;
  private suppressions: LogSuppression[];

  public constructor(options: FilterLoggerOptions) {
    this.level = options.level;
    this.suppressions = options.suppressions?.map((x) => ({ ...x, code: x.code.toLowerCase() })) ?? [];
  }

  public process(log: LogInfo): LogInfo | undefined {
    if (!shouldLogLevel(log, this.level)) {
      return;
    }
    return this.filterSuppressions(log);
  }

  private filterSuppressions(log: LogInfo): LogInfo | undefined {
    const hadSource = log.source && log.source.length > 0;
    let currentLog = log;
    const key = log.code?.toLowerCase();

    // filter
    for (const sup of this.suppressions) {
      // matches key
      if (key && (key === sup.code || key.startsWith(`${sup.code}/`))) {
        // filter applicable sources
        if (log.source && hadSource) {
          currentLog = {
            ...currentLog,
            source: currentLog.source?.filter(
              (s) => !this.matchesSourceFilter(s.document, (s.position as PathPosition).path, sup),
            ),
          };
        } else {
          return undefined;
        }
      }
    }
    // drop message if all source locations have been stripped
    if (hadSource && currentLog.source?.length === 0) {
      return undefined;
    }

    return log;
  }

  private matchesSourceFilter(
    document: string,
    path: JsonPointerTokens | undefined,
    supression: LogSuppression,
  ): boolean {
    // from
    const from = arrayify(supression.from);
    const matchesFrom = from.length === 0 || from.find((d) => document.toLowerCase().endsWith(d.toLowerCase()));

    // where
    const where = arrayify(supression.where);
    const matchesWhere = where.length === 0 || (path && where.find((w) => matches(w, path))) || false;

    return Boolean(matchesFrom && matchesWhere);
  }
}

const LOG_LEVEL: Record<LogLevel, number> = {
  debug: 10,
  verbose: 20,
  information: 30,
  warning: 40,
  error: 50,
  fatal: 60,
};

export function shouldLogLevel(log: LogInfo, level: LogLevel) {
  return LOG_LEVEL[log.level] >= LOG_LEVEL[level];
}
