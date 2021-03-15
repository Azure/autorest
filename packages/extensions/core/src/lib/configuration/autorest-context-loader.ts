/* eslint-disable @typescript-eslint/no-use-before-define */
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { CachingFileSystem, IFileSystem, LazyPromise, RealFileSystem } from "@azure-tools/datastore";
import { Extension, ExtensionManager } from "@azure-tools/extension";
import { CreateFolderUri, ResolveUri } from "@azure-tools/uri";
import { join } from "path";
import { AutoRestExtension } from "../pipeline/plugin-endpoint";
import {
  AutorestConfiguration,
  AutorestRawConfiguration,
  ConfigurationLoader,
  getNestedConfiguration,
  mergeConfigurations,
  ResolvedExtension,
} from "@autorest/configuration";
import { AutorestContext } from "./autorest-context";
import { MessageEmitter } from "./message-emitter";
import { AutorestLogger } from "@autorest/common";
import { AppRoot } from "../constants";
import { AutorestCoreLogger } from "./logger";

const inWebpack = typeof __webpack_require__ === "function";
const pathToYarnCli = inWebpack ? `${__dirname}/yarn/cli.js` : undefined;

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
export class AutorestContextLoader {
  private fileSystem: CachingFileSystem;

  /**
   * @param fileSystem File system.
   * @param configFileOrFolderUri Path to the config file or folder.
   */
  public constructor(fileSystem: IFileSystem = new RealFileSystem(), private configFileOrFolderUri?: string) {
    this.fileSystem = fileSystem instanceof CachingFileSystem ? fileSystem : new CachingFileSystem(fileSystem);
  }

  private static extensionManager: LazyPromise<ExtensionManager> = new LazyPromise<ExtensionManager>(() =>
    ExtensionManager.Create(
      join(process.env["AUTOREST_HOME"] || process.env["autorest.home"] || require("os").homedir(), ".autorest"),
      "yarn",
      pathToYarnCli,
    ),
  );

  public static async shutdown() {
    try {
      AutoRestExtension.killAll();

      // once we shutdown those extensions, we should shutdown the EM too.
      const extMgr = await AutorestContextLoader.extensionManager;
      void extMgr.dispose();

      // but if someone goes to use that, we're going to need a new instance (since the shared lock will be gone in the one we disposed.)
      AutorestContextLoader.extensionManager = new LazyPromise<ExtensionManager>(() =>
        ExtensionManager.Create(
          join(process.env["AUTOREST_HOME"] || process.env["autorest.home"] || require("os").homedir(), ".autorest"),
        ),
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
    ...configs: AutorestRawConfiguration[]
  ): Promise<AutorestContext> {
    const logger: AutorestLogger = new AutorestCoreLogger(mergeConfigurations(...configs) as any, messageEmitter);

    const defaultConfigUri = ResolveUri(CreateFolderUri(AppRoot), "resources/default-configuration.md");
    const loader = new ConfigurationLoader(
      this.fileSystem,
      messageEmitter.DataStore,
      logger,
      await AutorestContextLoader.extensionManager,
      defaultConfigUri,
      this.configFileOrFolderUri,
    );

    const { config, extensions } = await loader.load(configs, includeDefault);
    this.setupExtensions(config, extensions);
    return new AutorestContext(config, this.fileSystem, messageEmitter);
  }

  private setupExtensions(config: AutorestConfiguration, extensions: ResolvedExtension[]) {
    for (const { extension, definition } of extensions) {
      if (!loadedExtensions[definition.fullyQualified]) {
        const shortname = definition.name.split("/").last.replace(/^autorest\./gi, "");
        const nestedConfig = [...getNestedConfiguration(config, shortname)][0];
        const enableDebugger = nestedConfig?.["debugger"];

        loadedExtensions[definition.fullyQualified] = {
          extension,
          autorestExtension: new LazyPromise(async () =>
            AutoRestExtension.FromChildProcess(definition.name, await extension.start(enableDebugger)),
          ),
        };
      }
    }
  }
}
