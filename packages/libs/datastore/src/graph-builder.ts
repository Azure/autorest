import { Mapping } from "source-map";
import { JsonPointer, parseJsonPointer } from "./json-pointer/json-pointer";
import { CreateAssignmentMapping } from "./source-map/source-map";
import { Exception } from "@azure-tools/tasks";

export function createGraphProxy<T extends object>(
  originalFileName: string,
  targetPointer: JsonPointer = "",
  mappings = new Array<Mapping>(),
  instance = <any>{},
): ProxyObject<T> {
  const tag = (
    value: any,
    filename: string,
    pointer: string,
    key: string | number,
    subject: string | undefined,
    recurse: boolean,
  ) => {
    CreateAssignmentMapping(
      value,
      filename,
      parseJsonPointer(pointer),
      [...parseJsonPointer(targetPointer), key].filter((each) => each !== ""),
      subject || "",
      recurse,
      mappings,
    );
  };

  const push = (value: any) => {
    instance.push(value.value);
    const filename = value.filename || originalFileName;
    if (!filename) {
      throw new Error("Assignment: filename must be specified when there is no default.");
    }
    const pp = parseJsonPointer(value.pointer);
    const q = <any>parseInt(pp[pp.length - 1], 10);
    if (q >= 0) {
      pp[pp.length - 1] = q;
    }
    CreateAssignmentMapping(
      value.value,
      filename,
      pp,
      [...parseJsonPointer(targetPointer), instance.length - 1].filter((each) => each !== ""),
      value.subject || "",
      value.recurse,
      mappings,
    );
  };

  const rewrite = (key: string, value: any) => {
    instance[key] = value;
  };

  return new Proxy<ProxyObject<T>>(instance, {
    get(target: ProxyObject<T>, key: string | number | symbol): any {
      switch (key) {
        case "__push__":
          return push;
        case "__rewrite__":
          return rewrite;
      }

      return instance[key];
    },

    set(target: ProxyObject<T>, key, value: ProxyNode<any>): boolean {
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
    },
  });
}

export interface ProxyNode<T> {
  value: T;
  pointer: string;
  filename?: string;
  subject?: string;
  recurse?: boolean;
}

export type ProxyObject<TG> = {
  [P in keyof TG]: ProxyNode<TG[P]> | TG[P];
};
