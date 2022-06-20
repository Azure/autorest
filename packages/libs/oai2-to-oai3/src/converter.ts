/* eslint-disable @typescript-eslint/no-non-null-asserted-optional-chain */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import {
  Node,
  visit,
  MappingTreeObject,
  ProxyValue,
  MappingTreeArray,
  PathMapping,
  NoMapping,
  createMappingTree,
} from "@azure-tools/datastore";
import { JsonPointer, getFromJsonPointer, appendJsonPointer } from "@azure-tools/json";
import { includeXDashKeys, isExtensionKey, PathReference, Refable } from "@azure-tools/openapi";
import {
  OpenAPI2Document,
  OpenAPI2ResponseHeader,
  OpenAPI2Operation,
  OpenAPI2OperationResponse,
  OpenAPI2BodyParameter,
  OpenAPI2FormDataParameter,
  HttpMethod,
  OpenAPI2Parameter,
} from "@azure-tools/openapi/v2";
import oai3, {
  OpenAPI3Document,
  EncodingStyle,
  HttpOperation,
  JsonType,
  PathItem,
  SecurityType,
  OAuth2SecurityScheme,
} from "@azure-tools/openapi/v3";
import { resolveOperationConsumes, resolveOperationProduces } from "./content-type-utils";
import { cleanElementName, convertOai2RefToOai3, parseOai2Ref } from "./refs-utils";
import { ResolveReferenceFn } from "./runner";
import { statusCodes } from "./status-codes";

// NOTE: after testing references should be changed to OpenAPI 3.x.x references

export interface SourceLocation {
  document: string;
  path: string;
}

export interface ConverterDiagnostic {
  /**
   * Reprensent the diagnostic code describing the type of issue.
   * Diagnostic codes could be documented to help user understand how to resolve this type of issue
   */
  readonly code: string;

  /**
   * Message.
   */
  readonly message: string;

  /**
   * location where the problem was found.
   */
  readonly source?: SourceLocation[];

  /**
   * Additional details.
   */
  readonly details?: Error | unknown;
}

export interface ConverterLogger {
  trackError(diag: ConverterDiagnostic): void;
  trackWarning(diag: ConverterDiagnostic): void;
}

export class Oai2ToOai3 {
  public generated: MappingTreeObject<OpenAPI3Document>;
  public mappings: PathMapping[] = [];

  constructor(
    private logger: ConverterLogger,
    protected originalFilename: string,
    protected original: OpenAPI2Document,
    private resolveExternalReference?: ResolveReferenceFn,
  ) {
    this.generated = createMappingTree<oai3.Model>(this.originalFilename, {}, this.mappings);
  }

