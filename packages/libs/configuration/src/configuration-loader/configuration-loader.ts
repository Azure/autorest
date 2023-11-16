import { AutorestLogger, OperationAbortedException } from "@autorest/common";
import { exists, filePath } from "@azure-tools/async-io";
import { DataStore, IFileSystem, RealFileSystem, CachingFileSystem } from "@azure-tools/datastore";
import { Extension, ExtensionManager, LocalExtension, PackageInstallProgress } from "@azure-tools/extension";
import { createFileUri, resolveUri, simplifyUri, fileUriToPath } from "@azure-tools/uri";
import { last } from "lodash";
import untildify from "untildify";
import { AutorestConfiguration } from "../autorest-configuration";
import { AutorestNormalizedConfiguration } from "../autorest-normalized-configuration";
import { detectConfigurationFile } from "../configuration-file-resolver";
import { ConfigurationManager, readConfigurationFile } from "../configuration-manager";
import { autorestConfigurationProcessor, AutorestRawConfiguration } from "../configuration-schema";
import { getIncludedConfigurationFiles } from "./configuration-require-resolver";

export interface AutorestConfigurationResult {
  config: AutorestConfiguration;
  extensions: ResolvedExtension[];
}

export interface ExtensionDefinition {
  name: string;
  source: string;
  fullyQualified: string;
}

export interface ResolvedExtension {
  definition: ExtensionDefinition;
  extension: Extension;
}

export interface ConfigurationLoaderOptions {
  /**
   * Override the file system to use.
   */
  fileSystem?: IFileSystem;

  /**
   * Pass a custom datastore.
   */
  dataStore?: DataStore;

  /**
   * Extension manager to resolve extension configuration. If not provided the extension configuration won't be resolved.
   */
  extensionManager?: ExtensionManager;
}

/**
 * Timeout in ms.
 */
const InstallPackageTimeout = 5 * 60 * 1000;

/**
 * Class handling the loading of an autorest configuration.
 */
export class ConfigurationLoader {
  private fileSystem: CachingFileSystem;
  private dataStore: DataStore;
  private extensionManager: ExtensionManager | undefined;

  /**
   * @param fileSystem File system.
   * @param defaultConfigUri Default configuration Uri. This is the path to the default configuration file.
   * @param configFileOrFolderUri Path to the config file or folder.
   */
  public constructor(
    private logger: AutorestLogger,
    private defaultConfigUri: string,
    private configFileOrFolderUri: string | undefined,
    options: ConfigurationLoaderOptions = {},
  ) {
    const fileSystem = options.fileSystem ?? new RealFileSystem();
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
    this.dataStore = options.dataStore ?? new DataStore({ autoUnloadData: false });
    this.extensionManager = options.extensionManager;
  }

