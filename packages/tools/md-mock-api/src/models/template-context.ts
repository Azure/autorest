/**
 * Context available in a response. This can be used in templates
 * @example "{{request.baseUrl}}/some/path"
 */
export interface TemplateContext {
  request: RequestContext;
}

export interface RequestContext {
  /**
   * Base url for the request(e.g. http://localhost:3000)
   */
  baseUrl: string;

  /**
   * Headers use in the request(key lowercase).
   */
  headers: { [key: string]: string | string[] | undefined };
}
