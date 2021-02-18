/* eslint-disable @typescript-eslint/no-use-before-define */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { exists, filePath, isDirectory } from "@azure-tools/async-io";
import { DataHandle, IFileSystem, LazyPromise, RealFileSystem } from "@azure-tools/datastore";
import { Extension, ExtensionManager, LocalExtension } from "@azure-tools/extension";
import {
  CreateFileUri,
  CreateFolderUri,
  ResolveUri,
  simplifyUri,
  IsUri,
  ParentFolderUri,
  FileUriToPath,
} from "@azure-tools/uri";
import { join } from "path";
import { AutorestLogger, OperationAbortedException, parseCodeBlocks } from "@autorest/common";
import { Channel, SourceLocation } from "../message";
import { AutoRestExtension } from "../pipeline/plugin-endpoint";
import { AppRoot } from "../constants";
import { AutorestRawConfiguration, arrayOf, ConfigurationManager } from "@autorest/configuration";
import { AutorestContext, createAutorestContext } from "./autorest-context";
import { CachingFileSystem } from "./caching-file-system";
import { MessageEmitter } from "./message-emitter";
import { detectConfigurationFile } from "./configuration-file-resolver";
import { getIncludedConfigurationFiles } from "./loading-utils";
import { readConfigurationFile } from "@autorest/configuration/dist/configuration-manager/configuration-file";

const inWebpack = typeof __webpack_require__ === "function";
const pathToYarnCli = inWebpack ? `${__dirname}/yarn/cli.js` : undefined;

// eslint-disable-next-line @typescript-eslint/no-var-requires
const untildify: (path: string) => string = require("untildify");

