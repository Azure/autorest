import { basename, dirname } from "path";
import {
  AutorestError,
  FilterLogger,
  AutorestLogger,
  AutorestWarning,
  LogInfo,
  LogLevel,
  LogSuppression,
  IAutorestLogger,
} from "@autorest/common";
import {
  AutorestNormalizedConfiguration,
  getNestedConfiguration,
  ResolvedDirective,
  resolveDirectives,
  AutorestConfiguration,
  arrayOf,
  extendAutorestConfiguration,
  getLogLevel,
} from "@autorest/configuration";

import { DataStore, CachingFileSystem } from "@azure-tools/datastore";
import { cloneDeep } from "lodash";
import { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";
import { Artifact } from "../artifact";
import { VERSION } from "../constants";
import { IEvent } from "../events";
import { PipelinePluginDefinition } from "../pipeline/plugin-loader";
import { StatsCollector } from "../stats";
import { MessageEmitter } from "./message-emitter";

export class AutorestContext implements IAutorestLogger {
  public config: AutorestConfiguration;
  public configFileFolderUri: string;
  public logger: AutorestLogger;
  private originalLogger: AutorestLogger;

  public constructor(
    config: AutorestConfiguration,
    public fileSystem: CachingFileSystem,
    public messageEmitter: MessageEmitter,
    logger: AutorestLogger,
    public stats: StatsCollector,
    private plugin?: PipelinePluginDefinition,
  ) {
    this.config = config;
    this.originalLogger = logger;
    this.logger = logger.with(
      new FilterLogger({
        level: getLogLevel(config),
        suppressions: getLogSuppressions(config),
      }),
    );

    this.configFileFolderUri = config.configFileFolderUri;
  }

  public get pluginName() {
    return this.plugin?.name;
  }
  /**
   * @deprecated Use .config.raw instead. Keeping this for backward compatibility in the `autorest` module.
   */
  public get rawConfig() {
    return this.config.raw;
  }

  public debug(message: string) {
    this.logger.debug(message);
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

  public log(log: LogInfo) {
    this.logger.log({
      pluginName: this.plugin?.name,
      extensionName: this.plugin?.extension?.extensionName,
      ...log,
    });
  }

  public startProgress(initialName?: string) {
    return this.logger.startProgress(initialName);
  }

  public get diagnostics() {
    return this.logger.diagnostics;
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
    return arrayOf<string>(this.config["output-artifact"]).includes(artifact);
  }

  /**
   * Returns the config value at the given path.
   * @param key Path to the config;
   */
  public GetEntry(key: string): any {
    if (!key) {
      return cloneDeep(this.config);
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
        this.originalLogger,
        this.stats,
        plugin,
      );
    }
  }

  public getContextForPlugin(plugin: PipelinePluginDefinition) {
    return new AutorestContext(
      this.config,
      this.fileSystem,
      this.messageEmitter,
      this.originalLogger,
      this.stats,
      plugin,
    );
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
      this.originalLogger,
      this.stats,
      this.plugin,
    );
  }

  public protectFiles(filename: string) {
    this.messageEmitter.ProtectFile.Dispatch(filename);
  }
}

export function getLogSuppressions(config: AutorestConfiguration): LogSuppression[] {
  const legacySuppressions: LogSuppression[] = resolveDirectives(config, (x) => x.suppress.length > 0).map((x) => {
    return {
      code: x.suppress.join("/"),
      from: x.from,
      where: x.where,
    };
  });

  return [...(config.suppressions ?? []), ...legacySuppressions];
}
