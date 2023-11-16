import fs from "fs";

/**
 * Abstract class for defining a document sourcemap data with built-in memory unloading functionality.
 */
export abstract class SourceMapData<T> {
  private data: { value: T; status: "loaded" } | { status: "unloaded" };

  public constructor(
    private filename: string,
    value: T,
  ) {
    this.data = { value, status: "loaded" };
  }

  public async get(): Promise<T> {
    if (this.data.status === "unloaded") {
      const value = await this.loadCached();
      this.data = { value, status: "loaded" };
    }
    return this.data.value;
  }

  public async unload(): Promise<void> {
    if (this.data.status === "unloaded") {
      return;
    }

    const content = this.serialize(this.data.value);
    await fs.promises.writeFile(this.filename, content);
    this.data = { status: "unloaded" };
  }

  private async loadCached(): Promise<T> {
    const content = await fs.promises.readFile(this.filename);
    return this.parse(content.toString());
  }

  protected abstract serialize(value: T): string;

  protected abstract parse(content: string): T;
}
