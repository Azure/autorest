/**
 * Context available in a response. This can be used in templates
 * @example "{{request.baseUrl}}/some/path"
 */
export interface TemplateContext {
  request: RequestContext;
}

export interface RequestContext {
  baseUrl: string;
  headers: { [key: string]: string | string[] | undefined };
}
