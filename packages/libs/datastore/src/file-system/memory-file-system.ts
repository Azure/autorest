import { items, keys } from "@azure-tools/linq";
import { ResolveUri } from "@azure-tools/uri";
import { IFileSystem } from "./file-system";

export class MemoryFileSystem implements IFileSystem {
  public static readonly DefaultVirtualRootUri = "file:///";
  private filesByUri: Map<string, string>;

  public constructor(files: Map<string, string>) {
    this.filesByUri = new Map<string, string>(
      items(files).select(
        (each) => [ResolveUri(MemoryFileSystem.DefaultVirtualRootUri, each.key), each.value] as [string, string],
      ),
    );
  }

  public readonly outputs: Map<string, string> = new Map<string, string>();

  public async read(uri: string): Promise<string> {
    if (!this.filesByUri.has(uri)) {
      throw new Error(`File ${uri} is not in the MemoryFileSystem`);
    }
    return <string>this.filesByUri.get(uri);
  }

  async list(folderUri: string = MemoryFileSystem.DefaultVirtualRootUri): Promise<Array<string>> {
    return keys(this.filesByUri)
      .where((uri) => {
        // in folder?
        if (!uri.startsWith(folderUri)) {
          return false;
        }
        return uri.substr(folderUri.length).indexOf("/") === -1;
      })
      .toArray();
  }

  public async write(uri: string, content: string): Promise<void> {
    this.outputs.set(uri, content);
  }

  /**
   * @deprecated
   */
  public async ReadFile(uri: string): Promise<string> {
    return this.read(uri);
  }

  /**
   * @deprecated
   */
  public async EnumerateFileUris(folderUri: string = MemoryFileSystem.DefaultVirtualRootUri): Promise<Array<string>> {
    return this.list(folderUri);
  }
}
