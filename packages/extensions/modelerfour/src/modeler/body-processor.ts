import { HttpRequest, Operation, OperationGroup, Request, Schema } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { knownMediaType, KnownMediaType } from "@azure-tools/codegen";
import * as OpenAPI from "@azure-tools/openapi";
import { dereference, Dereferenced, HttpMethod } from "@azure-tools/openapi";
import { groupBy, values } from "lodash";
import { isSchemaBinary, isSchemaString } from "./schema-utils";

export interface KnownMediaTypeGroupItem {
  mediaType: string;
  schema: Dereferenced<OpenAPI.Schema | undefined>;
}

export interface RequestBodyGroup {
  schema: OpenAPI.Schema;
  type: KnownMediaType;
  mediaTypes: string[];
}

/**
 * Body processing functions
 */
export class BodyProcessor {
  public constructor(private session: Session<OpenAPI.Model>) {}

  /**
   * Returns a map of the all the content type + schema grouped by category(Binary, json, xml, etc.)
   * @param oai3Content OpenAPI 3 Content of the requestBody
   * @returns Map mapping known media types to list of schema/content type using it.
   */
  public groupMediaTypes(
    oai3Content: { [mediaType: string]: OpenAPI.MediaType } | undefined,
  ): Map<KnownMediaType, KnownMediaTypeGroupItem[]> {
    if (!oai3Content) {
      return new Map();
    }
    const mediaTypes = Object.entries(oai3Content)
      .map(([mediaType, value]) => ({
        mediaType,
        type: knownMediaType(mediaType),
        schema: dereference(this.session.model, value.schema),
      }))
      .map((value) => {
        const type =
          value.type === KnownMediaType.Json && value.schema.instance && isSchemaBinary(value.schema.instance)
            ? KnownMediaType.Binary
            : value.type;

        return { ...value, type };
      });

    const groups = groupBy(mediaTypes, (x) => x.type);
    return new Map(Object.entries(groups) as [KnownMediaType, KnownMediaTypeGroupItem[]][]);
  }

  public groupRequestBodyBySchema(
    oai3Content: { [mediaType: string]: OpenAPI.MediaType } | undefined,
    operationName: string,
  ): RequestBodyGroup[] {
    if (!oai3Content) {
      return [];
    }

    const entries = Object.entries(oai3Content).map(([mediaType, value]) => {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      const schema = dereference(this.session.model, value.schema).instance!;
      const type = knownMediaType(mediaType);
      return {
        mediaType,
        type,
        schema: schema,
      };
    });
    this.cleanupInvalidBodies(entries);

    const groups = new Map<string, { schema: OpenAPI.Schema; mediaTypes: string[] }>();
    for (const entry of entries) {
      const key = JSON.stringify(entry.schema, Object.keys(entry.schema).sort());
      let item = groups.get(key);
      if (item === undefined) {
        item = { schema: entry.schema, mediaTypes: [] };
        groups.set(key, item);
      }
      item.mediaTypes.push(entry.mediaType);
    }
    const result: any = [...groups.values()].map(({ schema, mediaTypes }) => {
      return {
        schema,
        type: this.getKnownMediaType(schema, mediaTypes, operationName),
        mediaTypes,
      };
    });
    return result;
  }

  /**
   * Cleanup body types that are invalid for the content type.
   * This can happen when converting swagger 2.0 which only let one type of body but can accept different content types.
   */
  private cleanupInvalidBodies(
    entries: {
      mediaType: string;
      type: KnownMediaType;
      schema: OpenAPI.Schema;
    }[],
  ) {
    for (const entry of entries) {
      if (entry.type === KnownMediaType.Binary && !isSchemaBinary(entry.schema)) {
        entry.schema = { type: "string", format: "binary" };
      } else if (entry.type === KnownMediaType.Text && entry.schema.type !== "string") {
        entry.schema = { type: "string" };
      }
    }
  }

  private getKnownMediaType(body: OpenAPI.Schema, mediaTypes: string[], operationName: string) {
    if (isSchemaBinary(body)) {
      return KnownMediaType.Binary;
    }

    if (
      isSchemaString(body) &&
      (mediaTypes.length !== 1 || (mediaTypes[0] !== "application/json" && mediaTypes[0] !== "application/xml"))
    ) {
      return KnownMediaType.Text;
    }

    const types = mediaTypes.map((x) => knownMediaType(x)).filter((x) => x !== KnownMediaType.Unknown);
    if (types.length === 0) {
      return KnownMediaType.Unknown;
    }

    const type = types[0];
    const differentType = types.find((x) => x !== type);
    if (differentType === undefined) {
      return type;
    }

    // Special case if json and other known serializations format are specified pick json
    const hasJson = types.find((x) => x === KnownMediaType.Json);
    if (hasJson && types.every((x) => KnownSerializationTypes.has(x))) {
      return KnownMediaType.Json;
    }

    this.session.error(
      `Operation '${operationName}' content types [${type}, ${differentType}] have the same body schema but cannot be used together.`,
      ["Modelerfour", "IncompatibleRequestBodies"],
      body,
    );
    return type;
  }

  public validateBodyContentTypes(httpMethod: HttpMethod, httpOperation: OpenAPI.HttpOperation, operationName: string) {
    if (httpOperation.requestBody === undefined) {
      return;
    }

    const kmtCount = Object.keys(httpOperation.requestBody).length;

    switch (httpMethod.toLowerCase()) {
      case "get":
      case "head":
      case "delete":
        if (kmtCount > 0) {
          this.session.warning(
            `Operation '${operationName}' really should not have a media type (because there should be no body)`,
            ["?"],
            httpOperation.requestBody,
          );
        }
        break;
      case "options":
      case "trace":
      case "put":
      case "patch":
      case "post":
        if (kmtCount === 0) {
          throw new Error(`Operation '${operationName}' must have a media type.`);
        }
    }
  }

  public addNoBodyRequest(operation: Operation, httpMethod: HttpMethod, path: string, baseUri: string) {
    operation.addRequest(
      new Request({
        protocol: {
          http: new HttpRequest({
            method: httpMethod,
            path: path,
            uri: baseUri,
          }),
        },
      }),
    );
  }
}

/**
 * List of serialization media types for objects.
 */
const KnownSerializationTypes = new Set([KnownMediaType.Json, KnownMediaType.Xml, KnownMediaType.Form]);
