import { ChildProcess } from "child_process";
import { isFile, readdir, readFile } from "@azure-tools/async-io";
import { normalize } from "path";
import { Package } from "./package";
import { readFileSync } from "fs";

/**
 * Extension is an installed Package
 * @extends Package
 * */
export class Extension extends Package {
  /* @internal */ public constructor(pkg: Package, private installationPath: string) {
    super(pkg.resolvedInfo, pkg.packageMetadata, pkg.extensionManager);
  }
  /**
   * The installed location of the package.
   */
  public get location(): string {
    return normalize(`${this.installationPath}/${this.id.replace("/", "_")}`);
  }
  /**
   * The path to the installed npm package (internal to 'location')
   */
  public get modulePath(): string {
    return normalize(`${this.location}/node_modules/${this.name}`);
  }

  /**
   * the path to the package.json file for the npm packge.
   */
  public get packageJsonPath(): string {
    return normalize(`${this.modulePath}/package.json`);
  }

  /**
   * the path to the readme.md configuration file for the extension.
   */
  public get configurationPath(): Promise<string> {
    return (async () => {
      const items = await readdir(this.modulePath);
      for (const each of items) {
        if (/^readme.md$/i.exec(each)) {
          const fullPath = normalize(`${this.modulePath}/${each}`);
          if (await isFile(fullPath)) {
            return fullPath;
          }
        }
      }
      return "";
    })();
  }

  /** the loaded package.json information */
  public get definition(): any {
    const content = readFileSync(this.packageJsonPath).toString();
    try {
      return JSON.parse(content);
    } catch (e) {
      throw new Error(`Failed to parse package definition at '${this.packageJsonPath}'. ${e}`);
    }
  }

  public get configuration(): Promise<string> {
    return (async () => {
      const cfgPath = await this.configurationPath;
      if (cfgPath) {
        return readFile(cfgPath);
      }
      return "";
    })();
  }

  public async remove(): Promise<void> {
    return this.extensionManager.removeExtension(this);
  }

  public async start(enableDebugger = false): Promise<ChildProcess> {
    return this.extensionManager.start(this, enableDebugger);
  }
}
