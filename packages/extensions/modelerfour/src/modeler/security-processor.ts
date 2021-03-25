import { Security, SecurityScheme } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import * as oai3 from "@azure-tools/openapi";
import { dereference, ParameterLocation, Refable } from "@azure-tools/openapi";
import { Interpretations } from "./interpretations";

export enum KnownSecurityScheme {
  AADToken = "AADToken",
  AzureKey = "AzureKey",
}

const KnownSecuritySchemeList = Object.values(KnownSecurityScheme);
/**
 * Body processing functions
 */
export class SecurityProcessor {
  public constructor(private session: Session<oai3.Model>, private interpret: Interpretations) {}

  /**
   * Process the security definition defined in OpenAPI
   */
  public process(openApiModel: oai3.Model): Security {
    const oai3Schemes = Object.values(openApiModel.components?.securitySchemes ?? {});
    const security = openApiModel.security;
    if (!security || oai3Schemes.length === 0) {
      return new Security(false);
    }

    const schemeMap = this.resolveOpenAPI3SecuritySchemes(oai3Schemes);
    const schemes: SecurityScheme[] = [];
    for (const oai3SecurityRequirement of security) {
      const names = Object.keys(oai3SecurityRequirement);
      if (names.length > 1) {
        throw new Error(
          `Security defines multiple requirements at the same time which is not supported. ${oai3SecurityRequirement}`,
        );
      }
      if (names.length === 0) {
        throw new Error(`Invalid empty security requirement`);
      }

      const name = names[0];
      const scheme = schemeMap.get(name);
      if (!scheme) {
        throw new Error(`Couldn't find a scheme defined in the securitySchemes with name: ${name}`);
      }

      const processedScheme = this.processSecurityScheme(name, oai3SecurityRequirement[name], scheme);
      if (processedScheme !== undefined) {
        schemes.push(processedScheme);
      } else {
        this.session.warning(
          `Security scheme ${name} is unknown and will not be processed. Only supported types are ${KnownSecuritySchemeList}`,
          ["UnkownSecurityScheme"],
        );
      }
    }

    return new Security(true, {
      schemes,
    });
  }

  private resolveOpenAPI3SecuritySchemes(
    oai3Schemes: Refable<oai3.SecurityScheme>[],
  ): Map<string, oai3.SecurityScheme> {
    const map = new Map<string, oai3.SecurityScheme>();

    for (const value of oai3Schemes) {
      const scheme = dereference(this.session.model, value);
      const name = this.interpret.getName("", scheme.instance);
      map.set(name, scheme.instance);
    }
    return map;
  }

  private processSecurityScheme(
    name: string,
    scopes: string[],
    scheme: oai3.SecurityScheme,
  ): SecurityScheme | undefined {
    if (name === KnownSecurityScheme.AADToken) {
      return {
        name: "AADToken",
        scopes: scopes,
      };
    } else if (name === KnownSecurityScheme.AzureKey) {
      if (scheme.type !== oai3.SecurityType.ApiKey) {
        throw new Error(`AzureKey security scheme should be of type 'apiKey' but was '${scheme.type}'`);
      }

      if (scheme.in !== ParameterLocation.Header) {
        throw new Error(`AzureKey security scheme should be of in 'header' but was '${scheme.in}'`);
      }

      return {
        name: "AzureKey",
        headerName: scheme.name,
      };
    } else {
      return undefined;
    }
  }
}