  async convert() {
    // process servers
    if (this.original["x-ms-parameterized-host"]) {
      const xMsPHost: any = this.original["x-ms-parameterized-host"];
      const scheme =
        xMsPHost.useSchemePrefix === false ? "" : (this.original.schemes || ["http"]).map((s) => s + "://")[0] || "";
      const server: oai3.Server = {
        url: scheme + xMsPHost.hostTemplate + (this.original.basePath || ""),
      };
      if (xMsPHost.positionInOperation) {
        server["x-ms-parameterized-host"] = { positionInOperation: xMsPHost.positionInOperation };
      }
      server.variables = {};
      for (const msp in xMsPHost.parameters) {
        if (!msp.startsWith("x-")) {
          let originalParameter: any = {};
          const param: any = {};
          if (xMsPHost.parameters[msp].$ref !== undefined) {
            const parsedRef = parseOai2Ref(xMsPHost.parameters[msp].$ref);

            if (parsedRef === undefined) {
              throw new Error(`Reference ${xMsPHost.parameters[msp].$ref} is invalid. Check the syntax.`);
            }

            originalParameter = await this.resolveReference(parsedRef.file, parsedRef.path);
            if (originalParameter === undefined) {
              throw new Error(`Unable to resolve ${xMsPHost.parameters[msp].$ref}.`);
            }

            // $ref'd parameters should be client parameters
            if (!originalParameter["x-ms-parameter-location"]) {
              originalParameter["x-ms-parameter-location"] = "client";
            }
            originalParameter["x-ms-original"] = {
              $ref: await this.convertReferenceToOai3(xMsPHost.parameters[msp].$ref),
            };
          } else {
            originalParameter = xMsPHost.parameters[msp];
          }

          // TODO: Investigate why its not possible to copy
          // properties and filter the property 'in' using
          // object destructuring.
          for (const key in originalParameter) {
            switch (key) {
              case "in":
              case "required":
              case "type":
              case "format":
              case "name":
                // turn these into x-* properties
                param[`x-${key}`] = originalParameter[key];
                break;
              default:
                param[key] = originalParameter[key];
                break;
            }
          }

          const parameterName = originalParameter.name;
          if (originalParameter.default === undefined) {
            if (originalParameter.enum) {
              param.default = originalParameter.enum[0];
            } else {
              param.default = "";
            }
          }
          // don't have empty parameters
          if (parameterName) {
            server.variables[parameterName] = param;
          }
        }
      }

      this.generated.__set__("servers", this.newArray("/x-ms-parameterized-host"));
      this.generated.servers!.__push__({ value: server, sourcePointer: "/x-ms-parameterized-host" });
    } else if (this.original.host) {
      if (this.generated.servers === undefined) {
        this.generated.__set__("servers", this.newArray("/host"));
      }
      for (const { value: s, pointer } of visit(this.original.schemes)) {
        const server: oai3.Server = {
          url: (s ? s + ":" : "") + "//" + this.original.host + (this.original.basePath ? this.original.basePath : "/"),
        };

        extractServerParameters(server);

        this.generated.servers?.__push__({ value: server, sourcePointer: pointer });
      }
    } else if (this.original.basePath) {
      const server: any = {};
      server.url = this.original.basePath;
      extractServerParameters(server);
      if (this.generated.servers === undefined) {
        this.generated.__set__("servers", this.newArray("/basePath"));
      }
      this.generated.servers!.__push__({ value: server, sourcePointer: "/basePath" });
    }

    if (this.generated.servers === undefined) {
      this.generated.__set__("servers", { value: [], sourcePointer: NoMapping });
    }

    // internal function to extract server parameters
    function extractServerParameters(server) {
      server.url = server.url.split("{{").join("{");
      server.url = server.url.split("}}").join("}");
      server.url.replace(/\{(.+?)\}/g, function (match, group1) {
        if (!server.variables) {
          server.variables = {};
        }
        server.variables[group1] = { default: "unknown" };
      });
    }

    // extract cosumes and produces
    const globalProduces = this.original.produces ? this.original.produces : ["*/*"];
    const globalConsumes = this.original.consumes ? this.original.consumes : ["application/json"];

    for (const { value, key, pointer, children } of visit(this.original)) {
      switch (key) {
        case "swagger":
          this.generated.__set__("openapi", { value: "3.0.0", sourcePointer: pointer });
          break;
        case "info":
          this.generated.__set__("info", this.newObject(pointer));
          await this.visitInfo(children);
          break;
        case "x-ms-paths":
        case "paths":
          {
            if (!this.generated[key]) {
              this.generated.__set__(key, this.newObject(pointer));
            }
            await this.visitPaths(this.generated[key], children, globalConsumes, globalProduces);
          }
          break;
        case "host":
        case "basePath":
        case "schemes":
        case "x-ms-parameterized-host":
          // host, basePath and schemes already processed
          break;
        case "consumes":
        case "produces":
          // PENDING
          break;
        case "definitions":
          await this.visitDefinitions(children);
          break;
        case "parameters":
          await this.visitParameterDefinitions(children);
          break;
        case "responses":
          if (!this.generated.components) {
            this.generated.__set__("components", this.newObject(pointer));
          }
          this.generated.components?.__set__("responses", this.newObject(pointer));
          await this.visitResponsesDefinitions(children, globalProduces);
          break;
        case "securityDefinitions":
          if (!this.generated.components) {
            this.generated.__set__("components", this.newObject(pointer));
          }
          this.generated.components?.__set__("securitySchemes", this.newObject(pointer));
          await this.visitSecurityDefinitions(children);
          break;
        // no changes to security from OA2 to OA3
        case "security":
          this.generated.__set__("security", { value, sourcePointer: pointer });
          break;
        case "tags":
          this.generated.__set__("tags", this.newArray(pointer));
          await this.visitTags(this.generated.tags!, children);
          break;
        case "externalDocs":
          this.visitExternalDocs(this.generated, key, value, pointer);
          break;
        default:
          // handle stuff liks x-* and things not recognized
          await this.visitExtensions(this.generated, key, value, pointer);
          break;
      }
    }

    return this.generated;
  }

  async visitParameterDefinitions(parameters: Iterable<Node>) {
    for (const { key, value, pointer, childIterator } of parameters) {
      if (value.in !== "formData" && value.in !== "body" && value.type !== "file") {
        if (this.generated.components === undefined) {
          this.generated.__set__("components", this.newObject(pointer));
        }

        if (this.generated.components!.parameters === undefined) {
          this.generated.components?.__set__("parameters", this.newObject(pointer));
        }

        const cleanParamName = cleanElementName(key);
        this.generated.components!.parameters!.__set__(cleanParamName, this.newObject(pointer));
        await this.visitParameter(
          this.generated.components!.parameters![cleanParamName] as any,
          value,
          pointer,
          childIterator,
        );
      }
    }
  }
  private async visitParameter(
    parameterTarget: MappingTreeObject<Refable<oai3.Parameter>>,
    parameterValue: any,
    sourcePointer: string,
    parameterItemMembers: () => Iterable<Node>,
  ) {
    if (this.isTargetReference(parameterTarget, parameterValue)) {
      return this.copyRef(parameterTarget, parameterValue, sourcePointer);
    } else {
      await this.visitParameterDefinition(parameterTarget, parameterValue, sourcePointer, parameterItemMembers);
    }
  }

  private isTargetReference<I, T>(
    target: MappingTreeObject<Refable<T>>,
    value: Refable<I>,
  ): target is MappingTreeObject<PathReference> {
    return "$ref" in value;
  }

  private async copyRef(target: MappingTreeObject<PathReference>, value: PathReference, sourcePointer: string) {
    target.__set__("$ref", { value: await this.convertReferenceToOai3(value.$ref), sourcePointer });
  }

