import { Request, Response } from "express";
import yaml from "js-yaml";
import { logger } from "../logger";
import { MockRouteDefinition } from "../models";
import { TemplateContext } from "../models/template-context";
import { RequestExt } from "./request-ext";
import { validateRequest } from "./request-validation";
import { processResponseHeaders, render } from "./response-processor";

export const processRequest = (route: MockRouteDefinition, request: RequestExt, response: Response): void => {
  const requestDef = route.request;
  try {
    validateRequest(requestDef, request);
  } catch (e) {
    logger.warn(
      [`Request validation failed: ${e.message}:`, ` Expected:\n ${e.expected}`, ` Actual: \n${e.actual}`].join("\n"),
    );
    response
      .status(400)
      .contentType("application/json")
      .send(e.toJSON ? e.toJSON() : JSON.stringify(e.message))
      .end();
    return;
  }

  const templateContext = buildTemplateContext(request);
  logger.debug(`Template context:\n${yaml.dump(templateContext)}`);
  const responseDef = route.response;

  response.status(responseDef.status);
  if (responseDef.headers) {
    response.set(processResponseHeaders(responseDef.headers, templateContext));
  }
  if (responseDef.body) {
    if (responseDef.body.contentType) {
      response.contentType(responseDef.body.contentType);
    }
    response.send(responseDef.body.rawContent && render(responseDef.body.rawContent, templateContext));
  }
  response.end();
};

const buildTemplateContext = (request: Request): TemplateContext => {
  return {
    request: {
      baseUrl: `${request.protocol}://${request.get("host")}`,
      headers: request.headers,
    },
  };
};
