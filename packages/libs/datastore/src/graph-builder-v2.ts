import { Mapping } from "source-map";
import { JsonPointer } from "./json-pointer/json-pointer";
import { createAssignmentMapping } from "./source-map/source-map";
import { Exception } from "@azure-tools/tasks";
import { parseJsonPointer } from "@azure-tools/json";

export function createGraphProxyV2<T extends object>(
  originalFileName: string,
  targetPointer: JsonPointer = "",
  mappings = new Array<Mapping>(),
  instance = <any>{},
): ProxyItem<T> {
  const tag = (
    value: T,
    filename: string,
    pointer: string,
    key: string | number,
    subject: string | undefined,
    recurse: boolean,
  ) => {
    createAssignmentMapping(
      value,
      filename,
      parseJsonPointer(pointer).filter((each) => each !== ""),
      [...parseJsonPointer(targetPointer), key].filter((each) => each !== ""),
      subject || "",
      recurse,
      mappings,
    );
  };

  const push = (value: { pointer?: string; value: any; recurse?: boolean; filename?: string; subject?: string }) => {
    instance.push(value.value);
    const filename = value.filename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }
    const pp = value.pointer ? parseJsonPointer(value.pointer) : [];
    const q = <any>parseInt(pp[pp.length - 1], 10);
    if (q >= 0) {
      pp[pp.length - 1] = q;
    }
    createAssignmentMapping(
      value.value,
      filename,
      pp,
      [...parseJsonPointer(targetPointer).filter((each) => each !== ""), instance.length - 1].filter(
        (each) => each !== "",
      ),
      value.subject || "",
      value.recurse,
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
    if (value.pointer === undefined) {
      throw new Error(`Assignment: for '${String(key)}', a json pointer property is required.`);
    }
    if (instance[key]) {
      throw new Exception(`Collision detected inserting into object: ${String(key)}`); //-- ${JSON.stringify(instance, null, 2)}
    }
    const filename = value.filename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }

    instance[key] = value.value;
    tag(
      value.value,
      filename,
      value.pointer,
      typeof key === "symbol" ? String(key) : key,
      value.subject,
      value.recurse ? true : false,
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

export interface ProxyValue<T> {
  value: ProxyItem<T>;
  pointer: string;
  filename?: string;
  subject?: string;
  recurse?: boolean;
}

export interface ProxyObjectV2Funcs<T> {
  __set__<K extends keyof T>(
    key: K,
    value: ProxyValue<T[K]>,
  ): asserts this is Required<{ [v in K]: ProxyValue<T[K]> }> & this;
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
new Map();