  private async visitParameterDefinition(
    parameterTarget: MappingTreeObject<oai3.Parameter>,
    parameterValue: any,
    sourcePointer: string,
    parameterItemMembers: () => Iterable<Node>,
  ) {
    const parameterUnchangedProperties = ["name", "in", "description", "allowEmptyValue", "required"];

    for (const key of parameterUnchangedProperties) {
      if (parameterValue[key] !== undefined) {
        parameterTarget.__set__(key as any, { value: parameterValue[key], sourcePointer });
      }
    }

    if (parameterValue["x-ms-skip-url-encoding"] !== undefined) {
      if (parameterValue.in === "query") {
        parameterTarget.__set__("allowReserved", { value: true, sourcePointer });
      } else {
        parameterTarget.__set__("x-ms-skip-url-encoding", {
          value: parameterValue["x-ms-skip-url-encoding"],
          sourcePointer,
        });
      }
    }

    /**
     * List of extension properties that shouldn't just be passed through.
     */
    const extensionPropertiesCustom = new Set(["x-ms-skip-url-encoding", "x-ms-original", "x-ms-enum"]);

    for (const key of includeXDashKeys(parameterValue)) {
      if (parameterValue[key] !== undefined && !extensionPropertiesCustom.has(key)) {
        parameterTarget.__set__(key, { value: parameterValue[key], sourcePointer });
      }
    }

    // Collection Format
    if (parameterValue.type === "array") {
      parameterValue.collectionFormat = parameterValue.collectionFormat || "csv";
      if (
        parameterValue.collectionFormat === "csv" &&
        (parameterValue.in === "query" || parameterValue.in === "cookie")
      ) {
        parameterTarget.__set__("style", { value: EncodingStyle.Form, sourcePointer });
      }
      if (
        parameterValue.collectionFormat === "csv" &&
        (parameterValue.in === "path" || parameterValue.in === "header")
      ) {
        parameterTarget.__set__("style", { value: EncodingStyle.Simple, sourcePointer });
      }
      if (parameterValue.collectionFormat === "ssv") {
        if (parameterValue.in === "query") {
          parameterTarget.__set__("style", { value: EncodingStyle.SpaceDelimited, sourcePointer });
        }
      }
      if (parameterValue.collectionFormat === "pipes") {
        if (parameterValue.in === "query") {
          parameterTarget.__set__("style", { value: EncodingStyle.PipeDelimited, sourcePointer });
        }
      }
      if (parameterValue.collectionFormat === "multi") {
        parameterTarget.__set__("style", { value: EncodingStyle.Form, sourcePointer });
        parameterTarget.__set__("explode", { value: true, sourcePointer });
      }

      // tsv is no longer supported in OAI3, but we still need to support this.
      if (parameterValue.collectionFormat === "tsv") {
        parameterTarget.__set__("style", { value: EncodingStyle.TabDelimited, sourcePointer });
      }
    }

    if (parameterTarget.schema === undefined) {
      parameterTarget.__set__("schema", this.newObject(sourcePointer));
    }

    const schema: MappingTreeObject<oai3.Schema> = parameterTarget.schema as any;

    const schemaKeys = [
      "maximum",
      "exclusiveMaximum",
      "minimum",
      "exclusiveMinimum",
      "maxLength",
      "minLength",
      "pattern",
      "maxItems",
      "minItems",
      "uniqueItems",
      "enum",
      "x-ms-enum",
      "multipleOf",
      "default",
      "format",
    ];

    for (const { key, childIterator, pointer: jsonPointer } of parameterItemMembers()) {
      if (key === "schema") {
        if (schema.items === undefined) {
          schema.__set__("items", this.newObject(jsonPointer));
        }
        await this.visitSchema(schema.items as any, parameterValue.items, childIterator);
      } else if (schemaKeys.indexOf(key) !== -1) {
        schema.__set__(key as any, { value: parameterValue[key], sourcePointer });
      }
    }

    if (parameterValue.type !== undefined) {
      schema.__set__("type", { value: parameterValue.type, sourcePointer });
    }

    if (parameterValue.items !== undefined) {
      schema?.__set__("items", this.newObject(sourcePointer));
      for (const { key, childIterator } of parameterItemMembers()) {
        if (key === "items") {
          await this.visitSchema(schema.items as any, parameterValue.items, childIterator);
        }
      }
    }
  }

  async visitInfo(info: Iterable<Node>) {
    for (const { value, key, pointer, children } of info) {
      switch (key) {
        case "title":
        case "description":
        case "termsOfService":
        case "contact":
        case "license":
        case "version":
          this.generated.info.__set__(key, { value, sourcePointer: pointer });
          break;
        default:
          await this.visitExtensions(this.generated.info, key, value, pointer);
          break;
      }
    }
  }

  async visitSecurityDefinitions(securityDefinitions: Iterable<Node>) {
    for (const {
      key: schemeName,
      value: v,
      pointer: sourcePointer,
      children: securityDefinitionsItemMembers,
    } of securityDefinitions) {
      this.generated.components?.securitySchemes?.__set__(schemeName, this.newObject(sourcePointer));
      const securityScheme: MappingTreeObject<oai3.SecurityScheme> = this.generated.components?.securitySchemes?.[
        schemeName
      ]! as any;
      switch (v.type) {
        case "apiKey":
          for (const { key, value, pointer } of securityDefinitionsItemMembers) {
            switch (key) {
              case "type":
              case "description":
              case "name":
              case "in":
                securityScheme.__set__(key as any, { value, sourcePointer: pointer });
                break;
              default:
                await this.visitExtensions(securityScheme, key, value, pointer);
                break;
            }
          }
          break;
        case "basic":
          for (const { key, value, pointer } of securityDefinitionsItemMembers) {
            switch (key) {
              case "description":
                securityScheme.__set__("description", { value, sourcePointer: pointer });
                break;
              case "type":
                securityScheme.__set__("type", { value: SecurityType.Http, sourcePointer: pointer });
                securityScheme.__set__("scheme" as any, { value: "basic", sourcePointer: pointer });
                break;
              default:
                await this.visitExtensions(securityScheme, key, value, pointer);
                break;
            }
          }
          break;
        case "oauth2":
          {
            const oauth2Scheme: MappingTreeObject<OAuth2SecurityScheme> = securityScheme as any;
            if (v.description !== undefined) {
              oauth2Scheme.__set__("description", { value: v.description, sourcePointer });
            }

            oauth2Scheme.__set__("type", { value: v.type, sourcePointer });
            oauth2Scheme.__set__("flows", this.newObject(sourcePointer));
            let flowName = v.flow;

            // convert flow names to OpenAPI 3 flow names
            if (v.flow === "application") {
              flowName = "clientCredentials";
            }

            if (v.flow === "accessCode") {
              flowName = "authorizationCode";
            }

            oauth2Scheme.flows.__set__(flowName, this.newObject(sourcePointer));
            let authorizationUrl;
            let tokenUrl;

            if (v.authorizationUrl) {
              authorizationUrl = v.authorizationUrl.split("?")[0].trim() || "/";
              oauth2Scheme.flows[flowName].__set__("authorizationUrl", { value: authorizationUrl, sourcePointer });
            }

            if (v.tokenUrl) {
              tokenUrl = v.tokenUrl.split("?")[0].trim() || "/";
              oauth2Scheme.flows[flowName].__set__("tokenUrl", { value: tokenUrl, sourcePointer });
            }

            const scopes = v.scopes || {};
            oauth2Scheme.flows[flowName].__set__("scopes", { value: scopes, sourcePointer });
          }
          break;
      }
    }
  }

