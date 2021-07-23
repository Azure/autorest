import { Mapping } from "source-map";
import { JsonPointer } from "./json-pointer/json-pointer";
import { createAssignmentMapping } from "./source-map/source-map";
import { Exception } from "@azure-tools/tasks";
import { parseJsonPointer } from "@azure-tools/json";
import { JsonPath } from "./json-path/json-path";

export function createGraphProxyV2<T extends object>(
  originalFileName: string,
  targetPointer: JsonPointer = "",
  value: Partial<T>,
  mappings = new Array<Mapping>(),
): ProxyItem<T> {
  const instance: any = value;
  const targetPointerPath = parseJsonPointer(targetPointer);

  const push = (value: ProxyValue<any>) => {
    const filename = value.sourceFilename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    instance.push(value.value);

    tag(
      value.value,
      targetPointerPath,
      filename,
      parseJsonPointerForArray(value.sourcePointer),
      instance.length - 1,
      value.subject || "",
      value.recurse ?? false,
      mappings,
    );
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

    instance[key] = value.value;
    tag(
      value.value,
      targetPointerPath,
      filename,
      parseJsonPointer(value.sourcePointer),
      typeof key === "symbol" ? String(key) : key,
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
      throw new Error("cannot write");
    },
  });
}

function tag<T>(
  value: T,
  targetPointerPath: JsonPath,
  sourceFilename: string,
  sourcePointerPath: JsonPath,
  key: string | number,
  subject: string | undefined,
  recurse: boolean,
  mappings: Mapping[],
) {
  createAssignmentMapping(
    value,
    sourceFilename,
    sourcePointerPath.filter((each) => each !== ""),
    [...targetPointerPath, key].filter((each) => each !== ""),
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
  __set__<K extends keyof T>(
    key: K,
    value: ProxyValue<T[K]>,
  ): asserts this is keyof T extends K ? {} : Required<{ [v in K]: ProxyValue<T[K]> }> & this;
}

export type ProxyObjectV2<T> = {
  readonly [P in keyof T]: ProxyItem<T[P]>;
} &
  ProxyObjectV2Funcs<T>;

export interface ProxyArray<T> extends ReadonlyArray<ProxyItem<T>> {
  __push__(value: ProxyValue<T>): void;
}

export type ProxyItem<T> = T extends Array<any> ? ProxyArray<T[number]> : T extends {} ? ProxyObjectV2<T> : T;

// export interface Foo {
//   some: string;
//   array: { value: string }[];
// }

// const a: ProxyObjectV2<Foo> = {} as any;
// const str: string = a.some;
// const str2: string = a.array[1].value;
