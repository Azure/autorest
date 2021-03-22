import { Session } from "@autorest/extension-base";
import { knownMediaType, KnownMediaType } from "@azure-tools/codegen";
import * as OpenAPI from "@azure-tools/openapi";
import { dereference, Dereferenced } from "@azure-tools/openapi";
import { isSchemaBinary } from "./schema-utils";
import { groupBy } from "lodash";

export interface KnownMediaTypeGroupItem {
  mediaType: string;
  schema: Dereferenced<OpenAPI.Schema | undefined>;
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
}
