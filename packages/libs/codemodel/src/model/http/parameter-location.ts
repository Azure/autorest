/** the location that this parameter is placed in the http request */
export enum ParameterLocation {
  /**  Parameters that are appended to the URL. For example, in /items?id=###, the query parameter is id */
  Query = "query",

  /**  Custom headers that are expected as part of the request. Note that RFC7230 states header names are case insensitive. */
  Header = "header",

  /** Used to pass a specific cookie value to the API. */
  Cookie = "cookie",

  /**  Used together with Path Templating, where the parameter value is actually part of the operation's URL. This does not include the host or base path of the API. For example, in /items/{itemId}, the path parameter is itemId. */
  Path = "path",

  /** Used to encode the parameter and send it as the HTTP body  */
  Body = "body",

  /** Used to associate the parameter to the Server/Uri (ie, parameterized host ) */
  Uri = "uri",

  /** Virtual parameters represent a connection to a specific spot in the body */
  Virtual = "virtual",

  /** Not directly used in a request, but may be used indirectly. */
  None = "none",
}
