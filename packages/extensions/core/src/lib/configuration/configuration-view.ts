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
import { EnsureIsFolderUri, ResolveUri, IsUri, FileUriToPath, CreateFileOrFolderUri } from "@azure-tools/uri";
import { From } from "linq-es2015";
import { basename, dirname } from "path";
import { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";
import { Artifact } from "../artifact";
import { Channel, Message, Range, SourceLocation } from "../message";
import { Suppressor } from "../pipeline/suppression";
import { cwd } from "process";
import { Directive, ResolvedDirective } from "./directive";
import { AutoRestRawConfiguration, mergeConfiguration, mergeConfigurations } from "./auto-rest-raw-configuration";
import { arrayOf, valuesOf } from "./utils";
import { CachingFileSystem } from "./caching-file-system";
import { MessageEmitter } from "./message-emitter";
import { IEvent } from "../events";
import {
  AutorestConfiguration,
  createAutorestConfiguration,
  getNestedAutorestConfiguration,
} from "./autorest-configuration";

const safeEval = createSandbox();

export const createAutorestContext = async (
  configurationFiles: { [key: string]: any },
  fileSystem: IFileSystem,
  messageEmitter: MessageEmitter,
  configFileFolderUri: string,
  ...configs: AutoRestRawConfiguration[]
): Promise<AutorestContext> => {
  const config = await createAutorestConfiguration(configurationFiles, configs);
  return new AutorestContext(config, fileSystem, messageEmitter, configFileFolderUri);
};

export class AutorestContext {
  public config: AutorestConfiguration;

  public fileSystem: CachingFileSystem;

  private suppressor: Suppressor;

  public constructor(
    config: AutorestConfiguration,
    fileSystem: IFileSystem,
    public messageEmitter: MessageEmitter,
    public configFileFolderUri: string,
  ) {
    this.config = config;
    // wrap the filesystem with the caching filesystem
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);

    this.suppressor = new Suppressor(this);
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

  private ResolveAsFolder(path: string): string {
    return EnsureIsFolderUri(ResolveUri(this.BaseFolderUri, path));
  }
  private ResolveAsWriteableFolder(path: string): string {
    // relative paths are relative to the local folder when the base-folder is remote.
    if (!this.BaseFolderUri.startsWith("file:")) {
      return EnsureIsFolderUri(ResolveUri(CreateFileOrFolderUri(cwd() + "/"), path));
    }
    return this.ResolveAsFolder(path);
  }

  private ResolveAsPath(path: string): Promise<string> {
    // is there even a potential for a parent folder from the input configuruation
    const parentFolder = this.config?.__parents?.[path];
    const fromBaseUri = ResolveUri(this.BaseFolderUri, path);

    // if it's an absolute uri already, give it back that way.
    if (IsUri(path) || !parentFolder) {
      return Promise.resolve(fromBaseUri);
    }

    // let it try relative to the file that loaded it.
    // if the relative-to-parent path isn't valid, we fall back to original behavior
    // where the file path is relative to the base uri.
    // (and we don't even check to see if that's valid, try-require wouldn't need valid files)
    const fromLoadedFile = ResolveUri(parentFolder, path);
    return this.fileSystem.ReadFile(fromLoadedFile).then(
      () => fromLoadedFile,
      () => fromBaseUri,
    );
  }

  private get BaseFolderUri(): string {
    return EnsureIsFolderUri(ResolveUri(this.configFileFolderUri, <string>this.config["base-folder"]));
  }

  // public methods

  public get UseExtensions(): Array<{ name: string; source: string; fullyQualified: string }> {
    const useExtensions = this.config["use-extension"] || {};
    return Object.keys(useExtensions).map((name) => {
      const source = useExtensions[name].startsWith("file://")
        ? FileUriToPath(useExtensions[name])
        : useExtensions[name];
      return {
        name,
        source,
        fullyQualified: JSON.stringify([name, source]),
      };
    });
  }

  public static async *getIncludedConfigurationFiles(
    configView: () => Promise<AutorestContext>,
    fileSystem: IFileSystem,
    ignoreFiles: Set<string>,
  ) {
    let done = false;

    while (!done) {
      // get a fresh copy of the view every time we start the loop.
      const view = await configView();

      // if we make it thru the list, we're done.
      done = true;
      for (const each of valuesOf<string>(view.config["require"])) {
        if (ignoreFiles.has(each)) {
          continue;
        }

        // looks like we found one that we haven't handled yet.
        done = false;
        ignoreFiles.add(each);
        yield await view.ResolveAsPath(each);
        break;
      }
    }

    done = false;
    while (!done) {
      // get a fresh copy of the view every time we start the loop.
      const view = await configView();

      // if we make it thru the list, we're done.
      done = true;
      for (const each of valuesOf<string>(view.config["try-require"])) {
        if (ignoreFiles.has(each)) {
          continue;
        }

        // looks like we found one that we haven't handled yet.
        done = false;
        ignoreFiles.add(each);
        const path = await view.ResolveAsPath(each);
        try {
          if (await fileSystem.ReadFile(path)) {
            yield path;
          }
        } catch {
          // do nothing
        }

        break;
      }
    }
  }

  public resolveDirectives(predicate?: (each: ResolvedDirective) => boolean) {
    // optionally filter by predicate.
    const plainDirectives = values(valuesOf<Directive>(this.config["directive"]));
    // predicate ? values(valuesOf<Directive>(this.config['directive'])).where(predicate) : values(valuesOf<Directive>(this.config['directive']));

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

  public get OutputFolderUri(): string {
    return this.ResolveAsWriteableFolder(<string>this.config["output-folder"]);
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
    return From(valuesOf<string>(this.config["output-artifact"])).Contains(artifact);
  }

  public GetEntry(key: string): any {
    if (!key) {
      return clone(this.config);
    }
    if (key === "resolved-directive") {
      return this.resolveDirectives();
    }
    if (<any>key === "header-text") {
      return this.HeaderText;
    }
    let result = <any>this.config;
    for (const keyPart of key.split(".")) {
      result = result[keyPart];
    }
    return result;
  }

  public get Raw(): AutoRestRawConfiguration {
    return this.config;
  }

  public get DebugMode(): boolean {
    return !!this.config["debug"];
  }

  public get CacheMode(): boolean {
    return !!this.config["cache"];
  }

  public get CacheExclude(): Array<string> {
    const cache = this.config["cache"];
    if (cache && cache.exclude) {
      return [...valuesOf<string>(cache.exclude)];
    }
    return [];
  }

  public get VerboseMode(): boolean {
    return !!this.config["verbose"];
  }

  public get HelpRequested(): boolean {
    return !!this.config["help"];
  }

  public *GetNestedConfiguration(pluginName: string): Iterable<AutorestContext> {
    const pp = pluginName.split(".");
    if (pp.length > 1) {
      const n = this.GetNestedConfiguration(pp[0]);
      for (const s of n) {
        yield* s.GetNestedConfiguration(pp.slice(1).join("."));
      }
      return;
    }

    for (const section of valuesOf<any>((<any>this.config)[pluginName])) {
      if (section) {
        yield this.GetNestedConfigurationImmediate(section === true ? {} : section);
      }
    }
  }

  public GetNestedConfigurationImmediate(...scopes: Array<any>): AutorestContext {
    const nestedConfig = getNestedAutorestConfiguration(this.config, scopes);
    const c = new AutorestContext(nestedConfig, this.fileSystem, this.messageEmitter, this.configFileFolderUri);
    return c;
  }

  // message pipeline (source map resolution, filter, ...)
  public async Message(m: Message): Promise<void> {
    if (m.Channel === Channel.Debug && !this.DebugMode) {
      return;
    }

    if (m.Channel === Channel.Verbose && !this.VerboseMode) {
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
