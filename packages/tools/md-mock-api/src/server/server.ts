import { IncomingMessage, ServerResponse } from "http";
import bodyParser from "body-parser";
import express, { ErrorRequestHandler, Response } from "express";
import morgan from "morgan";
import { logger } from "../logger";
import { MockRouteDefinition } from "../models";
import { RequestExt } from "./request-ext";
import { processRequest } from "./request-processor";

export interface MockApiServerConfig {
  port: number;
}

const errorHandler: ErrorRequestHandler = (err, _req, res, _next) => {
  logger.error("Error", err);
  res.status(err.status || 500);
  res
    .send(err instanceof Error ? { name: err.name, message: err.message, stack: err.stack } : JSON.stringify(err))
    .end();
};

const rawBodySaver = (req: RequestExt, res: ServerResponse, buf: Buffer, encoding: BufferEncoding) => {
  if (buf && buf.length) {
    req.rawBody = buf.toString(encoding || "utf8");
    console.log("Save", req.rawBody);
  }
};

const loggerstream = {
  write: (message: string) => logger.info(message),
};

export class MockApiServer {
  private app: express.Application;

  constructor(private config: MockApiServerConfig) {
    this.app = express();
    this.app.use(morgan("dev", { stream: loggerstream }));
    this.app.use(bodyParser.json({ verify: rawBodySaver, strict: false }));
    this.app.use(bodyParser.urlencoded({ verify: rawBodySaver, extended: true }));
    this.app.use(bodyParser.raw({ verify: rawBodySaver, type: "*/*" }));
  }

  public start(): void {
    this.app.use(errorHandler);

    this.app.listen(this.config.port, () => {
      logger.info(`Started server on port ${this.config.port}`);
    });
  }

  public add(route: MockRouteDefinition): void {
    const { request } = route;
    logger.info(`Registering route ${request.method} ${request.url}`);
    this.app.route(request.url)[request.method]((req, res) => {
      processRequest(route, req, res);
    });
  }

  public addMultiple(routes: MockRouteDefinition[]): void {
    for (const route of routes) {
      this.add(route);
    }
  }
}
