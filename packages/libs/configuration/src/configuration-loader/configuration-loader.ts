import { DataStore, IFileSystem, LazyPromise, RealFileSystem } from "@azure-tools/datastore";
import { Extension, ExtensionManager, LocalExtension } from "@azure-tools/extension";
import { CreateFileUri, CreateFolderUri, ResolveUri, simplifyUri, FileUriToPath } from "@azure-tools/uri";
import { AutorestLogger } from "@autorest/common";
import untildify from "untildify";
import { CachingFileSystem } from "../caching-file-system";
import { AutorestConfiguration } from "../autorest-configuration";
import { detectConfigurationFile } from "../configuration-file-resolver";
import { ConfigurationManager, readConfigurationFile } from "../configuration-manager";
import { getIncludedConfigurationFiles } from "../configuration-require-resolver";
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

/**
 * Class handling the loading of an autorest configuration.
 */
export class ConfigurationLoader {
  private fileSystem: CachingFileSystem;

  /**
   * @param fileSystem File system.
   * @param configFileOrFolderUri Path to the config file or folder.
   */
  public constructor(
    fileSystem: IFileSystem = new RealFileSystem(),
    private dataStore: DataStore,
    private logger: AutorestLogger,
    private extMgr: ExtensionManager,
    private defaultConfigUri: string,
    private configFileOrFolderUri?: string,
  ) {
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
  }

  public async load(
    configs: AutorestRawConfiguration[],
    includeDefault: boolean,
  ): Promise<AutorestConfigurationResult> {
    const configFileUri =
      this.fileSystem && this.configFileOrFolderUri
        ? await detectConfigurationFile(this.fileSystem, this.configFileOrFolderUri, this.logger)
        : null;
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
    if (configFileUri !== null) {
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
    if (includeDefault) {
      const inputView = this.dataStore.GetReadThroughScope(fsLocal);
      const data = await inputView.ReadStrict(this.defaultConfigUri);
      manager.addConfigFile(await readConfigurationFile(data, this.logger, this.dataStore.getDataSink()));
    }

    await resolveRequiredConfigs(fsLocal);

    // 5. resolve extensions
    const addedExtensions = new Set<string>();
    const extensions: ResolvedExtension[] = [];

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

          const extension = await this.resolveExtension(additionalExtension);
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

    // resolve any outstanding includes again
    await resolveRequiredConfigs(fsLocal);

    return { config: await manager.resolveConfig(), extensions };
  }

  /**
   * Returns the @see Extension object for the requested extension.
   * @param extensionDef extension definition.
   * @param messageFormat message format.
   */
  private async resolveExtension(extensionDef: ExtensionDefinition): Promise<Extension> {
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

      const pack = await this.extMgr.findPackage(extensionDef.name, localPath);
      return new LocalExtension(pack, localPath);
    } else {
      // remote package`
      const installedExtension = await this.extMgr.getInstalledExtension(extensionDef.name, extensionDef.source);
      if (installedExtension) {
        this.logger.info(
          `> Loading AutoRest extension '${extensionDef.name}' (${extensionDef.source}->${installedExtension.version})`,
        );
        return installedExtension;
      } else {
        // acquire extension
        const pack = await this.extMgr.findPackage(extensionDef.name, extensionDef.source);
        this.logger.info(`> Installing AutoRest extension '${extensionDef.name}' (${extensionDef.source})`);
        const extension = await this.extMgr.installPackage(pack, false, 5 * 60 * 1000, (progressInit: any) =>
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
