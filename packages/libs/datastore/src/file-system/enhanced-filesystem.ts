import { EnumerateFiles, ReadUri, WriteString } from "@azure-tools/uri";
import { IFileSystem } from "./file-system";
import * as Constants from "../constants";

// handles:
// - GitHub URI adjustment
// - GitHub auth
export class EnhancedFileSystem implements IFileSystem {
  public constructor(private githubAuthToken?: string) {}

  public list(folderUri: string): Promise<Array<string>> {
    return EnumerateFiles(folderUri, [Constants.DefaultConfiguration]);
  }

  public async read(uri: string): Promise<string> {
    const headers: { [key: string]: string } = {};

    // check for GitHub OAuth token
    if (
      this.githubAuthToken &&
      (uri.startsWith("https://raw.githubusercontent.com") || uri.startsWith("https://github.com"))
    ) {
      // eslint-disable-next-line no-console
      console.error(`Used GitHub authentication token to request '${uri}'.`);
      headers.authorization = `Bearer ${this.githubAuthToken}`;
    }

    return ReadUri(uri, headers);
  }

  public async write(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
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
  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.list(folderUri);
  }
}
