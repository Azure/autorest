import { ResolveUri } from "@azure-tools/uri";
import { UriNotFoundError } from "./errors";
import { IFileSystem } from "./file-system";

export class MemoryFileSystem implements IFileSystem {
  public static readonly DefaultVirtualRootUri = "file:///";
  private filesByUri: Map<string, string>;

  public constructor(files: Map<string, string>) {
    this.filesByUri = new Map<string, string>(
      [...files.entries()].map(([uri, content]) => [ResolveUri(MemoryFileSystem.DefaultVirtualRootUri, uri), content]),
    );
  }

  public readonly outputs: Map<string, string> = new Map<string, string>();

  public async read(uri: string): Promise<string> {
    const content = this.filesByUri.get(uri);
    if (content === undefined) {
      throw new UriNotFoundError(uri, `File ${uri} is not in the MemoryFileSystem`);
    }
    return content;
  }

  async list(folderUri: string = MemoryFileSystem.DefaultVirtualRootUri): Promise<Array<string>> {
    return [...this.filesByUri.keys()].filter((uri) => {
      // in folder?
      if (!uri.startsWith(folderUri)) {
        return false;
      }
      return uri.substr(folderUri.length).indexOf("/") === -1;
    });
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
