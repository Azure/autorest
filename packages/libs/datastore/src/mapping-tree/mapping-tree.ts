import { JsonPointer, parseJsonPointer } from "@azure-tools/json";
import { Exception } from "@azure-tools/tasks";
import { JsonPath } from "../json-path/json-path";
import { PathMapping } from "../source-map";

/**
 * To explicitly specify that there is no mapping for this.
 */
export const NoMapping = Symbol("NoMapping");

/**
 * Properties to set a new value in a proxygraph.
 */
export interface ProxyValue<T> {
  /**
   * Actual value
   */
  value: T;

  /**
   * Source pointer.
   */
  sourcePointer: string | typeof NoMapping;

  /**
   * Source filename if different from the default.
   */
  sourceFilename?: string;
}

export interface MappingTreeObjectV2Funcs<T> {
  /**
   * Set the key with the given value.
   * @param key key of object T
   * @param value value properties
   */
  __set__<K extends keyof T>(key: K, value: ProxyValue<T[K]>): void; //: asserts this is keyof T extends K ? {} : Required<{ [v in K]: ProxyValue<T[K]> }> & this;
}

export type MappingTreeObject<T> = {
  readonly [P in keyof T]: MappingTreeItem<T[P]>;
} & MappingTreeObjectV2Funcs<T>;

export interface MappingTreeArray<T> extends ReadonlyArray<MappingTreeItem<T>> {
  /**
   * Push a new value at the end of the array.
   * @param value value properties to set.
   */
  __push__(value: ProxyValue<T>): MappingTreeItem<T>;
}

export type MappingTreeItem<T> = T extends Array<any>
  ? MappingTreeArray<T[number]>
  : T extends {}
    ? MappingTreeObject<T>
    : T;

/**
 * Create a proxy tree
 * @param sourceFilename Name of the source file that this tree is being constructed from.
 * @param value Initial value
 * @param mappings List of mappings that will get populated as the tree gets built.
 * @param targetPointer Base pointer for this tree.
 * @returns
 */
export function createMappingTree<T extends object>(
  sourceFilename: string,
  value: Partial<T>,
  mappings: PathMapping[],
  targetPointer: JsonPointer | JsonPath = "",
): MappingTreeItem<T> {
  const targetPointerPath = typeof targetPointer === "string" ? parseJsonPointer(targetPointer) : targetPointer;
  return proxyDeepObject<T>(sourceFilename, targetPointerPath, value, mappings);
}

function proxyDeepObject<T>(
  originalFileName: string,
  targetPointer: JsonPath,
  obj: Partial<T>,
  mappings: PathMapping[],
): MappingTreeItem<T> {
  if (obj === undefined || obj === null) {
    return obj;
  }
  if (Array.isArray(obj)) {
    const proxiedItems = obj.map((x, i) => proxyDeepObject(originalFileName, targetPointer.concat(i), x, mappings));
    return proxyObject(originalFileName, targetPointer, proxiedItems, mappings) as any;
  } else if (typeof obj === "object") {
    const result: any = {};
    for (const [key, value] of Object.entries<any>(obj)) {
      result[key] = proxyDeepObject(originalFileName, targetPointer.concat(key), value, mappings);
    }
    return proxyObject(originalFileName, targetPointer, result, mappings) as any;
  } else {
    return obj;
  }
}

function proxyObject<T extends object>(
  originalFileName: string,
  targetPointer: JsonPointer | JsonPath = "",
  value: any,
  mappings = new Array<PathMapping>(),
): MappingTreeItem<T> {
  const targetPointerPath = typeof targetPointer === "string" ? parseJsonPointer(targetPointer) : targetPointer;

  const instance: any = value;

  const push = (value: ProxyValue<any>) => {
    const filename = value.sourceFilename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    const newPropertyPath = [...targetPointerPath, instance.length];
    const item = proxyDeepObject(originalFileName, newPropertyPath, value.value, mappings);
    instance.push(item);

    if (value.sourcePointer !== NoMapping) {
      tag(newPropertyPath, filename, parseJsonPointerForArray(value.sourcePointer), mappings);
    }

    return item;
  };

  const rewrite = (key: string, value: any) => {
    instance[key] = value;
  };

  const set = (key: string, value: ProxyValue<any>) => {
    // check if this is a correct assignment.
    if (value.value === undefined) {
      throw new Error(`Assignment: Value '${String(key)}' may not be undefined.`);
    }

    if (Object.prototype.hasOwnProperty.call(instance, key)) {
      throw new Exception(`Collision detected inserting into object: ${String(key)}`); //-- ${JSON.stringify(instance, null, 2)}
    }
    const filename = value.sourceFilename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    const newPropertyPath = [...targetPointerPath, typeof key === "symbol" ? String(key) : key];
    instance[key] = proxyDeepObject(originalFileName, newPropertyPath, value.value, mappings);

    if (value.sourcePointer !== NoMapping) {
      tag(newPropertyPath, filename, parseJsonPointer(value.sourcePointer), mappings);
    }

    return true;
  };

  return new Proxy<MappingTreeItem<T>>(instance, {
    get(_: MappingTreeItem<T>, key: string | number | symbol): any {
      switch (key) {
        case "__push__":
          return push;
        case "__rewrite__":
          return rewrite;
        case "__set__":
          return set;
      }

      return instance[key];
    },

    set(_: MappingTreeItem<T>, key, value): boolean {
      throw new Error(
        `Use __set__ or __push__ to modify proxy graph. Trying to set ${String(key)} with value: ${value}`,
      );
    },
  });
}

function tag(
  targetPointerPath: JsonPath,
  sourceFilename: string,
  sourcePointerPath: JsonPath,
  mappings: PathMapping[],
) {
  mappings.push({
    source: sourceFilename,
    original: sourcePointerPath.filter((each) => each !== ""),
    generated: targetPointerPath.filter((each) => each !== ""),
  });
}

/**
 * Parse the json pointer and try to convert the last segement to a number if applicable.
 * @param pointer Json Pointer to parse
 * @returns Json Path
 */
function parseJsonPointerForArray(pointer: string): JsonPath {
  const pp = pointer ? parseJsonPointer(pointer) : [];
  const q = <any>parseInt(pp[pp.length - 1] as any, 10);
  if (q >= 0) {
    pp[pp.length - 1] = q;
  }
  return pp;
}
