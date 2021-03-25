import { DeepPartial, Initializer } from "@azure-tools/codegen";

/**
 * The security information for the API surface
 */
export interface Security {
  /**
   * indicates that the API surface requires authentication
   */
  authenticationRequired: boolean;

  schemes: SecurityScheme[];
}

export class Security extends Initializer implements Security {
  constructor(public authenticationRequired: boolean, objectInitializer?: DeepPartial<Security>) {
    super();
    this.schemes = [];
    this.apply(objectInitializer);
  }
}

export type SecurityScheme = AADTokenSecurityScheme | AzureKeyScheme;

export interface AADTokenSecurityScheme {
  name: "AADToken";
  scopes: string[];
}

export interface AzureKeyScheme {
  name: "AzureKey";
  headerName: string;
}
