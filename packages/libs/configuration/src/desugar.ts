import { ExtensionManager } from "@azure-tools/extension";
import { omit } from "lodash";
import { AutorestNormalizedConfiguration } from "./autorest-normalized-configuration";
import { IsUri } from "@azure-tools/uri";
import { isDirectory, exists } from "@azure-tools/async-io";
import os from "os";

const desugarUseField = async (use: string[] | string) => {
  // Create an empty extension manager to be able to call findPackages.
  const extMgr = await ExtensionManager.Create(os.tmpdir());
  const useArray = typeof use === "string" ? [use] : use;
  const extensions: Record<string, string> = {};
  for (const useEntry of useArray) {
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
        extensions[pkg.name] = useEntry;
      } else {
        const [, identity, version] = /^https?:\/\//g.exec(useEntry)
          ? [undefined, useEntry, undefined]
          : <RegExpExecArray>/(^@.*?\/[^@]*|[^@]*)@?(.*)/.exec(useEntry);

        if (identity) {
          // parsed correctly
          if (version) {
            const pkg = await extMgr.findPackage(identity, version);
            extensions[pkg.name] = version;
          } else {
            // it's either a location or just the name
            if (IsUri(identity) || (await exists(identity))) {
              // seems like it's a location to something. we don't know the actual name at this point.
              const pkg = await extMgr.findPackage("plugin", identity);
              extensions[pkg.name] = identity;
            } else {
              // must be a package name without a version
              // assume *?
              const pkg = await extMgr.findPackage(identity, "*");
              extensions[pkg.name] = pkg.version;
            }
          }
        }
      }
    }
  }
  return extensions;
};

/**
 * Resolve some sugar properties.
 * @param rawConfig Config to clean.
 */
export const desugarRawConfig = async (
  rawConfig: AutorestNormalizedConfiguration,
): Promise<AutorestNormalizedConfiguration> => {
  return {
    ...omit(rawConfig, "licence-header"),
    "license-header": rawConfig["license-header"] ?? rawConfig["licence-header"],
    "use-extension": {
      ...rawConfig["use-extension"],
      ...(rawConfig.use && (await desugarUseField(rawConfig.use))),
    },
  };
};
