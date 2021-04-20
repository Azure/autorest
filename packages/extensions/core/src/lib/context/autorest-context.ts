import { DataStore, CachingFileSystem } from "@azure-tools/datastore";
import { clone } from "@azure-tools/linq";
import { From } from "linq-es2015";
import { basename, dirname } from "path";
import { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";
import { Artifact } from "../artifact";
import {
  AutorestNormalizedConfiguration,
  getNestedConfiguration,
  ResolvedDirective,
  resolveDirectives,
} from "@autorest/configuration";
import { MessageEmitter } from "./message-emitter";
import { IEvent } from "../events";
import { AutorestConfiguration, arrayOf, extendAutorestConfiguration } from "@autorest/configuration";
import { AutorestError, AutorestLogger, AutorestWarning } from "@autorest/common";
import { Message } from "../message";
import { AutorestCoreLogger } from "./logger";
import { VERSION } from "../constants";
import { StatsCollector } from "../stats";
import { LoggingSession } from "./logging-session";
import { PipelinePluginDefinition } from "../pipeline/plugin-loader";

export class AutorestContext implements AutorestLogger {
  public config: AutorestConfiguration;
  public configFileFolderUri: string;
  private logger: AutorestCoreLogger;

  public constructor(
    config: AutorestConfiguration,
    public fileSystem: CachingFileSystem,
    public messageEmitter: MessageEmitter,
    public stats: StatsCollector,
    public asyncLogManager: LoggingSession,
    private plugin?: PipelinePluginDefinition,
  ) {
    this.config = config;
    this.logger = new AutorestCoreLogger(config, messageEmitter, asyncLogManager);
    this.configFileFolderUri = config.configFileFolderUri;
  }

  /**
   * @deprecated Use .config.raw instead. Keeping this for backward compatibility in the `autorest` module.
   */
  public get rawConfig() {
    return this.config.raw;
  }

  public verbose(message: string) {
    this.logger.verbose(message);
  }

  public info(message: string) {
    this.logger.info(message);
  }

  public fatal(message: string) {
    this.logger.fatal(message);
  }

  public trackError(error: AutorestError) {
    this.logger.trackError(error);
  }

  public trackWarning(error: AutorestWarning) {
    this.logger.trackWarning(error);
  }

  public Message(m: Message) {
    void this.logger.log(m);
  }

  public resolveDirectives(predicate?: (each: ResolvedDirective) => boolean) {
    return resolveDirectives(this.config, predicate);
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

  public get HeaderText(): string {
    const h = this.config["header-definitions"];

    const defaultText = this.getDefaultHeaderText();
    switch (this.config["license-header"]?.toLowerCase()) {
      case "microsoft_mit":
        return `${h.microsoft}\n${h.mit}\n${defaultText}\n${h.warning}`;

      case "microsoft_apache":
        return `${h.microsoft}\n${h.apache}\n${defaultText}\n${h.warning}`;

      case "microsoft_mit_no_version":
        return `${h.microsoft}\n${h.mit}\n${h["no-version"]}\n${h.warning}`;

      case "microsoft_apache_no_version":
        return `${h.microsoft}\n${h.apache}\n${h["no-version"]}${h.warning}`;

      case "microsoft_apache_no_codegen":
        return `${h.microsoft}\n${h.mit}\n${h["no-version"]}`;

      case "none":
        return "";

      case "microsoft_mit_small":
        return `${h.microsoft}\n${h["mit-small"]}\n${defaultText}\n${h.warning}`;

      case "microsoft_mit_small_no_codegen":
        return `${h.microsoft}\n${h["mit-small"]}\n${h["no-version"]}`;

      case null:
      case undefined:
        return `${defaultText}\n${h.warning}`;

      default:
        return `${this.config["license-header"]}`;
    }
  }

  private getDefaultHeaderText() {
    const extension = this.plugin?.extension;
    const generator = extension ? `${extension?.extensionName}@${extension?.extensionVersion}` : "";
    return this.config["header-definitions"].default.replace("{core}", VERSION).replace("{generator}", generator);
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
      return resolveDirectives(this.config);
    }

    // This key is used in pipelines plugins to retrieve the headertext.
    if (key === "header-text") {
      return this.HeaderText;
    }

    let result = this.config;
    for (const keyPart of key.split(".")) {
      result = result[keyPart as keyof AutorestConfiguration];
    }
    return result;
  }

  /**
   * Get a new configuration that is extended with the properties under the given scope.
   * @param scope Name of the nested property to flatten.
   * @param plugin Optional plugin requesting this configuration.
   */
  public *getNestedConfiguration(scope: string, plugin?: PipelinePluginDefinition): Iterable<AutorestContext> {
    for (const nestedConfig of getNestedConfiguration(this.config, scope)) {
      yield new AutorestContext(
        nestedConfig,
        this.fileSystem,
        this.messageEmitter,
        this.stats,
        this.asyncLogManager,
        plugin,
      );
    }
  }

  /**
   * Returns a new Autorest context with the configuration extended with the provided configurations.
   * @param overrides List of configs to override
   */
  public extendWith(...overrides: AutorestNormalizedConfiguration[]): AutorestContext {
    const nestedConfig = extendAutorestConfiguration(this.config, overrides);
    return new AutorestContext(
      nestedConfig,
      this.fileSystem,
      this.messageEmitter,
      this.stats,
      this.asyncLogManager,
      this.plugin,
    );
  }
}
