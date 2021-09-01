import { Artifact } from "./lib/artifact";
import { writeBinary, writeString } from "@azure-tools/uri";
import { AutorestConfiguration } from "@autorest/configuration";

export class ArtifactWriter {
  private tasks: Promise<void>[] = [];
  public constructor(private config: AutorestConfiguration) {}

  public writeArtifact(artifact: Artifact) {
    this.tasks.push(
      artifact.type === "binary-file"
        ? writeBinary(artifact.uri, artifact.content)
        : writeString(artifact.uri, this.fixEol(artifact.content)),
    );
  }

  public async wait(): Promise<void> {
    await Promise.all(this.tasks);
  }

  /**
   * Use EOL configuraiton to update line endings.
   * @param content Content.
   * @returns Content string with updated line endpints.
   */
  private fixEol(content: string): string {
    const eol = this.config.eol;
    if (!eol || eol === "default") {
      return content;
    }

    const char = eol === "crlf" ? "\r\n" : "\n";
    return content.replace(/(\r\n|\n|\r)/gm, char);
  }
}
