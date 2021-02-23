import { CancellationToken, DataStore, IFileSystem, RealFileSystem } from "@azure-tools/datastore";
import { Extension, ExtensionManager, LocalExtension } from "@azure-tools/extension";
import { CreateFileUri, ResolveUri, simplifyUri, FileUriToPath } from "@azure-tools/uri";
import { AutorestLogger } from "@autorest/common";
import untildify from "untildify";
import { CachingFileSystem } from "../caching-file-system";
import { AutorestConfiguration } from "../autorest-configuration";
import { detectConfigurationFile } from "../configuration-file-resolver";
import { ConfigurationManager, readConfigurationFile } from "../configuration-manager";
import { getIncludedConfigurationFiles } from "./configuration-require-resolver";
import { AutorestRawConfiguration } from "../autorest-raw-configuration";
import { exists, filePath } from "@azure-tools/async-io";

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

  /**
   * Default configuration Uri. This is the path to the default configuration file.
   */
  defaultConfigUri?: string;
}

/**
 * Class handling the loading of an autorest configuration.
 */
export class ConfigurationLoader {
  private fileSystem: CachingFileSystem;
  private dataStore: DataStore;
  private extensionManager: ExtensionManager | undefined;
  private defaultConfigUri: string | undefined;

  /**
   * @param fileSystem File system.
   * @param configFileOrFolderUri Path to the config file or folder.
   */
  public constructor(
    private logger: AutorestLogger,
    private configFileOrFolderUri: string | undefined,
    options: ConfigurationLoaderOptions = {},
  ) {
    const fileSystem = options.fileSystem ?? new RealFileSystem();
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
    this.dataStore = options.dataStore ?? new DataStore({ isCancellationRequested: false } as any);
    this.extensionManager = options.extensionManager;
    this.defaultConfigUri = options.defaultConfigUri;
  }

  public async load(
    configs: AutorestRawConfiguration[],
    includeDefault: boolean,
  ): Promise<AutorestConfigurationResult> {
    const configFileUri = this.configFileOrFolderUri
      ? await detectConfigurationFile(this.fileSystem, this.configFileOrFolderUri, this.logger)
      : undefined;

    const configFileFolderUri = configFileUri
      ? ResolveUri(configFileUri, "./")
      : this.configFileOrFolderUri || "file:///";

    const configurationFiles: { [key: string]: any } = {};

    const manager = new ConfigurationManager(configFileFolderUri, this.fileSystem);

    const resolveConfig = () => manager.resolveConfig();

    // 1. overrides (CLI, ...)
    // await addSegments(configs, false);
    for (const config of configs) {
      await manager.addConfig(config);
    }

    // 2. file
    if (configFileUri != null && configFileUri !== undefined) {
      // add loaded files to the input files.
      this.logger.verbose(`> Initial configuration file '${configFileUri}'`);
      const data = await this.dataStore.GetReadThroughScope(this.fileSystem).ReadStrict(configFileUri);
      const file = await readConfigurationFile(data, this.logger, this.dataStore.getDataSink());
      manager.addConfigFile(file);
    }

    // 3. resolve 'require'd configuration
    const addedConfigs = new Set<string>();
    const resolveRequiredConfigs = async (fsToUse: IFileSystem) => {
      for await (let additionalConfig of getIncludedConfigurationFiles(resolveConfig, fsToUse, addedConfigs)) {
        // acquire additional configs
        try {
          additionalConfig = simplifyUri(additionalConfig);

          // skip ones we've aleady loaded faster.
          if (configurationFiles[additionalConfig]) {
            continue;
          }

          this.logger.verbose(`> Including configuration file '${additionalConfig}'`);
          addedConfigs.add(additionalConfig);
          // merge config

          const inputView = this.dataStore.GetReadThroughScope(fsToUse);
          const data = await inputView.ReadStrict(additionalConfig);
          manager.addConfigFile(await readConfigurationFile(data, this.logger, this.dataStore.getDataSink()));
        } catch (e) {
          this.logger.fatal(`Failed to acquire 'require'd configuration '${additionalConfig}'`);

          throw e;
        }
      }
    };
    await resolveRequiredConfigs(this.fileSystem);

    // 4. default configuration
    const fsLocal = new RealFileSystem();

    if (this.defaultConfigUri && includeDefault) {
      const inputView = this.dataStore.GetReadThroughScope(fsLocal);
      const data = await inputView.ReadStrict(this.defaultConfigUri);
      manager.addConfigFile(await readConfigurationFile(data, this.logger, this.dataStore.getDataSink()));
    }

    await resolveRequiredConfigs(fsLocal);

    // 5. resolve extensions
    const extensions: ResolvedExtension[] = [];
    if (this.extensionManager) {
      const addedExtensions = new Set<string>();
      const viewsToHandle: AutorestRawConfiguration[] = [await resolveConfig()];
      while (viewsToHandle.length > 0) {
        const config = viewsToHandle.pop() as AutorestRawConfiguration;
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
            await resolveRequiredConfigs(fsLocal);

            // merge config from extension
            const inputView = this.dataStore.GetReadThroughScope(new RealFileSystem());

            const extensionConfigurationUri = simplifyUri(CreateFileUri(await extension.configurationPath));
            this.logger.verbose(`> Including extension configuration file '${extensionConfigurationUri}'`);

            const data = await inputView.ReadStrict(extensionConfigurationUri);
            manager.addConfigFile(await readConfigurationFile(data, this.logger, this.dataStore.getDataSink()));

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

    if (config["pipeline-model"]) {
      await manager.addHighPriorityConfig({ "pipeline-model": config["pipeline-model"] });
      return { config: await manager.resolveConfig(), extensions };
    } else {
      return { config, extensions };
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
    const shortname = extensionDef.name.split("/").last.replace(/^autorest\./gi, "");

    // Add a hint here to make legacy users to be aware that the default version has been bumped to 3.0+.
    if (shortname === "powershell") {
      this.logger.info(
        `\n## The default version of @autorest/powershell has been bummped from 2.1+ to 3.0+.\n > If you still want to use 2.1+ version, please specify it with --use:@autorest/powershell@2.1.{x}, e.g 2.1.401.\n`,
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
        this.logger.info(`> Installing AutoRest extension '${extensionDef.name}' (${extensionDef.source})`);
        const extension = await extMgr.installPackage(pack, false, 5 * 60 * 1000, (progressInit: any) =>
          progressInit.Message.Subscribe((s: any, m: any) => this.logger.verbose(m)),
        );
        this.logger.info(
          `> Installed AutoRest extension '${extensionDef.name}' (${extensionDef.source}->${extension.version})`,
        );
        return extension;
      }
    }
  }
}

const resolveExtensions = (config: AutorestRawConfiguration): ExtensionDefinition[] => {
  const useExtensions = config["use-extension"] || {};
  return Object.keys(useExtensions).map((name) => {
    const source = useExtensions[name].startsWith("file://") ? FileUriToPath(useExtensions[name]) : useExtensions[name];
    return {
      name,
      source,
      fullyQualified: JSON.stringify([name, source]),
    };
  });
};
