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
  content: string;
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

type ExactMatch = {
  matchType: "exact";
};

type ObjectMatch = {
  matchType: "object";
  content: unknown;
};

export type RequestBodyRequirement = RequestBodyRequirementBase & (ExactMatch | ObjectMatch);
