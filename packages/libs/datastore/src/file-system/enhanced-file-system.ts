import { WriteString } from "@azure-tools/uri";
import { RealFileSystem } from "./real-file-system";

// handles:
// - GitHub URI adjustment
// - GitHub auth
/**
 *
 */
export class EnhancedFileSystem extends RealFileSystem {
  public constructor(private githubAuthToken?: string) {
    super();
  }

  public async read(uri: string): Promise<string> {
    return super.read(uri, this.getHeaders(uri));
  }

  public async write(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }

  private getHeaders(uri: string) {
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

    return headers;
  }
}
