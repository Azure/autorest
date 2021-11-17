import { SourceLocation, Channel, Message } from "./types";

export type LogLevel = "debug" | "verbose" | "info" | "warning" | "error" | "fatal";

export interface LogInfo {
  level: LogLevel;
  message: string;

  /**
   * Code for the log.
   * @example -> ["MyPlugin", "CannotDoThat"] -> "MyPlugin/CannotDoThat"
   */
  key?: string[];

  /**
   * Position where this log can be traced to.
   */
  source?: SourceLocation;

  /**
   * Additional details.
   */
  details?: any;
}

export class AutorestExtensionLogger {
  public constructor(private sendMessage: (message: Message) => void) {}

  public debug(message: string) {
    this.log({ level: "debug", message });
  }

  public verbose(message: string) {
    this.log({ level: "verbose", message });
  }

  public info(message: string) {
    this.log({ level: "info", message });
  }

  public warning(message: string, key: string[], source?: SourceLocation, details?: any) {
    this.log({ level: "warning", message, key, source, details });
  }

  public error(message: string, key: string[], source?: SourceLocation, details?: any) {
    this.log({ level: "error", message, key, source, details });
  }

  public fatal(message: string, key: string[], source?: SourceLocation, details?: any) {
    this.log({ level: "fatal", message, key, source, details });
  }

  public log(info: LogInfo) {
    const sources = info.source ? [info.source] : [];
    this.sendMessage({
      Channel: getChannel(info.level),
      Key: info.key,
      Source: sources,
      Text: info.message,
      Details: info.details,
    });
  }
}

function getChannel(level: LogLevel): Channel {
  switch (level) {
    case "debug":
      return Channel.Debug;
    case "verbose":
      return Channel.Verbose;
    case "info":
      return Channel.Information;
    case "warning":
      return Channel.Warning;
    case "error":
      return Channel.Error;
    case "fatal":
      return Channel.Fatal;
  }
}
