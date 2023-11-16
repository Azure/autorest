import { toSemver, maximum, pascalCase } from "@azure-tools/codegen";
import { AnyObject, Node, TransformerViaPointer, visit } from "@azure-tools/datastore";
import * as oai3 from "@azure-tools/openapi";
import { includeXDashKeys } from "@azure-tools/openapi";
import { compareVersions } from "compare-versions";
import { cloneDeep } from "lodash";

interface EnumEntry {
  target: AnyObject;
  value: AnyObject;
  key: string;
  pointer: string;
  originalNodes: Iterable<Node>;
}

/**
 * List of x- properties that shouldn't be merged automatically
 */
const excludedProperties = new Set(["x-ms-enum", "x-ms-metadata"]);

export class EnumDeduplicator extends TransformerViaPointer<oai3.Model, oai3.Model> {
  private newRefs: Record<string, string> = {};
  protected enums = new Map<string, EnumEntry[]>();

  async visitLeaf(target: AnyObject, value: AnyObject, key: string, pointer: string, originalNodes: Iterable<Node>) {
    if (value && pointer.startsWith("/components/schemas/") && value.enum) {
      // it's an enum
      // let's handle this ourselves.
      if (!value["x-ms-metadata"]) {
        return false;
      }
      // use the given name if specified, otherwise fallback to the metadata name
      const name = pascalCase(getEnumName(value));
      const e = this.enums.get(name) || this.enums.set(name, []).get(name) || [];
      e.push({ target, value, key, pointer, originalNodes });
      return true;
    }
    return false;
  }

  public async finish() {
    // time to consolodate the enums
    for (const value of this.enums.values()) {
      // first sort them according to api-version order
      const enumSet = value.sort((a, b) =>
        compareVersions(
          toSemver(maximum(a.value["x-ms-metadata"].apiVersions)),
          toSemver(maximum(b.value["x-ms-metadata"].apiVersions)),
        ),
      );

      const first = enumSet[0];
      const name = getEnumName(first.value);
      if (enumSet.length === 1) {
        const originalRef = `#/components/schemas/${first.key}`;
        const newRef = `#/components/schemas/${name}`;

        // only one of this enum, we can just put it in without any processing
        // (switching the generic name out for the name of the enum.)
        this.clone(first.target, name, first.pointer, first.value);
        this.newRefs[originalRef] = newRef;
        continue;
      }

      // otherwise, we need to take the different versions of the enum,
      // combine all the values into a single enum
      const mergedEnum = this.newObject(first.target, name, first.pointer);
      this.clone(mergedEnum, "x-ms-metadata", first.pointer, first.value["x-ms-metadata"]);
      if (first.value.description) {
        this.clone(mergedEnum, "description", first.pointer, first.value.description);
      }
      if (first.value.type) {
        this.clone(mergedEnum, "type", first.pointer, first.value.type);
      }
      if (first.value["x-ms-enum"]) {
        this.clone(mergedEnum, "x-ms-enum", first.pointer, first.value["x-ms-enum"]);
      }
      if (first.value["format"]) {
        this.clone(mergedEnum, "format", first.pointer, first.value["format"]);
      }
      const newRef = `#/components/schemas/${name}`;
      this.newArray(mergedEnum, "enum", "");

      for (const each of enumSet) {
        for (const e of each.value.enum) {
          if (mergedEnum.enum.indexOf(e) == -1) {
            mergedEnum.enum.__push__({ value: e, pointer: each.pointer });
          }
        }
        const originalRef = `#/components/schemas/${each.key}`;
        this.newRefs[originalRef] = newRef;

        for (const prop of includeXDashKeys(each.value).filter((x) => !excludedProperties.has(x))) {
          if (!(prop in mergedEnum)) {
            this.clone(mergedEnum, prop, each.pointer, each.value[prop]);
          }
        }
      }
    }

    // Remove all the proxy objects.
    this.generated = cloneDeep(this.generated);
    // Update renamed schema references
    this.updateRefs(this.generated);
  }

  protected updateRefs(node: any) {
    for (const { value } of visit(node)) {
      if (value && typeof value === "object") {
        const ref = value.$ref;
        if (ref) {
          // see if this object has a $ref
          const newRef = this.newRefs[ref];
          if (newRef) {
            value.$ref = newRef;
          }
        }
        // now, recurse into this object
        this.updateRefs(value);
      }
    }
  }
}

/**
 * Returns the name of the enum. Either provided via `x-ms-enum.name` or resolved automatically.
 * @param value Enum Schema
 * @returns name of the enum.
 */
function getEnumName(value: oai3.Schema): string {
  return value["x-ms-enum"]?.name ? value["x-ms-enum"].name : value["x-ms-metadata"].name;
}
