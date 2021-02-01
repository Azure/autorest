/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Dictionary } from "@azure-tools/linq";
import { Initializer, DeepPartial } from "@azure-tools/codegen";
import { Extensions } from "../common/extensions";
import { uri } from "../common/uri";
import { ParameterLocation } from "./parameter-location";

export enum Scheme {
  Bearer = "bearer",
}

export enum SecurityType {
  ApiKey = "apiKey",
  Http = "http",
  OAuth2 = "oauth2",
  OpenIDConnect = "openIdConnect",
}

export interface AuthorizationCodeOAuthFlow extends Extensions {
  authorizationUrl: uri; // uriref
  tokenUrl: uri; // uriref
  refreshUrl?: uri; // uriref
  scopes: Dictionary<string>;
}

export interface BearerHTTPSecurityScheme extends Extensions {
  scheme: Scheme.Bearer;
  bearerFormat?: string;
  type: SecurityType.Http;
  description?: string;
}

export interface ClientCredentialsFlow extends Extensions {
  tokenUrl: uri; // uriref
  refreshUrl?: uri; // uriref
  scopes: Dictionary<string>;
}

export interface ImplicitOAuthFlow extends Extensions {
  authorizationUrl: uri; // uriref
  refreshUrl?: uri; // uriref
  scopes: Dictionary<string>;
}

export interface NonBearerHTTPSecurityScheme extends Extensions {
  scheme: string;
  description?: string;
  type: SecurityType.Http;
}

export interface OAuth2SecurityScheme extends Extensions {
  type: SecurityType.OAuth2;
  flows: OAuthFlows;
  description?: string;
}

export interface OAuthFlows extends Extensions {
  implicit?: ImplicitOAuthFlow;
  password?: PasswordOAuthFlow;
  clientCredentials?: ClientCredentialsFlow;
  authorizationCode?: AuthorizationCodeOAuthFlow;
}

export type HTTPSecurityScheme = NonBearerHTTPSecurityScheme | BearerHTTPSecurityScheme;
export type SecurityScheme =
  | APIKeySecurityScheme
  | HTTPSecurityScheme
  | OAuth2SecurityScheme
  | OpenIdConnectSecurityScheme;

export interface APIKeySecurityScheme extends Extensions {
  type: SecurityType.ApiKey;
  name: string;
  in: ParameterLocation;
  description?: string;
}

export class APIKeySecurityScheme extends Initializer implements APIKeySecurityScheme {
  constructor(public name: string, inWhere: ParameterLocation, initializer?: DeepPartial<APIKeySecurityScheme>) {
    super();
    this.in = inWhere;
    this.type = SecurityType.ApiKey;
    this.apply(initializer);
  }
}

export class BearerHTTPSecurityScheme extends Initializer implements BearerHTTPSecurityScheme {
  scheme = Scheme.Bearer;

  constructor(initializer?: DeepPartial<BearerHTTPSecurityScheme>) {
    super();
    this.type = SecurityType.Http;
    this.apply(initializer);
  }
}

export class ImplicitOAuthFlow extends Initializer implements ImplicitOAuthFlow {
  scopes = new Dictionary<string>();

  constructor(public authorizationUrl: string, initializer?: DeepPartial<ImplicitOAuthFlow>) {
    super();
    this.apply(initializer);
  }
}

export class NonBearerHTTPSecurityScheme extends Initializer implements NonBearerHTTPSecurityScheme {
  constructor(public scheme: string, initializer?: DeepPartial<NonBearerHTTPSecurityScheme>) {
    super();
    this.apply(initializer);
    this.type = SecurityType.Http;
  }
}

export class OAuth2SecurityScheme extends Initializer implements OAuth2SecurityScheme {
  constructor(public flows: OAuthFlows, initializer?: DeepPartial<OAuth2SecurityScheme>) {
    super();
    this.type = SecurityType.OAuth2;
    this.apply(initializer);
  }
}

export class OAuthFlows extends Initializer implements OAuthFlows {
  constructor(initializer?: DeepPartial<OAuthFlows>) {
    super();
    this.apply(initializer);
  }
}

export interface OpenIdConnectSecurityScheme extends Extensions {
  type: SecurityType.OpenIDConnect;
  openIdConnectUrl: uri; // url
  description?: string;
}

export class OpenIdConnectSecurityScheme extends Initializer implements OpenIdConnectSecurityScheme {
  constructor(public openIdConnectUrl: string, initializer?: DeepPartial<OpenIdConnectSecurityScheme>) {
    super();
    this.type = SecurityType.OpenIDConnect;
    this.apply(initializer);
  }
}

export interface PasswordOAuthFlow extends Extensions {
  tokenUrl: uri; // uriref
  refreshUrl?: uri; // uriref
  scopes: Dictionary<string>;
}

export class PasswordOAuthFlow extends Initializer implements PasswordOAuthFlow {
  scopes = new Dictionary<string>();

  constructor(public tokenUrl: string, initializer?: DeepPartial<PasswordOAuthFlow>) {
    super();
    this.apply(initializer);
  }
}

export class AuthorizationCodeOAuthFlow extends Initializer implements AuthorizationCodeOAuthFlow {
  scopes = new Dictionary<string>();
  constructor(
    public authorizationUrl: string,
    tokenUrl: string,
    initializer?: DeepPartial<AuthorizationCodeOAuthFlow>,
  ) {
    super();
    this.apply(initializer);
  }
}
export class ClientCredentialsFlow extends Initializer implements ClientCredentialsFlow {
  scopes = new Dictionary<string>();
  constructor(public tokenUrl: string, initializer?: DeepPartial<ClientCredentialsFlow>) {
    super();
    this.apply(initializer);
  }
}

/**
 * @description common ways of serializing simple parameters
 * @see https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md#style-values
 */
export interface SecurityRequirement extends Dictionary<string> {}
