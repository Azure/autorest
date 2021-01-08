import express from "express";
import { logger } from "../logger";
import { MockRouteDefinition } from "../models";

export interface MockApiServerConfig {
  port: number;
}

export class MockApiServer {
  private app: express.Application;

  constructor(private config: MockApiServerConfig) {
    this.app = express();
  }

  public start(): void {
    this.app.listen(this.config.port, () => {
      logger.info(`Started server on port ${this.config.port}`);
    });
  }

  public add(route: MockRouteDefinition): void {
    const { request, response } = route;
    logger.info(`Registering route ${request.method} ${request.url}`);
    this.app.route(request.url)[request.method]((_, res) => {
      res
        .status(response.status)
        .set(response.headers)
        .contentType(response.body.contentType)
        .send(response.body.content);
    });
  }

  public addMultiple(routes: MockRouteDefinition[]): void {
    for (const route of routes) {
      this.add(route);
    }
  }
}