  async visitDefinitions(definitions: Iterable<Node>) {
    for (const {
      key: schemaName,
      value: schemaValue,
      pointer: jsonPointer,
      childIterator: definitionsItemMembers,
    } of definitions) {
      if (this.generated.components === undefined) {
        this.generated.__set__("components", { value: {}, sourcePointer: NoMapping });
      }

      if (this.generated.components!.schemas === undefined) {
        this.generated.components?.__set__("schemas", { value: {}, sourcePointer: "/definitions" });
      }

      const cleanSchemaName = schemaName.replace(/\[|\]/g, "_");
      this.generated.components?.schemas?.__set__(cleanSchemaName, this.newObject(jsonPointer));
      const schemaItem = this.generated.components?.schemas?.[cleanSchemaName];
      await this.visitSchema(schemaItem as any, schemaValue, definitionsItemMembers);
    }
  }

  private async visitProperties(target: MappingTreeObject<any>, propertiesItemMembers: () => Iterable<Node>) {
    for (const { key, value, pointer, childIterator } of propertiesItemMembers()) {
      target.__set__(key, this.newObject(pointer));
      await this.visitSchema(target[key], value, childIterator);
    }
  }

  async visitResponsesDefinitions(responses: Iterable<Node>, globalProduces: string[]) {
    for (const { key, pointer, value, childIterator } of responses) {
      this.generated.components?.responses?.__set__(key, this.newObject(pointer));
      await this.visitResponse(
        this.generated.components!.responses![key] as MappingTreeObject<oai3.Response>,
        value,
        key,
        childIterator,
        pointer,
        globalProduces,
      );
    }
  }

  private async visitSchema(
    target: MappingTreeObject<oai3.Schema>,
    schemaValue: any,
    schemaItemMemebers: () => Iterable<Node>,
  ) {
    for (const { key, value, pointer, childIterator } of schemaItemMemebers()) {
      switch (key) {
        case "$ref":
          await this.copyRef(target as any, { $ref: value }, pointer);
          break;
        case "additionalProperties":
          if (typeof value === "boolean") {
            if (value === true) {
              target.__set__(key, { value, sourcePointer: pointer });
            } // false is assumed anyway in autorest.
          } else {
            target.__set__(key, this.newObject(pointer));
            await this.visitSchema(target[key]! as any, value, childIterator);
          }
          break;
        case "required":
        case "title":
        case "description":
        case "default":
        case "multipleOf":
        case "maximum":
        case "exclusiveMaximum":
        case "minimum":
        case "exclusiveMinimum":
        case "maxLength":
        case "minLength":
        case "pattern":
        case "maxItems":
        case "minItems":
        case "uniqueItems":
        case "maxProperties":
        case "minProperties":
        case "readOnly":
          target.__set__(key, { value, sourcePointer: pointer });
          break;
        case "enum":
          target.__set__("enum", this.newArray(pointer));
          await this.visitEnum(target.enum!, childIterator);
          break;
        case "allOf":
          target.__set__("allOf", this.newArray(pointer));
          await this.visitAllOf(target.allOf!, childIterator);
          break;
        case "items":
          target.__set__(key, this.newObject(pointer));
          await this.visitSchema(target[key]! as any, value, childIterator);
          break;
        case "properties":
          target.__set__(key, this.newObject(pointer));
          await this.visitProperties(target[key]!, childIterator);
          break;
        case "type":
        case "format":
          target.__set__(key, { value, sourcePointer: pointer });
          break;
        // in OpenAPI 3 the discriminator its an object instead of a string.
        case "discriminator":
          target.__set__("discriminator", this.newObject(pointer));
          target.discriminator!.__set__("propertyName", { value, sourcePointer: pointer });
          break;
        case "xml":
          this.visitXml(target, key, value, pointer);
          break;
        case "externalDocs":
          this.visitExternalDocs(target, key, value, pointer);
          break;
        case "example":
          target.__set__("example", { value, sourcePointer: pointer });
          break;
        case "x-nullable":
          target.__set__("nullable", { value, sourcePointer: pointer });

          // NOTE: this matches the previous converter behavior ... when a $ref
          // is inside the schema copy the properties as they are don't update
          // names, but also leave the new `nullable` field so that OpenAPI 3
          // readers pick it up correctly.
          if (schemaValue.$ref !== undefined) {
            target.__set__("x-nullable", { value, sourcePointer: pointer });
          }
          break;
        default:
          await this.visitExtensions(target, key, value, pointer);
          break;
      }
    }
  }

