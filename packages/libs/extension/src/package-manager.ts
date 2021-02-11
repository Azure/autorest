export type PackageManagerType = "yarn" | "npm";

export interface InstallOptions {
  force?: boolean;
}

export interface PackageManager {
  install(directory: string, packages: string[], options?: InstallOptions): Promise<void>;

  clean(directory: string): Promise<void>;

  getPackageVersions(directory: string, packageName: string): Promise<any[]>;
}
