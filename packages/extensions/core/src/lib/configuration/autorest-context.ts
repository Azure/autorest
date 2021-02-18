import {
  BlameTree,
  DataStore,
  IFileSystem,
  createSandbox,
  Stringify,
  stringify,
  TryDecodeEnhancedPositionFromName,
} from "@azure-tools/datastore";
import { clone, values } from "@azure-tools/linq";
import { From } from "linq-es2015";
import { basename, dirname } from "path";
import { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";
import { Artifact } from "../artifact";
import { Channel, Message, Range, SourceLocation } from "../message";
import { Suppressor } from "../pipeline/suppression";
import { Directive, ResolvedDirective, CachingFileSystem } from "@autorest/configuration";
import { MessageEmitter } from "./message-emitter";
import { IEvent } from "../events";
import {
  AutorestConfiguration,
  AutorestRawConfiguration,
  arrayOf,
  createAutorestConfiguration,
  extendAutorestConfiguration,
} from "@autorest/configuration";
import { AutorestError, AutorestLogger } from "@autorest/common";

const safeEval = createSandbox();

export const createAutorestContext = async (
  configurationFiles: { [key: string]: any },
  fileSystem: IFileSystem,
  messageEmitter: MessageEmitter,
  configFileFolderUri: string,
  ...configs: AutorestRawConfiguration[]
): Promise<AutorestContext> => {
  const cachingFs = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
  const config = await createAutorestConfiguration(configFileFolderUri, configurationFiles, configs, cachingFs);
  return new AutorestContext(config, cachingFs, messageEmitter, configFileFolderUri);
};

export class AutorestContext implements AutorestLogger {
  public config: AutorestConfiguration;

  private suppressor: Suppressor;

  public constructor(
    config: AutorestConfiguration,
    public fileSystem: CachingFileSystem,
    public messageEmitter: MessageEmitter,
    public configFileFolderUri: string,
  ) {
    this.config = config;
    this.suppressor = new Suppressor(this);
  }

  /**
   * @deprecated Use .config.raw instead. Keeping this for backward compatibility in the `autorest` module.
   */
  public get rawConfig() {
    return this.config.raw;
  }

  public verbose(message: string) {
    this.Message({
      Channel: Channel.Verbose,
      Text: message,
    });
  }

  public trackError(error: AutorestError) {
    this.Message({
      Channel: Channel.Error,
      Text: error.message,
      Source: error.source?.map((x) => ({ document: x.document, Position: x.position })),
    });
  }

  public updateConfigurationFile(filename: string, content: string) {
    // only name itself is allowed here, no path
    filename = basename(filename);

    const keys = Object.getOwnPropertyNames(this.config.configurationFiles);

    if (keys && keys.length > 0) {
      const path = dirname(keys[0]);
      if (path.startsWith("file://")) {
        // the configuration is a file path
        // we can save the configuration file to the target location
        this.GeneratedFile.Dispatch({ content, type: "configuration", uri: `${path}/${filename}` });
      }
    }
  }

  public Dump(title = ""): void {
    // eslint-disable-next-line no-console
    console.log(`\n${title}\n===================================`);
    for (const each of Object.getOwnPropertyNames(this.config)) {
      // eslint-disable-next-line no-console
      console.log(`${each} : ${(<any>this.config)[each]}`);
    }
  }

  /* @internal */ public get DataStore(): DataStore {
    return this.messageEmitter.DataStore;
  }
  /* @internal */ public get CancellationToken(): CancellationToken {
    return this.messageEmitter.CancellationToken;
  }
  /* @internal */ public get CancellationTokenSource(): CancellationTokenSource {
    return this.messageEmitter.CancellationTokenSource;
  }
  /* @internal */ public get GeneratedFile(): IEvent<MessageEmitter, Artifact> {
    return this.messageEmitter.GeneratedFile;
  }
  /* @internal */ public get ClearFolder(): IEvent<MessageEmitter, string> {
    return this.messageEmitter.ClearFolder;
  }

  public resolveDirectives(predicate?: (each: ResolvedDirective) => boolean): ResolvedDirective[] {
    // optionally filter by predicate.
    const plainDirectives = values(arrayOf<Directive>(this.config["directive"]));

    const declarations = this.config["declare-directive"] || {};
    const expandDirective = (dir: Directive): Iterable<Directive> => {
      const makro = Object.keys(dir).filter((m) => declarations[m])[0];
      // const makro = keys(dir).first(m => !!declarations[m]);
      if (!makro) {
        return [dir]; // nothing to expand
      }
      // prepare directive
      let parameters = (<any>dir)[makro];
      if (!Array.isArray(parameters)) {
        parameters = [parameters];
      }
      dir = { ...dir };
      delete (<any>dir)[makro];
      // call makro
      const makroResults: any = From(parameters)
        .SelectMany((parameter) => {
          const result = safeEval(declarations[makro], { $: parameter, $context: dir });
          return Array.isArray(result) ? result : [result];
        })
        .ToArray();
      return From(makroResults).SelectMany((result: any) => expandDirective({ ...result, ...dir }));
    };
    // makro expansion
    if (predicate) {
      return plainDirectives
        .selectMany(expandDirective)
        .select((each) => new ResolvedDirective(each))
        .where(predicate)
        .toArray();
    }
    return plainDirectives
      .selectMany(expandDirective)
      .select((each) => new ResolvedDirective(each))
      .toArray();
    // return From(plainDirectives).SelectMany(expandDirective).Select(each => new StaticDirectiveView(each)).ToArray();
  }

  public get HeaderText(): string {
    const h = this.config["header-definitions"];
    const version = (<any>global).autorestVersion;

    switch (this.config["license-header"]?.toLowerCase()) {
      case "microsoft_mit":
        return `${h.microsoft}\n${h.mit}\n${h.default.replace("{core}", version)}\n${h.warning}`;

      case "microsoft_apache":
        return `${h.microsoft}\n${h.apache}\n${h.default.replace("{core}", version)}\n${h.warning}`;

      case "microsoft_mit_no_version":
        return `${h.microsoft}\n${h.mit}\n${h["no-version"]}\n${h.warning}`;

      case "microsoft_apache_no_version":
        return `${h.microsoft}\n${h.apache}\n${h["no-version"]}${h.warning}`;

      case "microsoft_apache_no_codegen":
        return `${h.microsoft}\n${h.mit}\n${h["no-version"]}`;

      case "none":
        return "";

      case "microsoft_mit_small":
        return `${h.microsoft}\n${h["mit-small"]}\n${h.default.replace("{core}", version)}\n${h.warning}`;

      case "microsoft_mit_small_no_codegen":
        return `${h.microsoft}\n${h["mit-small"]}\n${h["no-version"]}`;

      case null:
      case undefined:
        return `${h.default.replace("{core}", version)}\n${h.warning}`;

      default:
        return `${this.config["license-header"]}`;
    }
  }

  public IsOutputArtifactRequested(artifact: string): boolean {
    return From(arrayOf<string>(this.config["output-artifact"])).Contains(artifact);
  }

  /**
   * Returns the config value at the given path.
   * @param key Path to the config;
   */
  public GetEntry(key: string): any {
    if (!key) {
      return clone(this.config);
    }

    if (key === "resolved-directive") {
      return this.resolveDirectives();
    }

    let result = this.config;
    for (const keyPart of key.split(".")) {
      result = result[keyPart];
    }
    return result;
  }

  public *getNestedConfiguration(pluginName: string): Iterable<AutorestContext> {
    const pp = pluginName.split(".");
    if (pp.length > 1) {
      const n = this.getNestedConfiguration(pp[0]);
      for (const s of n) {
        yield* s.getNestedConfiguration(pp.slice(1).join("."));
      }
      return;
    }

    for (const section of arrayOf<any>(this.config.raw[pluginName])) {
      if (section) {
        yield this.extendWith(section === true ? {} : section);
      }
    }
  }

  /**
   * Returns a new Autorest context with the configuration extended with the provided configurations.
   * @param overrides List of configs to override
   */
  public extendWith(...overrides: AutorestRawConfiguration[]): AutorestContext {
    const nestedConfig = extendAutorestConfiguration(this.config, overrides);
    return new AutorestContext(nestedConfig, this.fileSystem, this.messageEmitter, this.configFileFolderUri);
  }

  // message pipeline (source map resolution, filter, ...)
  public async Message(m: Message): Promise<void> {
    if (m.Channel === Channel.Debug && !this.config.debug) {
      return;
    }

    if (m.Channel === Channel.Verbose && !this.config.verbose) {
      return;
    }

    try {
      // update source locations to point to loaded Swagger
      if (m.Source && typeof m.Source.map === "function") {
        const blameSources = m.Source.map(async (s) => {
          let blameTree: BlameTree | null = null;

          try {
            const originalPath = JSON.stringify(s.Position.path);
            let shouldComplain = false;
            while (blameTree === null) {
              try {
                blameTree = await this.DataStore.Blame(s.document, s.Position);
                if (shouldComplain) {
                  this.Message({
                    Channel: Channel.Verbose,
                    Text: `\nDEVELOPER-WARNING: Path '${originalPath}' was corrected to ${JSON.stringify(
                      s.Position.path,
                    )} on MESSAGE '${JSON.stringify(m.Text)}'\n`,
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
            /*
      GS01: This should be restored when we go 'release'

    this.Message({
      Channel: Channel.Warning,
      Text: `Failed to blame ${JSON.stringify(s.Position)} in '${JSON.stringify(s.document)}' (${e})`,
      Details: e
    });
    */
            return [s];
          }

          return blameTree.BlameLeafs().map(
            (r) =>
              <SourceLocation>{
                document: r.source,
                Position: { ...TryDecodeEnhancedPositionFromName(r.name), line: r.line, column: r.column },
              },
          );
        });

        const src = From(await Promise.all(blameSources))
          .SelectMany((x) => x)
          .ToArray();
        m.Source = src;
        // m.Source = From(blameSources).SelectMany(x => x).ToArray();
        // get friendly names
        for (const source of src) {
          if (source.Position) {
            try {
              source.document = this.DataStore.ReadStrictSync(source.document).Description;
            } catch {
              // no worries
            }
          }
        }
      }

      // set range (dummy)
      if (m.Source && typeof m.Source.map === "function") {
        m.Range = m.Source.map((s) => {
          const positionStart = s.Position;
          const positionEnd = <sourceMap.Position>{
            line: s.Position.line,
            column: s.Position.column + (s.Position.length || 3),
          };

          return <Range>{
            document: s.document,
            start: positionStart,
            end: positionEnd,
          };
        });
      }

      // filter
      const mx = this.suppressor.filter(m);

      // forward
      if (mx !== null) {
        // format message
        switch (this.GetEntry("message-format")) {
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
}