  private async visitEnum(target: MappingTreeArray<any>, members: () => Iterable<Node>) {
    for (const { key: index, value, pointer, childIterator } of members()) {
      if (typeof value === "object") {
        target.__push__(this.newObject(pointer));
        await this.visitSchema(target[index], value, childIterator);
      } else {
        target.__push__({ value, sourcePointer: pointer });
      }
    }
  }

  private async visitAllOf(target: MappingTreeArray<Refable<oai3.Schema>>, allOfMembers: () => Iterable<Node>) {
    for (const { key: index, value, pointer, childIterator } of allOfMembers()) {
      target.__push__(this.newObject(pointer));
      await this.visitSchema(target[index], value, childIterator);
    }
  }

  private visitXml(target: MappingTreeObject<any>, key: string, value: any, sourcePointer: string) {
    target.__set__(key, { value, sourcePointer });
  }

  private async visitTags(targetTags: MappingTreeArray<oai3.Tag>, tags: Iterable<Node>) {
    for (const { key: index, pointer, children: tagItemMembers } of tags) {
      await this.visitTag(targetTags, parseInt(index), pointer, tagItemMembers);
    }
  }

  private async visitTag(
    targetTags: MappingTreeArray<oai3.Tag>,
    index: number,
    jsonPointer: JsonPointer,
    tagItemMembers: Iterable<Node>,
  ) {
    targetTags.__push__(this.newObject(jsonPointer));
    const item: MappingTreeObject<oai3.Tag> = targetTags[index];

    for (const { key, pointer, value } of tagItemMembers) {
      switch (key) {
        case "name":
        case "description":
          item.__set__(key, { value, sourcePointer: pointer });
          break;
        case "externalDocs":
          this.visitExternalDocs(targetTags[index], key, value, pointer);
          break;
        default:
          await this.visitExtensions(targetTags[index], key, value, pointer);
          break;
      }
    }
  }

  private async convertReferenceToOai3(oldReference: string): Promise<string> {
    return convertOai2RefToOai3(oldReference);
  }

  private async resolveReference(file: string, path: string): Promise<any | undefined> {
    if (file === "" || file === this.originalFilename) {
      return getFromJsonPointer(this.original, path);
    } else {
      if (this.resolveExternalReference) {
        return await this.resolveExternalReference(file, path);
      }
      return undefined;
    }
  }

  private async visitExtensions(target: MappingTreeObject<any>, key: string, value: any, sourcePointer: string) {
    switch (key) {
      case "x-ms-odata":
        target.__set__(key, { value: await this.convertReferenceToOai3(value), sourcePointer });
        break;
      default:
        target.__set__(key, { value, sourcePointer });
        break;
    }
  }

  private visitExternalDocs(target: MappingTreeObject<any>, key: string, value: any, sourcePointer: string) {
    target.__set__(key, { value, sourcePointer });
  }

  private newArray<T>(pointer: JsonPointer): ProxyValue<T> {
    return {
      value: [] as any,
      sourcePointer: pointer,
    };
  }

  private newObject<T>(pointer: JsonPointer): ProxyValue<T> {
    return { value: {} as any, sourcePointer: pointer };
  }

  private async visitPaths(
    target: MappingTreeObject<Record<string, oai3.PathItem>>,
    paths: Iterable<Node>,
    globalConsumes: string[],
    globalProduces: string[],
  ) {
    for (const { key: uri, pointer, children: pathItemMembers } of paths) {
      await this.visitPath(target, uri, pointer, pathItemMembers, globalConsumes, globalProduces);
    }
  }

  private async visitPath(
    target: MappingTreeObject<Record<string, oai3.PathItem>>,
    uri: string,
    jsonPointer: JsonPointer,
    pathItemMembers: Iterable<Node>,
    globalConsumes: string[],
    globalProduces: string[],
  ) {
    target.__set__(uri, this.newObject(jsonPointer));
    const pathItem = target[uri]!;
    for (const { value, key, pointer, children: pathItemFieldMembers } of pathItemMembers) {
      // handle each item in the path object
      switch (key) {
        case "$ref":
        case "x-summary":
        case "x-description":
          pathItem.__set__(key, { value, sourcePointer: pointer });
          break;
        case "get":
        case "put":
        case "post":
        case "delete":
        case "options":
        case "head":
        case "patch":
        case "x-trace":
          await this.visitOperation(
            pathItem,
            key,
            pointer,
            pathItemFieldMembers,
            value,
            globalConsumes,
            globalProduces,
          );
          break;
        case "parameters":
          pathItem.__set__("parameters", this.newArray(pointer));
          await this.visitPathParameters(pathItem.parameters, pathItemFieldMembers);
          break;
      }
    }
  }

  private async visitPathParameters(target: any, parameters: Iterable<Node>) {
    for (const { key, value, pointer, childIterator } of parameters) {
      target.__push__(this.newObject(pointer));
      await this.visitParameter(target[target.length - 1], value, pointer, childIterator);
    }
  }