const loadedExtensions: {
  [fullyQualified: string]: { extension: Extension; autorestExtension: LazyPromise<AutoRestExtension> };
} = {};
/*@internal*/
export async function getExtension(fullyQualified: string): Promise<AutoRestExtension> {
  return loadedExtensions[fullyQualified].autorestExtension;
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
  public constructor(fileSystem: IFileSystem = new RealFileSystem(), private configFileOrFolderUri?: string) {
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
  }

  private async parseCodeBlocks(
    configFile: DataHandle,
    contextConfig: AutorestContext,
  ): Promise<Array<AutorestRawConfiguration>> {
    const parentFolder = ParentFolderUri(configFile.originalFullPath);

    // load config
    const hConfig = await parseCodeBlocks(contextConfig, configFile, contextConfig.DataStore.getDataSink());
    if (hConfig.length === 1 && hConfig[0].info === null && configFile.Description.toLowerCase().endsWith(".md")) {
      // this is a whole file, and it's a markdown file.
      return [];
    }

    const blocks = await Promise.all(
      hConfig
        .filter((each) => each)
        .map((each) => {
          const pBlock = each.data.ReadObject<AutorestRawConfiguration>();
          return pBlock.then((block) => {
            if (!block) {
              block = {};
            }
            if (typeof block !== "object") {
              contextConfig.Message({
                Channel: Channel.Error,
                Text: "Syntax error: Invalid YAML object.",
                Source: [<SourceLocation>{ document: each.data.key, Position: { line: 1, column: 0 } }],
              });
              throw new OperationAbortedException();
            }
            block.__info = each.info;

            // for ['input-file','try-require', 'require'] paths, we're going to create a node that contains
            // a map of the path to the folder from which the configuration file
            // that loaded it was specified.

            // this will enable us to try to load relative paths relative to the folder from which it was read
            // rather than have to rely on the pseudo $(this-folder) macro (which requires updating the file)

            block.__parents = {};
            for (const kind of ["input-file", "require", "try-require", "exclude-file"]) {
              if (block[kind]) {
                for (const location of arrayOf<string>(block[kind])) {
                  if (!IsUri(location)) {
                    block.__parents[location] = parentFolder;
                  }
                }
              }
            }
            return block;
          });
        }),
    );
    return blocks;
  }

  private static extensionManager: LazyPromise<ExtensionManager> = new LazyPromise<ExtensionManager>(() =>
    ExtensionManager.Create(
      join(process.env["autorest.home"] || require("os").homedir(), ".autorest"),
      "yarn",
      pathToYarnCli,
    ),
  );

  // TODO-TIM consume this in configuration manager
  private async desugarRawConfig(configs: any): Promise<any> {
    // shallow copy
    configs = { ...configs };
    configs["use-extension"] = { ...configs["use-extension"] };

    if (configs["licence-header"]) {
      configs["license-header"] = configs["licence-header"];
      delete configs["licence-header"];
    }

    // use => use-extension
    let use = configs.use;
    if (typeof use === "string") {
      use = [use];
    }
    if (Array.isArray(use)) {
      const extMgr = await ConfigurationLoader.extensionManager;
      for (const useEntry of use) {
        if (typeof useEntry === "string") {
          // potential formats:
          // <pkg>
          // <pkg>@<version>
          // @<org>/<pkg>
          // @<org>/<pkg>@<version>
          // <path>
          // <path/uri to .tgz package file>
          // if the entry starts with an @ it's definitely a package reference
          if (useEntry.endsWith(".tgz") || (await isDirectory(useEntry)) || useEntry.startsWith("file:/")) {
            const pkg = await extMgr.findPackage("plugin", useEntry);
            configs["use-extension"][pkg.name] = useEntry;
          } else {
            const [, identity, version] = /^https?:\/\//g.exec(useEntry)
              ? [undefined, useEntry, undefined]
              : <RegExpExecArray>/(^@.*?\/[^@]*|[^@]*)@?(.*)/.exec(useEntry);
            if (identity) {
              // parsed correctly
              if (version) {
                const pkg = await extMgr.findPackage(identity, version);
                configs["use-extension"][pkg.name] = version;
              } else {
                // it's either a location or just the name
                if (IsUri(identity) || (await exists(identity))) {
                  // seems like it's a location to something. we don't know the actual name at this point.
                  const pkg = await extMgr.findPackage("plugin", identity);
                  configs["use-extension"][pkg.name] = identity;
                } else {
                  // must be a package name without a version
                  // assume *?
                  const pkg = await extMgr.findPackage(identity, "*");
                  configs["use-extension"][pkg.name] = pkg.version;
                }
              }
            }
          }
        }
      }
      delete configs.use;
    }
    return configs;
  }

  public static async shutdown() {
    try {
      AutoRestExtension.killAll();

      // once we shutdown those extensions, we should shutdown the EM too.
      const extMgr = await ConfigurationLoader.extensionManager;
      extMgr.dispose();

      // but if someone goes to use that, we're going to need a new instance (since the shared lock will be gone in the one we disposed.)
      ConfigurationLoader.extensionManager = new LazyPromise<ExtensionManager>(() =>
        ExtensionManager.Create(join(process.env["autorest.home"] || require("os").homedir(), ".autorest")),
      );

      for (const each in loadedExtensions) {
        const ext = loadedExtensions[each];
        if (ext.autorestExtension.hasValue) {
          const extension = await ext.autorestExtension;
          extension.kill();
          delete loadedExtensions[each];
        }
      }
    } catch {
      // no worries
    }
  }

  public async CreateView(
    messageEmitter: MessageEmitter,
    includeDefault: boolean,
    ...configs: Array<any>
  ): Promise<AutorestContext> {
    const configFileUri =
      this.fileSystem && this.configFileOrFolderUri
        ? await detectConfigurationFile(this.fileSystem, this.configFileOrFolderUri, messageEmitter)
        : null;
    const configFileFolderUri = configFileUri
      ? ResolveUri(configFileUri, "./")
      : this.configFileOrFolderUri || "file:///";

    const configurationFiles: { [key: string]: any } = {};

    const logger: AutorestLogger = {
      // TODO-TIM define correctly.
      trackError: () => null,
    };

    const manager = new ConfigurationManager(this.fileSystem, messageEmitter.DataStore, logger);

    const resolveConfig = () => manager.resolveConfig();

    // 1. overrides (CLI, ...)
    // await addSegments(configs, false);
    for (const config of configs) {
      manager.addConfig(config);
    }

    // 2. file
    if (configFileUri !== null) {
      // add loaded files to the input files.
      messageEmitter.Message.Dispatch({
        Channel: Channel.Verbose,
        Text: `> Initial configuration file '${configFileUri}'`,
      });
      manager.addRawConfigFile(configFileUri);
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

          messageEmitter.Message.Dispatch({
            Channel: Channel.Verbose,
            Text: `> Including configuration file '${additionalConfig}'`,
          });
          addedConfigs.add(additionalConfig);
          // merge config

          const inputView = messageEmitter.DataStore.GetReadThroughScope(fsToUse);
          const data = await inputView.ReadStrict(additionalConfig);
          manager.addConfigFile(await readConfigurationFile(data, logger, messageEmitter.DataStore.getDataSink()));
        } catch (e) {
          messageEmitter.Message.Dispatch({
            Channel: Channel.Fatal,
            Text: `Failed to acquire 'require'd configuration '${additionalConfig}'`,
          });
          throw e;
        }
      }
    };
    await resolveRequiredConfigs(this.fileSystem);

    // 4. default configuration
    const fsLocal = new RealFileSystem();
    if (includeDefault) {
      const inputView = messageEmitter.DataStore.GetReadThroughScope(fsLocal);
      const defaultConfigUri = ResolveUri(CreateFolderUri(AppRoot), "resources/default-configuration.md");
      const data = await inputView.ReadStrict(defaultConfigUri);
      manager.addConfigFile(await readConfigurationFile(data, logger, messageEmitter.DataStore.getDataSink()));
    }

    await resolveRequiredConfigs(fsLocal);
    const messageFormat = resolveConfig()["message-format"];

    // 5. resolve extensions
    const extMgr = await ConfigurationLoader.extensionManager;
    const addedExtensions = new Set<string>();

    const resolveExtensionConfigs = async () => {
      const viewsToHandle: Array<AutorestRawConfiguration> = [resolveConfig()];
      while (viewsToHandle.length > 0) {
        const tmpView = viewsToHandle.pop() as AutorestRawConfiguration;
        const extensions = resolveExtensions(tmpView);
        const additionalExtensions = extensions.filter((ext) => !addedExtensions.has(ext.fullyQualified));
        // TODO-TIM can use additionalExtensions instead of extensions
        manager.addConfig({ "used-extension": extensions.map((x) => x.fullyQualified) });
        if (additionalExtensions.length === 0) {
          continue;
        }

        // acquire additional extensions
        for (const additionalExtension of additionalExtensions) {
          try {
            addedExtensions.add(additionalExtension.fullyQualified);

            let ext = loadedExtensions[additionalExtension.fullyQualified];

            // not yet loaded?
            if (!ext) {
              let localPath = untildify(additionalExtension.source);

              // try resolving the package locally (useful for self-contained)
              try {
                const fileProbe = "/package.json";
                localPath = require.resolve(additionalExtension.name + fileProbe); // have to resolve specific file - resolving a package by name will fail if no 'main' is present
                localPath = localPath.slice(0, localPath.length - fileProbe.length);
              } catch {
                // no worries
              }

              // trim off the '@org' and 'autorest.' from the name.
              const shortname = additionalExtension.name.split("/").last.replace(/^autorest\./gi, "");

              // TODO-TIM: handle this scenario:
              // const view = [...(await createView()).getNestedConfiguration(shortname)];
              const enableDebugger = tmpView["debugger"];

              // Add a hint here to make legacy users to be aware that the default version has been bumped to 3.0+.
              if (shortname === "powershell") {
                messageEmitter.Message.Dispatch({
                  Channel: Channel.Information,
                  Text: `\n## The default version of @autorest/powershell has been bummped from 2.1+ to 3.0+.\n > If you still want to use 2.1+ version, please specify it with --use:@autorest/powershell@2.1.{x}, e.g 2.1.401.\n`,
                });
              }

              if ((await exists(localPath)) && !localPath.endsWith(".tgz")) {
                localPath = filePath(localPath);
                if (messageFormat !== "json" && messageFormat !== "yaml") {
                  // local package
                  messageEmitter.Message.Dispatch({
                    Channel: Channel.Information,
                    Text: `> Loading local AutoRest extension '${additionalExtension.name}' (${localPath})`,
                  });
                }

                const pack = await extMgr.findPackage(additionalExtension.name, localPath);
                const extension = new LocalExtension(pack, localPath);

                // start extension
                ext = loadedExtensions[additionalExtension.fullyQualified] = {
                  extension,
                  autorestExtension: new LazyPromise(async () =>
                    AutoRestExtension.FromChildProcess(additionalExtension.name, await extension.start(enableDebugger)),
                  ),
                };
              } else {
                // remote package`
                const installedExtension = await extMgr.getInstalledExtension(
                  additionalExtension.name,
                  additionalExtension.source,
                );
                if (installedExtension) {
                  if (messageFormat !== "json" && messageFormat !== "yaml") {
                    messageEmitter.Message.Dispatch({
                      Channel: Channel.Information,
                      Text: `> Loading AutoRest extension '${additionalExtension.name}' (${additionalExtension.source}->${installedExtension.version})`,
                    });
                  }

                  // start extension
                  ext = loadedExtensions[additionalExtension.fullyQualified] = {
                    extension: installedExtension,
                    autorestExtension: new LazyPromise(async () =>
                      AutoRestExtension.FromChildProcess(
                        additionalExtension.name,
                        await installedExtension.start(enableDebugger),
                      ),
                    ),
                  };
                } else {
                  // acquire extension
                  const pack = await extMgr.findPackage(additionalExtension.name, additionalExtension.source);
                  messageEmitter.Message.Dispatch({
                    Channel: Channel.Information,
                    Text: `> Installing AutoRest extension '${additionalExtension.name}' (${additionalExtension.source})`,
                  });
                  const cwd = process.cwd(); // TODO: fix extension?
                  const extension = await extMgr.installPackage(pack, false, 5 * 60 * 1000, (progressInit: any) =>
                    progressInit.Message.Subscribe((s: any, m: any) =>
                      tmpView.Message({ Text: m, Channel: Channel.Verbose }),
                    ),
                  );
                  messageEmitter.Message.Dispatch({
                    Channel: Channel.Information,
                    Text: `> Installed AutoRest extension '${additionalExtension.name}' (${additionalExtension.source}->${extension.version})`,
                  });
                  process.chdir(cwd);
                  // start extension

                  ext = loadedExtensions[additionalExtension.fullyQualified] = {
                    extension,
                    autorestExtension: new LazyPromise(async () =>
                      AutoRestExtension.FromChildProcess(
                        additionalExtension.name,
                        await extension.start(enableDebugger),
                      ),
                    ),
                  };
                }
              }
            }
            await resolveRequiredConfigs(fsLocal);

            // merge config from extension
            const inputView = messageEmitter.DataStore.GetReadThroughScope(new RealFileSystem());

            const extensionConfigurationUri = simplifyUri(CreateFileUri(await ext.extension.configurationPath));
            messageEmitter.Message.Dispatch({
              Channel: Channel.Verbose,
              Text: `> Including extension configuration file '${extensionConfigurationUri}'`,
            });

            // const data = await inputView.ReadStrict(extensionConfigurationUri);
            // manager.addConfigFile(await readConfigurationFile(data, logger, messageEmitter.DataStore.getDataSink()));

            // even though we load extensions after the default configuration, I want them to be able to
            // trigger changes in the default configuration loading (ie, an extension can set a flag to use a different pipeline.)

            // TODO-TIM check this. Maybe just combine the file.
            // await createView(
            //   await addSegments(
            //     blocks.reverse().map((each) => (each["pipeline-model"] ? { ...each, "load-priority": 1000 } : each)),
            //   ),
            // ),

            viewsToHandle.push(resolveConfig());
          } catch (e) {
            messageEmitter.Message.Dispatch({
              Channel: Channel.Fatal,
              Text: `Failed to install or start extension '${additionalExtension.name}' (${additionalExtension.source})`,
            });
            throw e;
          }
        }
        await resolveRequiredConfigs(fsLocal);
      }

      // resolve any outstanding includes again
      await resolveRequiredConfigs(fsLocal);
    };

    // resolve the extensions
    await resolveExtensionConfigs();

    // re-acquire CLI and configuration files at a lower priority
    // this enables the configuration of a plugin to specify stuff like `pipeline-model`
    // which would unlock a guarded section that has $(pipeline-model) == 'v3' in the yaml block.
    // doing so would allow the configuration to load input-files that have that guard on

    // and because this comes in at a lower-priority, it won't overwrite values that have been already
    // set in a meaningful way.

    // it's only marginally hackey...

    // TODO-TIM reload this.
    // reload files
    // if (configFileUri !== null) {
    //   const blocks = await this.parseCodeBlocks(await fsInputView.ReadStrict(configFileUri), await createView());
    //   await addSegments(blocks.reverse(), false);
    //   await resolveRequiredConfigs(this.fileSystem);
    //   await resolveExtensions();

    //   return await createView([...configs, ...blocks, ...secondPass]);
    // }

    // await resolveExtensions();

    // return the final view
    return new AutorestContext(manager.resolveConfig(), this.fileSystem, messageEmitter, configFileFolderUri);
  }
}

const resolveExtensions = (
  config: AutorestRawConfiguration,
): Array<{ name: string; source: string; fullyQualified: string }> => {
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
