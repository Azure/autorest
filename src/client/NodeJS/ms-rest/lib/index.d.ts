import * as stream from 'stream';
import * as http from 'http';

/**
 * REST request options
 *  
 * @property {Object.<string, string>} customHeaders - Any additional HTTP headers to be added to the request
 * @proprerty {boolean} jar - If true, remember cookies for future use
 */
export interface RequestOptions {
  customHeaders?: { [headerName: string]: string; };
  jar: boolean;
}

/**
 * Service client options, used for all REST requests initiated by the service client.
 * 
 * @property {Array} [filters]                  - Filters to be added to the request pipeline
 * @property {RequestOptions} requestOptions    - Default RequestOptions to use for requests 
 * @property {boolean}  noRetryPolicy           - If set to true, turn off default retry policy
 */
export interface ServiceClientOptions {
  filters?: any[];
  requestOptions?: RequestOptions;
  noRetryPolicy?: boolean;
}

export class ServiceClient {
  /**
   * Initializes a new instance of the ServiceClient class.
   *
   * @param {ServiceClientCredentials} [credentials]    - BasicAuthenticationCredentials or 
   * TokenCredentials object used for authentication. 
   * @param {ServiceClientOptions} [options] The parameter options
   */
  constructor(credentials?: ServiceClientCredentials, options?: ServiceClientOptions);
}

export interface ServiceError extends Error {
  statusCode: number;
  request: WebResource;
  response: http.IncomingMessage;
  body: any;
}

export interface ServiceCallback<TResult> { (err: Error | ServiceError, result: TResult, request: WebResource, response: http.IncomingMessage): void }

/**
 * Creates a new 'ExponentialRetryPolicyFilter' instance.
 *
 * @constructor
 * @param {number} retryCount        The client retry count.
 * @param {number} retryInterval     The client retry interval, in milliseconds.
 * @param {number} minRetryInterval  The minimum retry interval, in milliseconds.
 * @param {number} maxRetryInterval  The maximum retry interval, in milliseconds.
 */
export class ExponentialRetryPolicyFilter {
  constructor(retryCount: number, retryInterval: number, minRetryInterval: number, maxRetryInterval: number);
}

/**
 * This class provides an abstraction over a REST call by being library / implementation agnostic and wrapping the necessary
 * properties to initiate a request.
 */
export class WebResource {
  constructor();

    /**
     * Creates a new put request web resource.
     *
     * @param {string} path The path for the put operation.
     * @return {WebResource} A new WebResource with a put operation for the given path.
     */
    static put(path: string): WebResource;

    /**
     * Creates a new get request web resource.
     *
     * @param {string} path The path for the get operation.
     * @return {WebResource} A new WebResource with a get operation for the given path.
     */
    static get(path: string): WebResource;
    
    /**
     * Creates a new head request web resource.
     *
     * @param {string} path The path for the head operation.
     * @return {WebResource} A new WebResource with a head operation for the given path.
     */
    static head(path: string): WebResource;

    /**
     * Creates a new delete request web resource.
     *
     * @param {string} path The path for the delete operation.
     * @return {WebResource} A new WebResource with a delete operation for the given path.
     */
    static del(path: string): WebResource;
  
  /**
   * Creates a new post request web resource.
   *
   * @param {string} path The path for the post operation.
   * @return {WebResource} A new WebResource with a post operation for the given path.
   */
  static post(path: string): WebResource;

  /**
   * Creates a new merge request web resource.
   *
   * @param {string} path The path for the merge operation.
   * @return {WebResource} A new WebResource with a merge operation for the given path.
   */
  static merge(path: string): WebResource;

  /**
   * Creates a new patch request web resource.
   *
   * @param {string} path The path for the patch operation.
   * @return {WebResource} A new WebResource with a patch operation for the given path.
   */
  static patch(path: string): WebResource;

  /**
   * Specifies a custom property in the web resource.
   *
   * @param {string} name  The property name.
   * @param {string} value The property value.
   * @return {WebResource} The WebResource.
   */
  withProperty(name: string, value: string): WebResource;

  /**
   * Specifies if the response should be parsed or not.
   *
   * @param {bool} rawResponse true if the response should not be parse; false otherwise.
   * @return {WebResource} The WebResource.
   */
  withRawResponse(rawResponse: boolean): WebResource;

  withHeadersOnly(headersOnly: boolean): WebResource;

  /**
   * Adds an optional query string parameter.
   *
   * @param {Object} name          The name of the query string parameter.
   * @param {Object} value         The value of the query string parameter.
   * @param {Object} defaultValue  The default value for the query string parameter to be used if no value is passed.
   * @return {Object} The web resource.
   */
  withQueryOption(name: any, value:  any, defaultValue:  any): WebResource;

  /**
   * Adds optional query string parameters.
   *
   * Additional arguments will be the needles to search in the haystack. 
   *
   * @param {Object} object  The haystack of query string parameters.
   * @return {Object} The web resource.
   */
  withQueryOptions(object: { [option: string]: any; }): WebResource; 

  /**
   * Adds an optional header parameter.
   *
   * @param {Object} name  The name of the header parameter.
   * @param {Object} value The value of the header parameter.
   * @return {Object} The web resource.
   */
  withHeader(name: any, value: any): WebResource;

  /**
   * Adds an optional body.
   *
   * @param {Object} body  The request body.
   * @return {Object} The web resource.
   */
  withBody(body: any): WebResource;

  /**
   * Adds optional query string parameters.
   *
   * Additional arguments will be the needles to search in the haystack. 
   *
   * @param {Object} object  The haystack of headers.
   * @return {Object} The web resource.
   */
  withHeaders(object: { [header: string]: any; }): WebResource;
  

  addOptionalMetadataHeaders(metadata: { [header: string]: any; }): WebResource;

  /**
   * Determines if a status code corresponds to a valid response according to the WebResource's expected status codes.
   *
   * @param {int} statusCode The response status code.
   * @return true if the response is valid; false otherwise.
   */
  validResponse(statusCode: number): boolean;

  /**
   * Hook up the given input stream to a destination output stream if the WebResource method
   * requires a request body and a body is not already set.
   *
   * @param {Stream} inputStream the stream to pipe from
   * @param {Stream} outputStream the stream to pipe to
   *
   * @return destStream
   */
  pipeInput(inputStream: stream.Readable, destStream: stream.Writable): stream.Writable;
}

export class ServiceClientCredentials {
  /**
   * Signs a request with the Authentication header.
   *
   * @param {WebResource} The WebResource to be signed.
   * @param {function(error)}  callback  The callback function.
   */
  signRequest(webResource: WebResource, callback: { (err: Error): void }): void;
}


export class TokenCredentials extends ServiceClientCredentials {
  /**
   * Creates a new TokenCredentials object.
   *
   * @constructor
   * @param {string} token               The token.
   * @param {string} authorizationScheme The authorization scheme. If not specified, the default of 'Bearer" is used.
   */
  constructor(token: string, authorizationScheme?: string);
}

export class BasicAuthenticationCredentials extends ServiceClientCredentials {
  /**
   * Creates a new BasicAuthenticationCredentials object.
   *
   * @constructor
   * @param {string} userName                 User name.
   * @param {string} password                 Password.
   * @param {string} [authorizationScheme]    The authorization scheme. Default ('Basic')
   */
  constructor(userName: string, password: string, authorizationScheme?: string);
}