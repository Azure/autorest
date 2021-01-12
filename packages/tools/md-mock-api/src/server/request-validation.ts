import { MockRouteRequestDefinition, RequestBodyRequirement } from "../models";
import { RequestExt } from "./request-ext";

class ValidationError extends Error {
  constructor(message: string, public expected: string | undefined, public actual: string | undefined) {
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
export const validateRequest = (definition: MockRouteRequestDefinition, request: RequestExt): void => {
  if (definition.body) {
<<<<<<< HEAD
    validateBodyContent(definition.body, request);
=======
    const actualBody = request.body instanceof Buffer ? request.body.toString() : JSON.stringify(request.body);
    const expectedBody = definition.body.content;
    if (expectedBody == null ? !isBodyNull(request.body) : actualBody !== definition.body.content) {
      throw new ValidationError("Body provided doesn't match epxected body.", definition.body.content, actualBody);
    }
>>>>>>> 5f4b443b450d9d470eac37d3e0d9c74ffe2db3f8
  }
};

/**
 *
 * @param bodyRequirement Body requirement(s).
 * @param request Express.js request.
 * @throws {ValidationError} when validation fails.
 */
const validateBodyContent = (bodyRequirement: RequestBodyRequirement, request: RequestExt) => {
  console.log("Validate", request.body, request.rawBody);
  const expectedBody = bodyRequirement.rawContent;
  const actualBody = request.rawBody;

  if (expectedBody == null) {
    if (!isBodyEmpty(actualBody)) {
      throw new ValidationError("Body provided doesn't match expected body.", bodyRequirement.rawContent, actualBody);
    }
    return;
  }

  if (bodyRequirement.matchType === "exact") {
    if (actualBody !== bodyRequirement.rawContent) {
      throw new ValidationError("Body provided doesn't match expected body.", bodyRequirement.rawContent, actualBody);
    }
  }

  if (bodyRequirement.matchType === "object") {
    if (actualBody !== bodyRequirement.rawContent) {
      throw new ValidationError("Body provided doesn't match expected body.", bodyRequirement.rawContent, actualBody);
    }
  }
};

/**
 * Check if the provided body is empty.
 * @param body express.js request body.
 */
const isBodyEmpty = (body: string | undefined | null) => {
  return body == null || body === "";
};
