import { ExtensionManager } from "../main";
import { Extension } from "./extension";
import pacote from "pacote";

/**
 * A Package is a representation of a npm package.
 *
 * Once installed, a Package is an Extension
 */
export class Package {
  /* @internal */ public constructor(
    public resolvedInfo: any,
    /* @internal */ public packageMetadata: pacote.ManifestResult,
    /* @internal */ public extensionManager: ExtensionManager,
  ) {}

  public get id(): string {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    return this.packageMetadata._id!;
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
    return this.packageMetadata._spec as any;
  }

  public async install(force = false): Promise<Extension> {
    return this.extensionManager.installPackage(this, force);
  }

  public get allVersions(): Promise<Array<string>> {
    return this.extensionManager.getPackageVersions(this.name);
  }
}
