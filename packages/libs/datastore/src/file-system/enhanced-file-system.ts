import { writeString } from "@azure-tools/uri";
import { URL } from "url";
import { logger } from "../logger";
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
    return writeString(uri, content);
  }

  private getHeaders(uri: string) {
    const headers: { [key: string]: string } = {};

    // check for GitHub OAuth token
    if (this.githubAuthToken && this.isGithubUrl(uri)) {
      logger.info(`Used GitHub authentication token to request '${uri}'.`);
      headers.authorization = `Bearer ${this.githubAuthToken}`;
    }

    return headers;
  }

  private isGithubUrl(uri: string) {
    try {
      const url = new URL(uri);
      return url.host === "raw.githubusercontent.com" || url.host === "github.com";
    } catch {
      return false;
    }
  }
}