  async visitOperation(
    pathItem: MappingTreeObject<PathItem>,
    httpMethod: HttpMethod,
    jsonPointer: JsonPointer,
    operationItemMembers: Iterable<Node>,
    operationValue: OpenAPI2Operation,
    globalConsumes: string[],
    globalProduces: string[],
  ) {
    // trace was not supported on OpenAPI 2.0, it was an extension
    httpMethod = httpMethod !== "x-trace" ? httpMethod : "trace";
    pathItem.__set__(httpMethod, this.newObject(jsonPointer));

    // handle a single operation.
    const operation = pathItem[httpMethod]!;

    // preprocess produces and consumes for responses and parameters respectively;
    const produces = resolveOperationProduces(operationValue, globalProduces);
    const consumes = resolveOperationConsumes(operationValue, globalConsumes);

    for (const { value, key, pointer, children: operationFieldItemMembers } of operationItemMembers) {
      switch (key) {
        case "tags":
        case "description":
        case "summary":
        case "operationId":
        case "deprecated":
          operation.__set__(key, { value, sourcePointer: pointer });
          break;
        case "externalDocs":
          this.visitExternalDocs(operation, key, value, pointer);
          break;
        case "consumes":
          // handled beforehand for parameters
          break;
        case "parameters":
          await this.visitParameters(operation, operationFieldItemMembers, consumes, pointer);
          break;
        case "produces":
          // handled beforehand for responses
          break;
        case "responses":
          operation.__set__("responses", this.newObject(pointer));
          await this.visitResponses(
            operation.responses as MappingTreeObject<Record<string, oai3.Response>>,
            operationFieldItemMembers,
            produces,
          );
          break;
        case "schemes":
          break;
        case "security":
          operation.__set__("security", { value, sourcePointer: pointer });
          break;
        default:
          await this.visitExtensions(operation, key, value, pointer);
          break;
      }
    }
  }

  private async visitParameters(
    targetOperation: MappingTreeObject<oai3.HttpOperation>,
    parametersFieldItemMembers: any,
    consumes: any,
    sourcePointer: string,
  ) {
    for (let { pointer, value, childIterator } of parametersFieldItemMembers) {
      if (value.$ref) {
        const parsedRef = parseOai2Ref(value.$ref);
        if (parsedRef === undefined) {
          throw new Error(`Reference ${value.$ref} is not a valid ref(at ${pointer})`);
        }
        const parameterName = parsedRef.componentName;
        if (parsedRef.basePath === "/parameters/") {
          const dereferencedParameter = await this.resolveReference(parsedRef.file, parsedRef.path);
          if (!dereferencedParameter) {
            throw new Error(`Cannot find reference ${value.$ref}`);
          }

          if (
            dereferencedParameter.in === "body" ||
            dereferencedParameter.type === "file" ||
            dereferencedParameter.in === "formData"
          ) {
            childIterator = () => visit(dereferencedParameter, [parameterName]);
            value = dereferencedParameter;
            pointer = parsedRef.path;
          }
        } else {
          throw new Error(`Reference ${value.$ref} is invalid. It should be referencing a parameter(#/parameters/xzy)`);
        }
      }
      await this.visitOperationParameter(targetOperation, value, pointer, childIterator, consumes);
    }
  }

  private async visitOperationParameter(
    targetOperation: MappingTreeObject<HttpOperation>,
    parameterValue: OpenAPI2Parameter,
    pointer: string,
    parameterItemMembers: () => Iterable<Node>,
    consumes: string[],
  ) {
    if (parameterValue.in === "formData" || parameterValue.in === "body") {
      await this.visitOperationBodyParameter(targetOperation, parameterValue, pointer, parameterItemMembers, consumes);
    } else {
      if (targetOperation.parameters === undefined) {
        targetOperation.__set__("parameters", this.newArray(pointer));
      }

      const parameter = targetOperation.parameters!.__push__(
        this.newObject(pointer),
      ) as MappingTreeObject<oai3.Parameter>;
      await this.visitParameter(parameter, parameterValue, pointer, parameterItemMembers);
    }
  }

  private async visitOperationBodyParameter(
    targetOperation: MappingTreeObject<HttpOperation>,
    parameterValue: OpenAPI2BodyParameter | OpenAPI2FormDataParameter,
    sourcePointer: string,
    parameterItemMembers: () => Iterable<Node>,
    consumes: string[],
  ) {
    if (targetOperation.requestBody === undefined) {
      targetOperation.__set__("requestBody", this.newObject(sourcePointer));
    }

    const requestBody: MappingTreeObject<oai3.RequestBody> = targetOperation.requestBody! as any;

    copyPropertyIfNotSet(requestBody, "description", parameterValue, sourcePointer);
    if (parameterValue.in === "body") {
      copyPropertyIfNotSet(requestBody, "required", parameterValue, sourcePointer);
    }

    if (parameterValue["x-ms-client-name"]) {
      if (requestBody["x-ms-client-name"] === undefined) {
        requestBody?.__set__("x-ms-client-name", {
          value: parameterValue["x-ms-client-name"],
          sourcePointer: `${sourcePointer}/x-ms-client-name`,
        });
      }
      if (requestBody["x-ms-requestBody-name"] === undefined) {
        requestBody?.__set__("x-ms-requestBody-name", {
          value: parameterValue["x-ms-client-name"],
          sourcePointer: `${sourcePointer}/x-ms-client-name`,
        });
      }
    } else if (parameterValue.name) {
      if (requestBody["x-ms-requestBody-name"] === undefined) {
        requestBody?.__set__("x-ms-requestBody-name", {
          value: parameterValue.name,
          sourcePointer: `${sourcePointer}/name`,
        });
      }
    }

    copyPropertyIfNotSet(requestBody, "x-ms-parameter-location", parameterValue, sourcePointer);
    copyPropertyIfNotSet(requestBody, "x-ms-client-flatten", parameterValue, sourcePointer);

    if (requestBody!.content === undefined) {
      requestBody!.__set__("content", this.newObject(sourcePointer));
    }

    if (parameterValue.in === "formData") {
      let contentType = "application/x-www-form-urlencoded";
      if (consumes.length && consumes.indexOf("multipart/form-data") >= 0) {
        contentType = "multipart/form-data";
      }

      if (requestBody.content[contentType] === undefined) {
        requestBody.content.__set__(contentType, this.newObject(sourcePointer));
      }

      if (requestBody.content[contentType].schema === undefined) {
        requestBody.content[contentType].__set__("schema", this.newObject(sourcePointer));
      }
      const schema = requestBody.content[contentType].schema as MappingTreeObject<oai3.Schema>;

      this.addFormDataParameterToSchema(schema, parameterValue, sourcePointer, parameterItemMembers, contentType);
    } else if (parameterValue.in === "body") {
      const consumesTempArray = [...consumes];
      if (consumesTempArray.length === 0) {
        consumesTempArray.push("application/json");
      }

      for (const mimetype of consumesTempArray) {
        if (requestBody.content[mimetype] === undefined) {
          requestBody.content.__set__(mimetype, this.newObject(sourcePointer));
        }

        if (requestBody.content[mimetype].schema === undefined) {
          requestBody.content[mimetype].__set__("schema", this.newObject(sourcePointer));
        }

        if (parameterValue.schema !== undefined) {
          for (const { key, value, childIterator } of parameterItemMembers()) {
            if (key === "schema") {
              await this.visitSchema(requestBody.content[mimetype].schema! as any, value, childIterator);
            }
          }
        } else {
          requestBody.content[mimetype].__set__("schema", this.newObject(sourcePointer));
        }
      }

      // copy extensions in requestBody
      for (const { key, pointer: fieldPointer, value } of parameterItemMembers()) {
        if (isExtensionKey(key)) {
          if (!requestBody[key]) {
            requestBody.__set__(key, { value: value, sourcePointer: fieldPointer });
          }
        }
      }
    }
  }

