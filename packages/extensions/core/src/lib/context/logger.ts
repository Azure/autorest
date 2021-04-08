import { Channel, Message, Range, SourceLocation } from "../message";
import { BlameTree, stringify, Stringify, tryDecodeEnhancedPositionFromName } from "@azure-tools/datastore";
import { AutorestError, AutorestWarning } from "@autorest/common";
import { AutorestConfiguration } from "@autorest/configuration";
import { Suppressor } from "../pipeline/suppression";
import { MessageEmitter } from "./message-emitter";
import { LoggingSession } from "./logging-session";
import { flatMap } from "lodash";

export class AutorestCoreLogger {
  private suppressor: Suppressor;

  public constructor(
    private config: AutorestConfiguration,
    private messageEmitter: MessageEmitter,
    private asyncLogManager: LoggingSession,
  ) {
    this.suppressor = new Suppressor(config);
  }

  public verbose(message: string) {
    this.log({
      Channel: Channel.Verbose,
      Text: message,
    });
  }

  public info(message: string) {
    this.log({
      Channel: Channel.Information,
      Text: message,
    });
  }

  public fatal(message: string) {
    this.log({
      Channel: Channel.Fatal,
      Text: message,
    });
  }

  public trackWarning(error: AutorestWarning) {
    this.log({
      Channel: Channel.Warning,
      Text: error.message,
      Source: error.source?.map((x) => ({ document: x.document, Position: x.position as any })),
      Details: error.details,
    });
  }

  public trackError(error: AutorestError) {
    this.log({
      Channel: Channel.Error,
      Text: error.message,
      Source: error.source?.map((x) => ({ document: x.document, Position: x.position as any })),
      Details: error.details,
    });
  }

  public log(message: Message) {
    this.asyncLogManager.registerLog(() => this.sendMessageAsync(message));
  }

  private async sendMessageAsync(m: Message) {
    if (m.Channel === Channel.Debug && !this.config.debug) {
      return;
    }

    if (m.Channel === Channel.Verbose && !this.config.verbose) {
      return;
    }

    try {
      // update source locations to point to loaded Swagger
      if (m.Source && typeof m.Source.map === "function") {
        const sources = await this.resolveOriginalSources(m, m.Source);
        m.Source = this.resolveOriginalDocumentNames(sources);
      }

      // set range (dummy)
      if (m.Source && typeof m.Source.map === "function") {
        m.Range = resolveRanges(m.Source);
      }

      // filter
      const mx = this.suppressor.filter(m);

      // forward
      if (mx !== null) {
        // format message
        switch (this.config["message-format"]) {
          case "json":
            // TODO: WHAT THE FUDGE, check with the consumers whether this has to be like that... otherwise, consider changing the format to something less generic
            if (mx.Details) {
              mx.Details.sources = (mx.Source || [])
                .filter((x) => x.Position)
                .map((source) => {
                  let text = `${source.document}:${source.Position.line}:${source.Position.column}`;
                  if (source.Position.path) {
                    text += ` (${stringify(source.Position.path)})`;
                  }
                  return text;
                });
              if (mx.Details.sources.length > 0) {
                mx.Details["jsonref"] = mx.Details.sources[0];
                mx.Details["json-path"] = mx.Details.sources[0];
              }
            }
            mx.FormattedMessage = JSON.stringify(mx.Details || mx, null, 2);
            break;
          case "yaml":
            mx.FormattedMessage = Stringify([mx.Details || mx]).replace(/^---/, "");
            break;
          default: {
            const t =
              mx.Channel === Channel.Debug || mx.Channel === Channel.Verbose
                ? ` [${Math.floor(process.uptime() * 100) / 100} s]`
                : "";
            let text = `${(mx.Channel || Channel.Information).toString().toUpperCase()}${
              mx.Key ? ` (${[...mx.Key].join("/")})` : ""
            }${t}: ${mx.Text}`;
            for (const source of mx.Source || []) {
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
            mx.FormattedMessage = text;
            break;
          }
        }
        this.messageEmitter.Message.Dispatch(mx);
      }
    } catch (e) {
      this.messageEmitter.Message.Dispatch({ Channel: Channel.Error, Text: `${e}` });
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
            blameTree = await this.messageEmitter.DataStore.blame(s.document, s.Position);
            if (shouldComplain) {
              await this.log({
                Channel: Channel.Verbose,
                Text: `\nDEVELOPER-WARNING: Path '${originalPath}' was corrected to ${JSON.stringify(
                  s.Position.path,
                )} on MESSAGE '${JSON.stringify(message.Text)}'\n`,
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
          Channel: Channel.Debug,
          Text: `Failed to blame ${JSON.stringify(s.Position)} in '${JSON.stringify(s.document)}' (${e})`,
          Details: e,
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
          const document = this.messageEmitter.DataStore.readStrictSync(source.document).description;
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
