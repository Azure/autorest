import { AnyObject, Node, TransformerViaPointer, visit } from "@azure-tools/datastore";
import compareVersions from "compare-versions";
import { toSemver, maximum, pascalCase } from "@azure-tools/codegen";
import * as oai3 from "@azure-tools/openapi";
import { cloneDeep } from "lodash";

export class EnumDeduplicator extends TransformerViaPointer<oai3.Model, oai3.Model> {
  private newRefs: Record<string, string> = {};
  protected enums = new Map<
    string,
    Array<{ target: AnyObject; value: AnyObject; key: string; pointer: string; originalNodes: Iterable<Node> }>
  >();

  async visitLeaf(target: AnyObject, value: AnyObject, key: string, pointer: string, originalNodes: Iterable<Node>) {
    if (value && pointer.startsWith("/components/schemas/") && value.enum) {
      // it's an enum
      // let's handle this ourselves.
      if (!value["x-ms-metadata"]) {
        return false;
      }
      // use the given name if specified, otherwise fallback to the metadata name
      const name = pascalCase(value["x-ms-enum"] ? value["x-ms-enum"].name : value["x-ms-metadata"].name);

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
      const name = first.value["x-ms-enum"] ? first.value["x-ms-enum"].name : first.value["x-ms-metadata"].name;
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
      if (first.value["x-ms-enum"]) {
        this.clone(mergedEnum, "x-ms-enum", first.pointer, first.value["x-ms-enum"]);
      }
      this.clone(mergedEnum, "type", first.pointer, "string");
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
