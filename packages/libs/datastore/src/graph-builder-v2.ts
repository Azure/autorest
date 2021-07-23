import { Mapping } from "source-map";
import { JsonPointer } from "./json-pointer/json-pointer";
import { createAssignmentMapping } from "./source-map/source-map";
import { Exception } from "@azure-tools/tasks";
import { parseJsonPointer } from "@azure-tools/json";
import { JsonPath } from "./json-path/json-path";

export function createGraphProxyV2<T extends object>(
  originalFileName: string,
  targetPointer: JsonPointer | JsonPath = "",
  value: Partial<T>,
  mappings = new Array<Mapping>(),
): ProxyItem<T> {
  const instance: any = value;
  const targetPointerPath = typeof targetPointer === "string" ? parseJsonPointer(targetPointer) : targetPointer;

  const push = (value: ProxyValue<any>) => {
    const filename = value.sourceFilename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    const newPropertyPath = [...targetPointerPath, instance.length - 1];
    let item;
    if (typeof value.value === "object") {
      item = createGraphProxyV2(originalFileName, newPropertyPath, value.value, mappings);
    } else {
      item = value.value;
    }
    instance.push(item);

    tag(
      value.value,
      newPropertyPath,
      filename,
      parseJsonPointerForArray(value.sourcePointer),
      value.subject || "",
      value.recurse ?? false,
      mappings,
    );

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
    if (value.sourcePointer === undefined) {
      throw new Error(`Assignment: for '${String(key)}', a json pointer property is required.`);
    }
    if (instance[key]) {
      throw new Exception(`Collision detected inserting into object: ${String(key)}`); //-- ${JSON.stringify(instance, null, 2)}
    }
    const filename = value.sourceFilename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    const newPropertyPath = [...targetPointerPath, typeof key === "symbol" ? String(key) : key];
    if (typeof value.value === "object") {
      instance[key] = createGraphProxyV2(originalFileName, newPropertyPath, value.value, mappings);
    } else {
      instance[key] = value.value;
    }
    tag(
      value.value,
      newPropertyPath,
      filename,
      parseJsonPointer(value.sourcePointer),
      value.subject,
      value.recurse ? true : false,
      mappings,
    );

    return true;
  };

  return new Proxy<ProxyItem<T>>(instance, {
    get(target: ProxyItem<T>, key: string | number | symbol): any {
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

    set(target: ProxyItem<T>, key, value): boolean {
      throw new Error("Use __set__ or __push__ to modify proxy graph.");
    },
  });
}

function tag<T>(
  value: T,
  targetPointerPath: JsonPath,
  sourceFilename: string,
  sourcePointerPath: JsonPath,
  subject: string | undefined,
  recurse: boolean,
  mappings: Mapping[],
) {
  createAssignmentMapping(
    value,
    sourceFilename,
    sourcePointerPath.filter((each) => each !== ""),
    targetPointerPath.filter((each) => each !== ""),
    subject || "",
    recurse,
    mappings,
  );
}

/**
 * Parse the json pointer and try to convert the last segement to a number if applicable.
 * @param pointer Json Pointer to parse
 * @returns Json Path
 */
function parseJsonPointerForArray(pointer: string): JsonPath {
  const pp = pointer ? parseJsonPointer(pointer) : [];
  const q = <any>parseInt(pp[pp.length - 1], 10);
  if (q >= 0) {
    pp[pp.length - 1] = q;
  }
  return pp;
}

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
  sourcePointer: string;

  /**
   * Source filename if different from the default.
   */
  sourceFilename?: string;
  subject?: string;
  recurse?: boolean;
}

export interface ProxyObjectV2Funcs<T> {
  __set__<K extends keyof T>(key: K, value: ProxyValue<T[K]>): void; //: asserts this is keyof T extends K ? {} : Required<{ [v in K]: ProxyValue<T[K]> }> & this;
}

export type ProxyObjectV2<T> = {
  readonly [P in keyof T]: ProxyItem<T[P]>;
} &
  ProxyObjectV2Funcs<T>;

export interface ProxyArray<T> extends ReadonlyArray<ProxyItem<T>> {
  __push__(value: ProxyValue<T>): ProxyItem<T>;
}

export type ProxyItem<T> = T extends Array<any> ? ProxyArray<T[number]> : T extends {} ? ProxyObjectV2<T> : T;

// export interface Foo {
//   some: string;
//   array: { value: string }[];
// }

// const a: ProxyObjectV2<Foo> = {} as any;
// const str: string = a.some;
// const str2: string = a.array[1].value;
