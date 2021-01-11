import bodyParser from "body-parser";
import express from "express";
import morgan from "morgan";
import { logger } from "../logger";
import { MockRouteDefinition } from "../models";
import { processRequest } from "./request-processor";
export interface MockApiServerConfig {
  port: number;
}

export class MockApiServer {
  private app: express.Application;

  constructor(private config: MockApiServerConfig) {
    this.app = express();
    this.app.use(morgan("dev"));
  }

  public start(): void {
    this.app.listen(this.config.port, () => {
      logger.info(`Started server on port ${this.config.port}`);
    });
  }

  public add(route: MockRouteDefinition): void {
    const { request } = route;
    logger.info(`Registering route ${request.method} ${request.url}`);
    this.app.route(request.url)[request.method](bodyParser.raw({ type: "*/*" }), (req, res) => {
      processRequest(route, req, res);
    });
  }

  public addMultiple(routes: MockRouteDefinition[]): void {
    for (const route of routes) {
      this.add(route);
    }
  }
}
