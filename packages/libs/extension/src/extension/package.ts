import { ExtensionManager } from "../main";
import { Extension } from "./extension";

/**
 * A Package is a representation of a npm package.
 *
 * Once installed, a Package is an Extension
 */
export class Package {
  /* @internal */ public constructor(
    public resolvedInfo: any,
    /* @internal */ public packageMetadata: any,
    /* @internal */ public extensionManager: ExtensionManager,
  ) {}

  public get id(): string {
    return this.packageMetadata._id;
  }

  public get name(): string {
    return this.packageMetadata.name;
  }

  public get version(): string {
    return this.packageMetadata.version;
  }

  public get source(): string {
    // work around bug that npm doesn't programatically handle exact versions.
    if (this.resolvedInfo.type === "version" && this.resolvedInfo.registry === true) {
      return this.packageMetadata._spec + "*";
    }
    return this.packageMetadata._spec;
  }

  public async install(force = false): Promise<Extension> {
    return this.extensionManager.installPackage(this, force);
  }

  public get allVersions(): Promise<Array<string>> {
    return this.extensionManager.getPackageVersions(this.name);
  }
}
