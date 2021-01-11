import { Request } from "express";
import { MockRouteRequestDefinition } from "../models";

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
 * @throws {ValidationError} when validation fails.
 */
export const validateRequest = (definition: MockRouteRequestDefinition, request: Request): void => {
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