  /**
   * Add the form data parameter as a property to the request body schema.
   */
  private addFormDataParameterToSchema(
    requestBodySchema: MappingTreeObject<oai3.Schema>,
    parameterValue: OpenAPI2FormDataParameter,
    sourcePointer: string,
    parameterItemMembers: () => Iterable<Node>,
    contentType: string,
  ) {
    if (requestBodySchema.type === undefined) {
      requestBodySchema.__set__("type", { value: "object", sourcePointer });
    }

    if (requestBodySchema.properties === undefined) {
      requestBodySchema.__set__("properties", this.newObject(sourcePointer));
    }

    requestBodySchema.properties!.__set__(parameterValue.name, this.newObject(sourcePointer));
    const targetProperty = requestBodySchema.properties![parameterValue.name] as MappingTreeObject<oai3.Schema>;

    copyProperty(targetProperty, "description", parameterValue, sourcePointer);
    copyProperty(targetProperty, "example", parameterValue, sourcePointer);

    if (parameterValue.type !== undefined) {
      // OpenAPI 3 wants to see `type: file` as `type:string` with `format: binary`
      if (parameterValue.type === "file") {
        targetProperty.__set__("type", { value: "string", sourcePointer });
        targetProperty.__set__("format", { value: "binary", sourcePointer });
      } else {
        targetProperty.__set__("type", { value: parameterValue.type as JsonType, sourcePointer });
      }
    }

    if (requestBodySchema.required === undefined) {
      requestBodySchema.__set__("required", this.newArray(sourcePointer));
    }

    if (parameterValue.required === true) {
      requestBodySchema.required!.__push__({ value: parameterValue.name, sourcePointer });
    }

    if (parameterValue.default !== undefined) {
      targetProperty.__set__("default", { value: parameterValue.default, sourcePointer });
    }

    if (parameterValue.enum !== undefined) {
      targetProperty.__set__("enum", { value: parameterValue.enum, sourcePointer });
    }

    if (parameterValue.allOf !== undefined) {
      targetProperty.__set__("allOf", { value: parameterValue.allOf as any, sourcePointer });
    }

    if (parameterValue.type === "array" && parameterValue.items !== undefined) {
      // Support the case where an operation can accept multiple files
      if (contentType === "multipart/form-data" && parameterValue.items.type === "file") {
        targetProperty.__set__("items", this.newObject(sourcePointer));
        const items = targetProperty.items as MappingTreeObject<oai3.Schema>;
        items.__set__("type", { value: "string", sourcePointer: `${sourcePointer}/items` });
        items.__set__("format", { value: "binary", sourcePointer: `${sourcePointer}/items` });
      } else {
        targetProperty.__set__("items", { value: parameterValue.items as any, sourcePointer });
      }
    }

    // copy extensions in target property
    for (const { key, pointer: fieldPointer, value } of parameterItemMembers()) {
      if (isExtensionKey(key)) {
        targetProperty.__set__(key, { value: value, sourcePointer: fieldPointer });
      }
    }
  }

  private async visitResponses(
    target: MappingTreeObject<Record<string, oai3.Response>>,
    responsesItemMembers: Iterable<Node>,
    produces: string[],
  ) {
    for (const { key, value, pointer, childIterator } of responsesItemMembers) {
      target.__set__(key, this.newObject(pointer));
      if (this.isTargetReference(target[key], value)) {
        return this.copyRef(target[key] as any, value, pointer);
      } else if (isExtensionKey(key)) {
        await this.visitExtensions(target[key], key, value, pointer);
      } else {
        await this.visitResponse(target[key], value, key, childIterator, pointer, produces);
      }
    }
  }

