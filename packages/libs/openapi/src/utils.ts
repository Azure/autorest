import { Dereferenced, ExtensionKey, PathReference, Refable } from "./common";

/**
 * Returns true if the key starts with `x-`
 */
export function isExtensionKey(key: string | ExtensionKey): key is ExtensionKey {
  return key.startsWith("x-");
}

/**
 * Only return properties starting with x-
 * @param dictionary
 */
export function includeXDashKeys<T extends Record<string | ExtensionKey, any>>(
  dictionary: T,
): Extract<keyof T, ExtensionKey>[] {
  return Object.keys(dictionary).filter(isExtensionKey) as any;
}

/**
 * Only return properties NOT starting with x-
 * @param dictionary
 */
export function omitXDashKeys<T extends {}>(dictionary: T): Exclude<keyof T, ExtensionKey>[] {
  return Object.keys(dictionary).filter((v) => !v.startsWith("x-")) as any;
}

export function includeXDashProperties<T extends Record<string | ExtensionKey, any> | undefined>(
  obj: T,
): T extends undefined ? undefined : Pick<T, Extract<keyof T, ExtensionKey>> {
  if (obj === undefined) {
    return undefined as any;
  }

  const result: any = {};
  for (const key of includeXDashKeys(obj)) {
    result[key] = obj[key];
  }
  return result;
}

export function omitXDashProperties<T extends {} | undefined>(
  obj: T,
): T extends undefined ? undefined : Pick<T, Exclude<keyof T, ExtensionKey>> {
  if (obj === undefined) {
    return undefined as any;
  }

  const result: any = {};
  for (const key of omitXDashKeys(obj)) {
    result[key] = (obj as any)[key];
  }
  return result;
}

/**
 * Identifies if a given refable is a reference or an instance
 * @param item Check if item is a reference.
 */
export function isReference<T extends {} | undefined>(item: Refable<T>): item is PathReference {
  return item && (<PathReference>item).$ref ? true : false;
}

/**
 * Gets an object instance for the item, regardless if it's a reference or not.
 * @param document Entire document.
 * @param item Reference item.
 * @param stack Stack for circular dependencies.
 */
export function dereference<T extends {} | undefined>(
  document: any,
  item: Refable<T>,
  stack: string[] = [],
): Dereferenced<T> {
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
}
