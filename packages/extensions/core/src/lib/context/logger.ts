import { Channel, Message, Range, SourceLocation } from "../message";
import { BlameTree, DataStore, stringify, Stringify, tryDecodeEnhancedPositionFromName } from "@azure-tools/datastore";
import { AutorestError, AutorestWarning } from "@autorest/common";
import { AutorestConfiguration } from "@autorest/configuration";
import { Suppressor } from "../pipeline/suppression";
import { LoggingSession } from "./logging-session";
import { flatMap } from "lodash";

export class AutorestCoreLogger {
  private suppressor: Suppressor;

  public constructor(
    private config: AutorestConfiguration,
    private dataStore: DataStore,
    private asyncLogManager: LoggingSession,
  ) {
    this.suppressor = new Suppressor(config);
  }

  public verbose(message: string) {
    this.log({
      channel: Channel.Verbose,
      message: message,
    });
  }

  public info(message: string) {
    this.log({
      channel: Channel.Information,
      message: message,
    });
  }

  public fatal(message: string) {
    this.log({
      channel: Channel.Fatal,
      message: message,
    });
  }

  public trackWarning(error: AutorestWarning) {
    this.log({
      channel: Channel.Warning,
      message: error.message,
      source: error.source?.map((x) => ({ document: x.document, Position: x.position as any })),
      details: error.details,
    });
  }

  public trackError(error: AutorestError) {
    this.log({
      channel: Channel.Error,
      message: error.message,
      source: error.source?.map((x) => ({ document: x.document, Position: x.position as any })),
      details: error.details,
    });
  }

  public log(message: Message) {
    if (message.channel === Channel.Debug && !this.config.debug) {
      return;
    }

    if (message.channel === Channel.Verbose && !this.config.verbose) {
      return;
    }

    this.asyncLogManager.registerLog(() => this.sendMessageAsync(message));
  }

  private async sendMessageAsync(m: Message): Promise<Message | undefined> {
    try {
      // update source locations to point to loaded Swagger
      if (m.source && typeof m.source.map === "function") {
        const sources = await this.resolveOriginalSources(m, m.source);
        m.source = this.resolveOriginalDocumentNames(sources);
      }

      // set range (dummy)
      if (m.source && typeof m.source.map === "function") {
        m.range = resolveRanges(m.source);
      }

      // filter
      const mx = this.suppressor.filter(m);

      // forward
      if (mx !== null) {
        // format message
        switch (this.config["message-format"]) {
          case "json":
            mx.formattedMessage = getJsonFormatterMessage(mx);
            break;
          case "jsonLegacy":
            mx.formattedMessage = getLegacyJsonFormatterMessage(mx);
            break;
          case "yaml":
            mx.formattedMessage = Stringify([mx.details || mx]).replace(/^---/, "");
            break;
          default: {
            mx.formattedMessage = getTextFormattedMessage(mx);
            break;
          }
        }

        return mx;
      }
    } catch (e) {
      return { channel: Channel.Error, message: `${e}` };
    }
  }

  private async resolveOriginalSources(message: Message, source: SourceLocation[]) {
    const blameSources = source.map(async (s) => {
      let blameTree: BlameTree | null = null;

      try {
        const originalPath = JSON.stringify(s.Position.path);
        let shouldComplain = false;
        while (blameTree === null) {
          try {
            blameTree = await this.dataStore.blame(s.document, s.Position);
            if (shouldComplain) {
              await this.log({
                channel: Channel.Verbose,
                message: `\nDEVELOPER-WARNING: Path '${originalPath}' was corrected to ${JSON.stringify(
                  s.Position.path,
                )} on MESSAGE '${JSON.stringify(message.message)}'\n`,
              });
            }
          } catch (e) {
            if (!shouldComplain) {
              shouldComplain = true;
            }
            const path = <Array<string>>s.Position.path;
            if (path) {
              if (path.length === 0) {
                throw e;
              }
              // adjustment
              // 1) skip leading `$`
              if (path[0] === "$") {
                path.shift();
              } else {
                path.pop();
              }
            } else {
              throw e;
            }
          }
        }
      } catch (e) {
        this.log({
          channel: Channel.Debug,
          message: `Failed to blame ${JSON.stringify(s.Position)} in '${JSON.stringify(s.document)}' (${e})`,
          details: e,
        });
        return [s];
      }

      return blameTree.getMappingLeafs().map((r) => ({
        document: r.source,
        Position: { ...tryDecodeEnhancedPositionFromName(r.name), line: r.line, column: r.column },
      }));
    });

    return flatMap(await Promise.all(blameSources));
  }

  private resolveOriginalDocumentNames(sources: SourceLocation[]) {
    return sources.map((source) => {
      if (source.Position) {
        try {
          const document = this.dataStore.readStrictSync(source.document).description;
          return { ...source, document };
        } catch {
          // no worries
        }
      }
      return source;
    });
  }
}

function resolveRanges(sources: SourceLocation[]): Range[] {
  return sources.map((source) => {
    const positionStart = source.Position;
    const positionEnd = <sourceMap.Position>{
      line: source.Position.line,
      column: source.Position.column + (source.Position.length || 3),
    };

    return {
      document: source.document,
      start: positionStart,
      end: positionEnd,
    };
  });
}

/**
 * Gets the formattedMessage for text output.
 */
function getTextFormattedMessage(message: Message): string {
  const timestamp =
    message.channel === Channel.Debug || message.channel === Channel.Verbose ? ` ${getUptimePrefix()}` : "";
  const channel = (message.channel || Channel.Information).toString().toUpperCase();
  let text = `${channel}${getMessageKey(message)}${timestamp}: ${message.message}`;

  for (const source of message.source || []) {
    if (source.Position) {
      try {
        text += `\n    - ${source.document}`;
        if (source.Position.line !== undefined) {
          text += `:${source.Position.line}`;
          if (source.Position.column !== undefined) {
            text += `:${source.Position.column}`;
          }
        }
        if (source.Position.path) {
          text += ` (${stringify(source.Position.path)})`;
        }
      } catch (e) {
        // no friendly name, so nothing more specific to show
      }
    }
  }
  return text;
}

/**
 * Returns uptime prefix.
 * @returns
 */
function getUptimePrefix() {
  return `[${Math.floor(process.uptime() * 100) / 100} s]`;
}

/**
 * Returns the formatted message key if present.
 * @param message Message
 * @returns formatted message key.
 */
function getMessageKey(message: Message) {
  return message.key ? ` (${[...message.key].join("/")})` : "";
}

function getJsonFormatterMessage(message: Message) {
  return JSON.stringify(message, null, 2);
}

function getLegacyJsonFormatterMessage(message: Message) {
  if (message.details) {
    message.details.sources = (message.source || [])
      .filter((x) => x.Position)
      .map((source) => {
        let text = `${source.document}:${source.Position.line}:${source.Position.column}`;
        if (source.Position.path) {
          text += ` (${stringify(source.Position.path)})`;
        }
        return text;
      });
    if (message.details.sources.length > 0) {
      message.details["jsonref"] = message.details.sources[0];
      message.details["json-path"] = message.details.sources[0];
    }
  }
  const legacyMessage = {
    Channel: message.channel,
    Details: message.details,
    Text: message.message,
    Key: message.key,
    Source: message.source,
    Plugin: message.plugin,
  };

  return JSON.stringify(message.details || legacyMessage, null, 2);
}
