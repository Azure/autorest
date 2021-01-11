import { Request, Response } from "express";
import mustache from "mustache";
import { logger } from "../logger";
import { MockRouteDefinition } from "../models";
import { TemplateContext } from "../models/template-context";
import { validateRequest } from "./request-validation";

export const processRequest = (route: MockRouteDefinition, request: Request, response: Response): void => {
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
  const responseDef = route.response;

  response.status(responseDef.status);
  if (responseDef.headers) {
    response.set(processResponseHeaders(responseDef.headers, templateContext));
  }
  if (responseDef.body) {
    if (responseDef.body.contentType) {
      response.contentType(responseDef.body.contentType);
    }
    response.send(render(responseDef.body.content, templateContext));
  }
  response.end();
};

const buildTemplateContext = (request: Request): TemplateContext => {
  return {
    request: {
      baseUrl: `${request.protocol}://${request.get("host")}`,
    },
  };
};

const processResponseHeaders = (
  headers: { [key: string]: string },
  context: TemplateContext,
): { [key: string]: string } => {
  const result: { [key: string]: string } = {};
  for (const [key, value] of Object.entries(headers)) {
    result[key] = render(value, context);
  }
  return result;
};

const render = (template: string, context: TemplateContext) => mustache.render(template, context);
