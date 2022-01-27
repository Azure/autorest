import { HttpRequest, Operation, OperationGroup, Request } from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { knownMediaType, KnownMediaType } from "@azure-tools/codegen";
import * as OpenAPI from "@azure-tools/openapi";
import { dereference, Dereferenced, HttpMethod } from "@azure-tools/openapi";
import { groupBy, values } from "lodash";
import { isSchemaBinary } from "./schema-utils";

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

    console.error(
      "vales",
      Object.values(oai3Content).map((x) => x.schema),
    );
    const entries = Object.entries(oai3Content).map(([mediaType, value]) => ({
      mediaType,
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      schema: dereference(this.session.model, value.schema).instance!,
    }));

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

  private getKnownMediaType(body: OpenAPI.Schema, mediaTypes: string[], operationName: string) {
    if (isSchemaBinary(body)) {
      return KnownMediaType.Binary;
    }
    const types = mediaTypes.map((x) => knownMediaType(x));
    const type = types[0];
    const differentType = types.find((x) => x === type);
    if (differentType !== undefined) {
      this.session.error(
        `Operation ${operationName} content types [${type}, ${differentType}] have the same body schema but cannot be used together.`,
        ["Modelerfour", "IncompatibleRequestBodies"],
      );
    }
    return type;
  }

  public validateBodyContentTypes(httpMethod: HttpMethod, httpOperation: OpenAPI.HttpOperation, operationName: string) {
    const kmtCount = httpOperation.requestBody ? Object.keys(httpOperation.requestBody).length : 0;

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
