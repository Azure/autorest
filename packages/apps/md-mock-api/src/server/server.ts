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
      logger.debug(`Starting ${request.method.toUpperCase()} ${request.url}`)

      res
        .status(response.status)
        .set(response.headers);
        if(response.body) {

          if(response.body.contentType) {
            res.contentType(response.body.contentType);
          }
          res.send(response.body.content);
        }
        logger.info(`${request.method.toUpperCase()} ${request.url} ${response.status}`)

    });
  }

  public addMultiple(routes: MockRouteDefinition[]): void {
    for (const route of routes) {
      this.add(route);
    }
  }
}
