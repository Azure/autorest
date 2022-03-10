import { AutorestConfiguration } from "@autorest/configuration";
import { writeBinary, writeString } from "@azure-tools/uri";
import { Artifact } from "./lib/artifact";

export interface ArtifactWriterStats {
  /**
   * Number of write that have been requested.
   */
  writeRequested: number;

  /**
   * Number of that have been completed.
   */
  writeCompleted: number;
}

export class ArtifactWriter {
  public stats: ArtifactWriterStats = {
    writeRequested: 0,
    writeCompleted: 0,
  };
  private tasks: Promise<void>[] = [];
  public constructor(private config: AutorestConfiguration) {}

  public writeArtifact(artifact: Artifact) {
    this.stats.writeRequested++;
    const action = async () => {
      artifact.type === "binary-file"
        ? await writeBinary(artifact.uri, artifact.content)
        : await writeString(artifact.uri, this.fixEol(artifact.content));

      this.stats.writeCompleted++;
    };
    this.tasks.push(action());
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
