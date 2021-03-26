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
  name: string;
  scopes?: string[];
  headerName?: string;
}

export interface AADTokenSecurityScheme extends SecurityScheme {
  name: "AADToken";
  scopes: string[];
}

export interface AzureKeyScheme extends SecurityScheme {
  name: "AzureKey";
  headerName: string;
}
