import { Dereferenced, ExtensionKey, PathReference, Refable } from "./common";

/**
 * Only return properties starting with x-
 * @param dictionary
 */
export const includeXDash = (dictionary: Record<string, unknown>): ExtensionKey[] => {
  return Object.keys(dictionary).filter((v, i, a) => v.startsWith("x-")) as any;
};

/**
 * Only return properties NOT starting with x-
 * @param dictionary
 */
export const excludeXDash = <T extends {}>(dictionary: T): string[] => {
  return Object.keys(dictionary).filter((v, i, a) => !v.startsWith("x-"));
};

export function includeXDashProperties<T extends { [key: string]: unknown }>(obj: T | undefined): T | undefined {
  if (!obj) {
    return undefined;
  }

  const result: any = {};
  for (const key of includeXDash(obj)) {
    result[key] = obj[key];
  }
  return result;
}

export function omitXDashProperties<T extends {}>(obj: T | undefined): T | undefined {
  if (!obj) {
    return undefined;
  }

  const result: any = {};
  for (const key of excludeXDash(obj)) {
    result[key] = (obj as any)[key];
  }
  return result;
}

/**
 * @deprecated use omitXDashProperties
 */
export const filterOutXDash = omitXDashProperties;

/**
 * Identifies if a given refable is a reference or an instance
 * @param item Check if item is a reference.
 */
export const isReference = <T>(item: Refable<T>): item is PathReference => {
  return item && (<PathReference>item).$ref ? true : false;
};

/**
 * Gets an object instance for the item, regardless if it's a reference or not.
 * @param document Entire document.
 * @param item Reference item.
 * @param stack Stack for circular dependencies.
 */
export const dereference = <T>(document: any, item: Refable<T>, stack: string[] = []): Dereferenced<T> => {
  let name: string | undefined;

  if (isReference(item)) {
    let node = document;
    const path = item.$ref;
    if (stack.indexOf(path) > -1) {
      throw new Error(`Circular $ref in Model -- ${path} :: ${JSON.stringify(stack)}`);
    }
    stack.push(path);

    const parts = path.replace("#/", "").split("/");

    for (name of parts) {
      if (!node[name]) {
        throw new Error(`Invalid Reference ${name} -- ${path}`);
      }
      node = node[name];
    }

    if (isReference(node)) {
      // it's a ref to a ref.
      return dereference<T>(document, node, stack);
    }
    return { instance: node, name: name || "", fromRef: true };
  }
  return { instance: item, name: "", fromRef: false };
};
