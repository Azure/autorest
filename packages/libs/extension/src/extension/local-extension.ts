import { Extension } from "./extension";
import { Package } from "./package";

/**
 * LocalExtension is a local extension that must not be installed.
 * @extends Extension
 * */
export class LocalExtension extends Extension {
  public constructor(pkg: Package, private extensionPath: string) {
    super(pkg, "");
  }

  public get location(): string {
    return this.extensionPath;
  }

  public get modulePath(): string {
    return this.extensionPath;
  }

  public async remove(): Promise<void> {
    throw new Error("Cannot remove local extension. Lifetime not our responsibility.");
  }
}
