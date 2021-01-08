export type HttpMethod = "get" | "post" | "put" | "patch" | "head" | "delete";

export interface MockRouteDefinition {
  request: MockRouteRequestDefinition;
  response: MockRouteResponseDefinition;
}

export interface MockRouteRequestDefinition {
  url: string;
  method: HttpMethod;
  headers?: { [key: string]: string };
  body?: MockBody;
}

export interface MockRouteResponseDefinition {
  status: number;
  headers?: { [key: string]: string };
  body: MockBody;
}

export interface MockBody {
  contentType: string;
  content: string;
}