  public async load(
    configs: AutorestRawConfiguration[],
    includeDefault: boolean,
  ): Promise<AutorestConfigurationResult> {
    const configFileUri = this.configFileOrFolderUri
      ? await detectConfigurationFile(this.fileSystem, this.configFileOrFolderUri, this.logger)
      : undefined;

    const configFileFolderUri = configFileUri
      ? resolveUri(configFileUri, "./")
      : this.configFileOrFolderUri || "file:///";

    const manager = new ConfigurationManager(configFileFolderUri, this.fileSystem);

    const resolveConfig = () => manager.resolveConfig();
    const addedConfigs = new Set<string>();

    const loadConfigFile = async (fileUri: string, fsToUse: IFileSystem) => {
      return this.loadConfigFile(fileUri, fsToUse, manager, addedConfigs);
    };

    const resolveRequiredConfigs = async (fsToUse: IFileSystem) => {
      return this.resolveRequiredConfigs(manager, fsToUse, addedConfigs);
    };

    // 1. overrides (CLI, ...)
    // await addSegments(configs, false);
    for (const rawConfig of configs) {
      const result = autorestConfigurationProcessor.processConfiguration(rawConfig, { logger: this.logger });
      if ("errors" in result) {
        for (const error of result.errors) {
          this.logger.trackError({
            code: error.code,
            message: error.message,
          });
        }
        throw new OperationAbortedException();
      }
      await manager.addConfig(result.value);
    }
    await resolveRequiredConfigs(this.fileSystem);
    // 2. file
    if (configFileUri != null && configFileUri !== undefined) {
      // add loaded files to the input files.
      this.logger.verbose(`> Initial configuration file '${configFileUri}'`);
      await loadConfigFile(configFileUri, this.fileSystem);
    }

    // 3. default configuration
    const fsLocal = new RealFileSystem();
    if (includeDefault) {
      await loadConfigFile(this.defaultConfigUri, fsLocal);
    }

    // 4. resolve extensions
    const extensions: ResolvedExtension[] = [];
    if (this.extensionManager) {
      const addedExtensions = new Set<string>();
      const viewsToHandle: AutorestNormalizedConfiguration[] = [await resolveConfig()];
      while (viewsToHandle.length > 0) {
        const config = viewsToHandle.pop() as AutorestNormalizedConfiguration;
        const extensionDefs = resolveExtensions(config);

        const additionalExtensions = extensionDefs.filter((ext) => !addedExtensions.has(ext.fullyQualified));
        await manager.addConfig({ "used-extension": additionalExtensions.map((x) => x.fullyQualified) });
        if (additionalExtensions.length === 0) {
          continue;
        }

        // acquire additional extensions
        for (const additionalExtension of additionalExtensions) {
          try {
            addedExtensions.add(additionalExtension.fullyQualified);

            const extension = await this.resolveExtension(this.extensionManager, additionalExtension);
            extensions.push({ extension, definition: additionalExtension });

            // merge config from extension
            const extensionConfigurationUri = simplifyUri(createFileUri(await extension.configurationPath));
            this.logger.verbose(`> Including extension configuration file '${extensionConfigurationUri}'`);
            await loadConfigFile(extensionConfigurationUri, fsLocal);

            viewsToHandle.push(await resolveConfig());
          } catch (e) {
            this.logger.fatal(
              `Failed to install extension '${additionalExtension.name}' (${additionalExtension.source})`,
            );
            throw e;
          }
        }
        await resolveRequiredConfigs(fsLocal);
      }
    }

    // resolve any outstanding includes again
    await resolveRequiredConfigs(fsLocal);
    const config = await manager.resolveConfig();
    // If the pipeline-model was set we set it at the beginning and reload the config.
    // There is some configuration in `default-configuration.md` that depends on pipeline-model but some plugins are setting up pipeline-model.

    // Perform-load false disable the loaders(swagger, openapi3, cadl.)
    // Default should be true. Check if it not set first and if allow-no-input is not there.
    if (config["perform-load"] === undefined) {
      if (!config["allow-no-input"] && !config["help"]) {
        await manager.addConfig({ "perform-load": true });
      }
    }

    if (config["pipeline-model"]) {
      await manager.addHighPriorityConfig({ "pipeline-model": config["pipeline-model"] });
    }
    return { config: await manager.resolveConfig(), extensions };
  }

  /**
   * Load the given configuration file and recursively load all required configs.
   * @param fileUri Uri to the configuration file to load.
   * @param fsToUse File system to use to load the configuration files.
   * @param manager Configuration manager
   * @param alreadyAddedConfigs Set of already loaded configuration files.
   */
  private async loadConfigFile(
    fileUri: string,
    fsToUse: IFileSystem,
    manager: ConfigurationManager,
    alreadyAddedConfigs: Set<string>,
  ) {
    this.logger.verbose(`> Including configuration file '${fileUri}'`);
    const data = await this.dataStore.getReadThroughScope(fsToUse).readStrict(fileUri);
    const file = await readConfigurationFile(data, this.logger, this.dataStore.getDataSink());
    manager.addConfigFile(file);

    await this.resolveRequiredConfigs(manager, fsToUse, alreadyAddedConfigs);
  }