  private async visitResponse(
    responseTarget: MappingTreeObject<oai3.Response>,
    responseValue: OpenAPI2OperationResponse,
    responseName: string,
    responsesFieldMembers: () => Iterable<Node>,
    sourcePointer: string,
    produces: string[],
  ) {
    // NOTE: The previous converter patches the description of the response because
    // every response should have a description.
    // So, to match previous behavior we do too.
    if (responseValue.description === undefined || responseValue.description === "") {
      const sc = statusCodes.find((e) => {
        return e.code === responseName;
      });

      responseTarget.__set__("description", { value: sc ? sc.phrase : "", sourcePointer });
    } else {
      responseTarget.__set__("description", { value: responseValue.description, sourcePointer });
    }

    if (responseValue.schema) {
      if (produces.length === 0 || (produces.length === 1 && produces[0] === "*/*")) {
        throw new Error(
          `Operation response '${sourcePointer}' produces type couldn't be resolved. Operation is probably is missing a produces field and there isn't any global value. Please add "produces": [<contentType>]"`,
        );
      }

      responseTarget.__set__("content", this.newObject(sourcePointer));
      const content = responseTarget.content!;
      for (const mimetype of produces) {
        content.__set__(mimetype, this.newObject(sourcePointer));
        content[mimetype]!.__set__("schema", this.newObject(sourcePointer));
        for (const { key, value, childIterator } of responsesFieldMembers()) {
          if (key === "schema") {
            await this.visitSchema(content[mimetype]!.schema as any, value, childIterator);
          }
        }
        if (responseValue.examples && responseValue.examples[mimetype]) {
          const example: any = {};
          example.value = responseValue.examples[mimetype];
          content[mimetype]!.__set__("examples", this.newObject(sourcePointer));
          content[mimetype]!.examples!.__set__("response", { value: example, sourcePointer });
        }
      }

      // examples outside produces
      for (const mimetype in responseValue.examples) {
        if (responseTarget.content?.[mimetype] === undefined) {
          this.logger.trackWarning({
            code: "Oai2ToOai3/InvalidResponseExamples",
            message: `Response examples has mime-type '${mimetype}' which is not define in the local or global produces. Example will be ignored.`,
            source: [{ path: appendJsonPointer(sourcePointer, "examples", mimetype), document: this.originalFilename }],
          });
        }
      }
    }

    if (responseValue.headers) {
      responseTarget.__set__("headers", this.newObject(sourcePointer));
      for (const h in responseValue.headers) {
        responseTarget.headers!.__set__(h, this.newObject(sourcePointer));
        await this.visitHeader(responseTarget.headers![h]! as any, responseValue.headers[h], sourcePointer);
      }
    }

    // copy extensions
    for (const { key, pointer: fieldPointer, value } of responsesFieldMembers()) {
      if (isExtensionKey(key) && responseTarget[key] === undefined) {
        responseTarget.__set__(key, { value: value, sourcePointer: fieldPointer });
      }
    }
  }

  parameterTypeProperties = [
    "format",
    "minimum",
    "maximum",
    "exclusiveMinimum",
    "exclusiveMaximum",
    "minLength",
    "maxLength",
    "multipleOf",
    "minItems",
    "maxItems",
    "uniqueItems",
    "minProperties",
    "maxProperties",
    "additionalProperties",
    "pattern",
    "enum",
    "x-ms-enum",
    "default",
  ];

  arrayProperties = ["items", "minItems", "maxItems", "uniqueItems"];

  private async visitHeader(
    targetHeader: MappingTreeObject<oai3.Header>,
    headerValue: OpenAPI2ResponseHeader,
    sourcePointer: string,
  ) {
    if (this.isTargetReference(targetHeader, headerValue)) {
      return this.copyRef(targetHeader, headerValue.schema, sourcePointer);
    } else {
      if (headerValue.type && headerValue.schema === undefined) {
        targetHeader.__set__("schema", this.newObject(sourcePointer));
      }

      if (headerValue.description) {
        targetHeader.__set__("description", { value: headerValue.description, sourcePointer });
      }

      const schema: MappingTreeObject<oai3.Schema> = targetHeader.schema as any;
      for (const { key, childIterator } of visit(headerValue)) {
        if (key === "schema") {
          await this.visitSchema(schema.items! as any, headerValue.items, childIterator);
        } else if (this.parameterTypeProperties.includes(key) || this.arrayProperties.includes(key)) {
          schema.__set__(key as any, { value: headerValue[key], sourcePointer });
        } else if (isExtensionKey(key) && targetHeader[key] === undefined) {
          targetHeader.__set__(key, { value: headerValue[key], sourcePointer });
        }
      }

      if (headerValue.type) {
        schema.__set__("type", { value: headerValue.type, sourcePointer });
      }
      if (headerValue.items && headerValue.items.collectionFormat) {
        if (headerValue.collectionFormat === "csv") {
          targetHeader.__set__("style" as any, { value: "simple", sourcePointer });
        }

        if (headerValue.collectionFormat === "multi") {
          targetHeader.__set__("explode", { value: true, sourcePointer });
        }
      }
    }
  }
}

function copyProperty<T, K extends keyof T>(
  target: MappingTreeObject<T>,
  key: K,
  input: { [key in K]: T[K] },
  inputPointer: string,
) {
  if (input[key] !== undefined) {
    target.__set__(key, { value: input[key], sourcePointer: `${inputPointer}/${key.toString()}` });
  }
}

function copyPropertyIfNotSet<T, K extends keyof T>(
  target: MappingTreeObject<T>,
  key: K,
  input: { [key in K]: T[K] },
  inputPointer: string,
) {
  if (target[key] === undefined) {
    copyProperty(target, key, input, inputPointer);
  }
}
