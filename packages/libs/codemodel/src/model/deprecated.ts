/**
 * This file contains model that have been deprecated and should not be present in the codemodel produced by modelerfour.
 * They are kept here to reduce the breaking changes in generator that don't pin their dependencies.
 */

import { DeepPartial } from "@azure-tools/codegen";
import { SecurityScheme } from "./common/security";

/**
 * @deprecated use @see OAuth2SecurityScheme
 */
export interface AADTokenSecurityScheme extends SecurityScheme {
  type: "AADToken";
  scopes: string[];
}

/**
 * @deprecated use @see OAuth2SecurityScheme
 */
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

/**
 * @deprecated use @see OAuth2SecurityScheme
 */
export class AzureKeySecurityScheme implements AzureKeySecurityScheme {
  public constructor(objectInitializer?: DeepPartial<AzureKeySecurityScheme>) {
    this.type = "AzureKey";
    Object.assign(this, objectInitializer);
  }
}
