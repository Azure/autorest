import { DeepPartial, Initializer } from "@azure-tools/codegen";

/**
 * The security information for the API surface
 */
export interface Security {
  /**
   * indicates that the API surface requires authentication
   */
  authenticationRequired: boolean;

  /**
   * @items {"type": "SecuritySchemeFull"}
   */
  schemes: SecurityScheme[];
}

export class Security extends Initializer implements Security {
  constructor(public authenticationRequired: boolean, objectInitializer?: DeepPartial<Security>) {
    super();
    this.schemes = [];
    this.apply(objectInitializer);
  }
}

export interface SecurityScheme {
  type: string;
}

export interface OAuth2SecurityScheme extends SecurityScheme {
  type: "OAuth2";
  scopes: string[];
}

export class OAuth2SecurityScheme implements OAuth2SecurityScheme {
  public constructor(objectInitializer?: DeepPartial<OAuth2SecurityScheme>) {
    this.type = "OAuth2";
    Object.assign(this, objectInitializer);
  }
}

export interface KeySecurityScheme extends SecurityScheme {
  type: "Key";
  in: "header";
  name: string;
}

export class KeySecurityScheme implements KeySecurityScheme {
  public constructor(objectInitializer?: DeepPartial<KeySecurityScheme>) {
    this.type = "Key";
    Object.assign(this, objectInitializer);
  }
}

/**
 * @deprecated use @see OAuth2SecurityScheme
 */
export interface AADTokenSecurityScheme extends SecurityScheme {
  type: "AADToken";
  scopes: string[];
}

export class AADTokenSecurityScheme implements AADTokenSecurityScheme {
  public constructor(objectInitializer?: DeepPartial<AADTokenSecurityScheme>) {
    this.type = "AADToken";
    Object.assign(this, objectInitializer);
  }
}

/**
 * @deprecated use @see KeySecurityScheme
 */
export interface AzureKeySecurityScheme extends SecurityScheme {
  type: "AzureKey";
  headerName: string;
}

export class AzureKeySecurityScheme implements AzureKeySecurityScheme {
  public constructor(objectInitializer?: DeepPartial<AzureKeySecurityScheme>) {
    this.type = "AzureKey";
    Object.assign(this, objectInitializer);
  }
}
