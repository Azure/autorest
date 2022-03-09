import { OAuth2SecurityScheme, KeySecurityScheme, Security, SecurityScheme } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import * as oai3 from "@azure-tools/openapi";
import { dereference, ParameterLocation, Refable } from "@azure-tools/openapi";
import { Interpretations } from "./interpretations";
import { arrayify } from "./utils";

export enum KnownSecurityScheme {
  AADToken = "AADToken",
  AzureKey = "AzureKey",
  Anonymous = "Anonymous",
}

const KnownSecuritySchemeList = Object.values(KnownSecurityScheme);

const ArmDefaultScope = "https://management.azure.com/.default";
const DefaultHeaderName = "Authorization";

export interface SecurityConfiguration {
  azureArm: boolean;
  security: KnownSecurityScheme[];
  scopes: string[];
  headerName: string;
}

/**
 * Body processing functions
 */
export class SecurityProcessor {
  private securityConfig!: SecurityConfiguration;
  public constructor(private session: Session<oai3.Model>, private interpret: Interpretations) {}

  public async init() {
    this.securityConfig = await this.getSecurityConfig();
    return this;
  }

  /**
   * Process the security definition defined in OpenAPI
   */
  public process(openApiModel: oai3.Model): Security {
    const securityFromSpec = this.getSecurityFromOpenAPISpec(openApiModel);
    const securityFromConfig = this.getSecurityFromConfig();
    const securityFromArm = this.getSecurityForAzureArm();

    if (securityFromSpec && (securityFromConfig || securityFromArm)) {
      this.session.warning(
        "OpenAPI spec has a security definition but autorest security config is defined. Security config from autorest will be used.",
        ["SecurityDefinedSpecAndConfig"],
      );
    }
    if (securityFromArm && securityFromConfig) {
      this.session.warning("OpenAPI spec has both 'security' and 'azure-arm' defined. Ignoring 'security'.", [
        "SecurityAndAzureArmDefined",
      ]);
    }

    return securityFromArm ?? securityFromConfig ?? securityFromSpec ?? new Security(false);
  }

  private getSecurityForAzureArm(): Security | undefined {
    if (!this.securityConfig.azureArm) {
      return undefined;
    }

    return new Security(true, {
      schemes: [
        new OAuth2SecurityScheme({
          scopes: this.securityConfig.scopes ?? [ArmDefaultScope],
        }),
      ],
    });
  }
  /**
   * Build the security object from the autorest configuration
   */
  private getSecurityFromConfig(): Security | undefined {
    const schemeList = this.securityConfig.security.map((x) => this.getSecuritySchemeFromConfig(x));
    if (schemeList.length === 0) {
      return undefined;
    }

    const schemes = [];
    let authenticationRequired = true;
    for (const scheme of schemeList) {
      if (scheme === undefined) {
        authenticationRequired = false;
      } else {
        schemes.push(scheme);
      }
    }
    return new Security(authenticationRequired, { schemes });
  }

  /**
   * @param name Name of the security scheme
   * @returns CodeModel security scheme with given name, undefined if this is anonymous security and throw an error if unknown.
   */
  private getSecuritySchemeFromConfig(name: string): SecurityScheme | undefined {
    switch (name) {
      case KnownSecurityScheme.AADToken:
        return new OAuth2SecurityScheme({
          scopes: this.securityConfig.scopes,
        });
      case KnownSecurityScheme.AzureKey:
        return new KeySecurityScheme({
          in: "header",
          name: this.securityConfig.headerName,
        });
      case KnownSecurityScheme.Anonymous:
        return undefined;
      default:
        throw new Error(`Unexpected security scheme '${name}'. Only known schemes are ${KnownSecuritySchemeList}`);
    }
  }

  /**
   * Build the security object from the OpenAPI spec.
   */
  private getSecurityFromOpenAPISpec(openApiModel: oai3.Model): Security | undefined {
    const oai3Schemes = Object.values(openApiModel.components?.securitySchemes ?? {});
    const security = openApiModel.security;
    if (!security || oai3Schemes.length === 0) {
      return undefined;
    }

    const schemeMap = this.resolveOpenAPI3SecuritySchemes(oai3Schemes);
    const schemes: SecurityScheme[] = [];
    let authenticationRequired = true;
    for (const oai3SecurityRequirement of security) {
      const names = Object.keys(oai3SecurityRequirement);
      if (names.length > 1) {
        this.session.warning(
          [
            `Security defines multiple requirements at the same time which is not supported(${names.join(",")}).`,
            `Did you meant to have multiple authentication options instead? Define each option seperately in your spec:`,
            JSON.stringify(
              names.map((x) => ({ [x]: oai3SecurityRequirement[x] })),
              null,
              2,
            ),
          ].join("\n"),
          ["MultipleSecurityLayerUnsupported"],
        );
        continue;
      }

      if (names.length === 0) {
        authenticationRequired = false;
      } else {
        const name = names[0];
        const scheme = schemeMap.get(name);
        if (!scheme) {
          throw new Error(`Couldn't find a scheme defined in the securitySchemes with name: ${name}`);
        }

        const processedScheme = this.processSecurityScheme(oai3SecurityRequirement[name], scheme);
        if (processedScheme !== undefined) {
          schemes.push(processedScheme);
        } else {
          this.session.warning(
            `Security scheme ${name} is unknown and will not be processed. Only supported types are ${KnownSecuritySchemeList}`,
            ["UnkownSecurityScheme"],
          );
        }
      }
    }

    return new Security(authenticationRequired, {
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

  private processSecurityScheme(scopes: string[], scheme: oai3.SecurityScheme): SecurityScheme | undefined {
    if (scheme.type === "oauth2") {
      return new OAuth2SecurityScheme({
        scopes: scopes,
      });
    } else if (scheme.type === "apiKey") {
      if (scheme.in !== ParameterLocation.Header) {
        throw new Error(`AzureKey security scheme should be of in 'header' but was '${scheme.in}'`);
      }

      return new KeySecurityScheme({
        name: scheme.name,
        in: "header",
      });
    } else {
      return undefined;
    }
  }

  private async getSecurityConfig(): Promise<SecurityConfiguration> {
    return {
      azureArm: await this.session.getValue("azure-arm", false),
      security: arrayify(await this.session.getValue("security", [])),
      scopes: arrayify(await this.session.getValue("security-scopes", [ArmDefaultScope])),
      headerName: await this.session.getValue("security-header-name", DefaultHeaderName),
    };
  }
}
