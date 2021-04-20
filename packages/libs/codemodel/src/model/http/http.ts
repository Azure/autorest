import { SerializationStyle } from "./serialization-style";
import { HttpMethod } from "./http-method";
import { ParameterLocation } from "./parameter-location";
import { Protocol } from "../common/metadata";
import { StatusCode } from "./status-code";
import { SecurityRequirement } from "./security";
import { Schema } from "../common/schema";
import { DeepPartial, KnownMediaType, Initializer } from "@azure-tools/codegen";
import { Extensions } from "../common/extensions";
import { GroupSchema } from "../common/schemas/object";
import { Languages } from "../common/languages";
import { Deprecation } from "../common/deprecation";

/** extended metadata for HTTP operation parameters  */
export interface HttpParameter extends Protocol {
  /** the location that this parameter is placed in the http request */
  in: ParameterLocation;

  /** the Serialization Style used for the parameter. */
  style?: SerializationStyle;

  /** when set, 'form' style parameters generate separate parameters for each value of an array. */
  explode?: boolean;

  /** when set, this indicates that the content of the parameter should not be subject to URI encoding rules. */
  skipUriEncoding?: boolean;
}

export class HttpParameter extends Protocol {
  constructor(location: ParameterLocation, objectInitializer?: DeepPartial<HttpParameter>) {
    super();
    this.in = location;
    this.apply(objectInitializer);
  }
}

/** HTTP operation protocol data */
export interface HttpRequest extends Protocol {
  /** A relative path to an individual endpoint.
   *
   * The field name MUST begin with a slash.
   * The path is appended (no relative URL resolution) to the expanded URL from the Server Object's url field in order to construct the full URL.
   * Path templating is allowed.
   *
   * When matching URLs, concrete (non-templated) paths would be matched before their templated counterparts.  */
  path: string;

  /** the base URI template for the operation. This will be a template that has Uri parameters to craft the base url to use. */
  uri: string;

  /** the HTTP Method used to process this operation */
  method: HttpMethod;
}

export class HttpRequest extends Protocol {}

export interface HttpWithBodyRequest extends HttpRequest {
  /** a normalized value for the media type (ie, distills down to a well-known moniker (ie, 'json')) */
  knownMediaType: KnownMediaType;

  /** must contain at least one media type to send for the body */
  mediaTypes: Array<string>;
}

export class HttpWithBodyRequest extends HttpRequest implements HttpWithBodyRequest {
  constructor(objectInitializer?: Partial<HttpWithBodyRequest>) {
    super();
    this.apply(objectInitializer);
  }
}

export interface HttpBinaryRequest extends HttpWithBodyRequest {
  /* indicates that the HTTP request should be a binary, not a serialized object */
  binary: true;
}

export class HttpBinaryRequest extends HttpWithBodyRequest implements HttpBinaryRequest {}

export interface HttpMultipartRequest extends HttpWithBodyRequest {
  /** indicates that the HTTP Request should be a multipart request
   *
   * ie, that it has multiple requests in a single request.
   */
  multipart: true;
}

export class HttpMultipartRequest extends HttpWithBodyRequest implements HttpMultipartRequest {
  multipart = <const>true;
}

export interface HttpHeader extends Extensions {
  header: string;
  schema: Schema;
  language: Languages;
}

export class HttpHeader extends Initializer implements HttpHeader {
  constructor(public header: string, public schema: Schema, objectInitializer?: DeepPartial<HttpHeader>) {
    super();
    this.apply(objectInitializer);
  }
}

export interface HttpResponse extends Protocol {
  /** the possible HTTP status codes that this response MUST match one of. */
  statusCodes: Array<StatusCode>; // oai3 supported options.

  /**
   * canonical response type (ie, 'json').
   */
  knownMediaType?: KnownMediaType;

  /**
   * The possible media types that this response MUST match one of.
   */
  mediaTypes?: Array<string>; // the response mediaTypes that this should apply to (ie, 'application/json')

  /** content returned by the service in the HTTP headers */
  headers?: Array<HttpHeader>;

  /** sets of HTTP headers grouped together into a single schema */
  headerGroups?: Array<GroupSchema>;
}

export class HttpResponse extends Protocol implements HttpResponse {}

export interface HttpBinaryResponse extends HttpResponse {
  /** binary responses  */
  binary: true;
}

export class HttpBinaryResponse extends HttpResponse implements HttpBinaryResponse {}

/** code model metadata for HTTP protocol  */
export interface HttpModel extends Protocol {
  /** a collection of security requirements for the service */
  security?: Array<SecurityRequirement>;
}

export class HttpModel extends Protocol implements HttpModel {}
