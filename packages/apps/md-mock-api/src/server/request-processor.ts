import { type } from "os";
import { Request, Response } from "express";
import { logger } from "../logger";
import { MockRouteDefinition, MockRouteRequestDefinition } from "../models";

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

  const responseDef = route.response;
  response.status(responseDef.status).set(responseDef.headers);
  if (responseDef.body) {
    if (responseDef.body.contentType) {
      response.contentType(responseDef.body.contentType);
    }
    response.send(responseDef.body.content);
  }
  response.end();
};

class ValidationError extends Error {
  constructor(message: string, public expected: string, public actual: string) {
    super(message);
  }

  public toJSON() {
    return JSON.stringify({ message: this.message, expected: this.expected, actual: this.actual });
  }
}

/**
 *
 * @param definition Definition.
 * @param request Express.js request.
 */
const validateRequest = (definition: MockRouteRequestDefinition, request: Request) => {
  if (definition.body) {
    const actualBody = request.body.toString();
    const expectedBody = definition.body.content;
    if (expectedBody == null ? !isBodyNull(request.body) : actualBody !== definition.body.content) {
      throw new ValidationError("Body provided doesn't match epxected body.", definition.body.content, actualBody);
    }
  }
};

const isBodyNull = (body: Buffer | unknown) => {
  if (body == null) {
    return true;
  }

  if (body instanceof Buffer) {
    return body.toString() === "";
  }

  if (typeof body === "object") {
    // eslint-disable-next-line @typescript-eslint/ban-types
    return Object.keys(body as object).length === 0;
  }

  return false;
};
