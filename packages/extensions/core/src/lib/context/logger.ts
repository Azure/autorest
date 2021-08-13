import { Channel, Message, Range, SourceLocation } from "../message";
import { stringify } from "@azure-tools/datastore";
import { AutorestError, AutorestWarning } from "@autorest/common";
import { AutorestConfiguration } from "@autorest/configuration";
import { Suppressor } from "../pipeline/suppression";
import { MessageEmitter } from "./message-emitter";
import { LoggingSession } from "./logging-session";
import { Position } from "source-map";

export class AutorestCoreLogger {
  private suppressor: Suppressor;

  public constructor(
    private config: AutorestConfiguration,
    private messageEmitter: MessageEmitter,
    private asyncLogManager: LoggingSession,
  ) {
    this.suppressor = new Suppressor(config);
  }

  public debug(message: string) {
    this.log({
      Channel: Channel.Debug,
      Text: message,
    });
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
      Key: [error.code],
      Text: error.message,
      Source: error.source?.map((x) => ({ document: x.document, Position: x.position as any })),
      Details: error.details,
    });
  }

  public trackError(error: AutorestError) {
    this.log({
      Channel: Channel.Error,
      Key: [error.code],
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
}
