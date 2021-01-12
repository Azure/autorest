export type HttpMethod = "get" | "post" | "put" | "patch" | "head" | "delete";

export interface MockRouteDefinition {
  request: MockRouteRequestDefinition;
  response: MockRouteResponseDefinition;
}

export interface MockRouteRequestDefinition {
  url: string;
  method: HttpMethod;
  headers?: { [key: string]: string };
  body?: RequestBodyRequirement;
}

export interface MockRouteResponseDefinition {
  status: number;
  headers?: { [key: string]: string };
  body?: MockBody;
}

export interface MockBody {
  contentType?: string;
  rawContent?: string;
}

export interface RequestBodyRequirementBase {
  /**
   * Content type.
   */
  contentType?: string;

  /**
   * Raw content of the body.
   */
  rawContent: string;
}

/**
 * Match the raw content exactly.(Default)
 */
type ExactMatch = {
  matchType?: "exact";
};

/**
 * Does a deep equal with the body.
 */
type ObjectMatch = {
  matchType: "object";
  content: unknown;
};

export type RequestBodyRequirement = RequestBodyRequirementBase & (ExactMatch | ObjectMatch);
