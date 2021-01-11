import { logger } from "../logger";
import { parseMardownFile } from "../md-parser";
import { MockApiServer } from "../server";
import { findFiles } from "../utils";
import { ApiMockAppConfig } from "./config";

export class ApiMockApp {
  private server: MockApiServer;

  constructor(private config: ApiMockAppConfig) {
    this.server = new MockApiServer({ port: config.port });
  }

  public async start(): Promise<void> {
    if (this.config.include.length === 0) {
      throw new Error("No include pattern for definition file was passed.");
    }
    logger.verbose(`Searching for definition files in: \n${this.config.include.join("\n")}`);
    const files = await findFiles(this.config.include);
    for (const file of files) {
      const group = await parseMardownFile(file);
      this.server.addMultiple(group.routes);
    }
    this.server.start();
  }
}