  /**
   * Resolve the required configurations that haven't been loaded yet.
   * @param manager Configuration manager.
   * @param fsToUse Filesystem to use to load unloaded configs.
   * @param alreadyAddedConfigs List of configuration already loaded.
   */
  private async resolveRequiredConfigs(
    manager: ConfigurationManager,
    fsToUse: IFileSystem,
    alreadyAddedConfigs: Set<string>,
  ) {
    for await (let additionalConfig of getIncludedConfigurationFiles(
      () => manager.resolveConfig(),
      fsToUse,
      alreadyAddedConfigs,
    )) {
      // acquire additional configs
      try {
        additionalConfig = simplifyUri(additionalConfig);

        this.logger.verbose(`> Including configuration file '${additionalConfig}'`);
        alreadyAddedConfigs.add(additionalConfig);
        // merge config

        const inputView = this.dataStore.getReadThroughScope(fsToUse);
        const data = await inputView.readStrict(additionalConfig);
        manager.addConfigFile(await readConfigurationFile(data, this.logger, this.dataStore.getDataSink()));
      } catch (e) {
        this.logger.fatal(`Failed to acquire 'require'd configuration '${additionalConfig}'`);

        throw e;
      }
    }
  }
  /**
   * Returns the @see Extension object for the requested extension.
   * @param extensionDef extension definition.
   * @param messageFormat message format.
   */
  private async resolveExtension(extMgr: ExtensionManager, extensionDef: ExtensionDefinition): Promise<Extension> {
    let localPath = untildify(extensionDef.source);

    // try resolving the package locally (useful for self-contained)
    try {
      const fileProbe = "/package.json";
      localPath = require.resolve(extensionDef.name + fileProbe); // have to resolve specific file - resolving a package by name will fail if no 'main' is present
      localPath = localPath.slice(0, localPath.length - fileProbe.length);
    } catch {
      // no worries
    }

    // trim off the '@org' and 'autorest.' from the name.
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const shortname = last(extensionDef.name.split("/"))!.replace(/^autorest\./gi, "");

    // Add a hint here to make legacy users to be aware that the default version has been bumped to 3.0+.
    if (shortname === "powershell") {
      this.logger.info(
        `\n## The default version of @autorest/powershell has been bumped from 3.0+ to 4.0+.\n > If you still want to use 3.0+ version, please specify it with --use:@autorest/powershell@3.0.{x}, e.g 3.0.512.\n`,
      );
    }

    if ((await exists(localPath)) && !localPath.endsWith(".tgz")) {
      localPath = filePath(localPath);
      // local package
      this.logger.info(`> Loading local AutoRest extension '${extensionDef.name}' (${localPath})`);

      const pack = await extMgr.findPackage(extensionDef.name, localPath);
      return new LocalExtension(pack, localPath);
    } else {
      // remote package`
      const installedExtension = await extMgr.getInstalledExtension(extensionDef.name, extensionDef.source);
      if (installedExtension) {
        this.logger.info(
          `> Loading AutoRest extension '${extensionDef.name}' (${extensionDef.source}->${installedExtension.version})`,
        );
        return installedExtension;
      } else {
        // acquire extension
        const pack = await extMgr.findPackage(extensionDef.name, extensionDef.source);
        this.logger.info(
          `> Installing AutoRest extension '${extensionDef.name}' (${extensionDef.source} -> ${pack.version})`,
        );
        const progress = this.logger.startProgress("installing...");
        try {
          const extension = await extMgr.installPackage(
            pack,
            false,
            InstallPackageTimeout,
            (status: PackageInstallProgress) => {
              progress.update({ ...status });
            },
          );
          progress.stop();

          this.logger.info(
            `> Installed AutoRest extension '${extensionDef.name}' (${extensionDef.source}->${extension.version})`,
          );
          return extension;
        } catch (e) {
          progress.stop();
          throw e;
        }
      }
    }
  }
}

const resolveExtensions = (config: AutorestNormalizedConfiguration): ExtensionDefinition[] => {
  const useExtensions = config["use-extension"] || {};
  return Object.keys(useExtensions).map((name) => {
    const source = useExtensions[name].startsWith("file://") ? fileUriToPath(useExtensions[name]) : useExtensions[name];
    return {
      name,
      source,
      fullyQualified: JSON.stringify([name, source]),
    };
  });
};
