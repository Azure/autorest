import { typeOf } from "./type";

const getMap = "_#get-map#_";
const getPosition = "_#get-position#_";
const getActualValue = "_#get-value#_";

export function getMappings(instance: any) {
  return instance[getMap];
}

export function enableSourceTracking<T extends object>(
  instance: T,
  enforce = true,
  path = "$",
  map: Record<string, any> = {},
  cache = new Map<string, any>(),
): T {
  let proxy = cache.get(path);
  if (!proxy) {
    proxy = new Proxy<T>(instance, {
      get: (target: any, p: PropertyKey, receiver: any) => {
        if (p === getMap) {
          return map;
        }

        const value = target[p];
        switch (typeOf(value)) {
          case "undefined":
          case "null":
          case "function":
          case "string":
          case "boolean":
          case "number":
            return value;

          case "array":
            return enableSourceTracking(value, enforce, `${path}[${String(p)}]`, map, cache);

          case "object":
            return enableSourceTracking(value, enforce, `${path}.${String(p)}`, map, cache);
        }

        throw new Error(`Unhandled type withMap for '${typeOf(value)}'`);
      },
      set: (target: any, p: PropertyKey, value: any, receiver: any): boolean => {
        let memberPath = "";
        switch (typeOf(target)) {
          case "array":
            memberPath = `${path}[${String(p)}]`;
            break;

          case "object":
            memberPath = `${path}.${String(p)}`;
            break;

          default:
            throw new Error(`Unhandled 'set' for type withMap on '${typeOf(value)}'`);
        }

        if (value === undefined) {
          // remove the existing value
          delete target[p];
          delete map[memberPath];
          return true;
        }
        if (value === null) {
          // remove the existing value
          target[p] = null;
          delete map[memberPath];
          return true;
        }

        const pos = value[getPosition];
        if (pos) {
          map[memberPath] = pos;
          target[p] = value[getActualValue];

          // TODO: we should actually iterate thru whole graph here and set the source locations
          // for each item individually.
          return true;
        }
        if (enforce) {
          throw new Error(`Must supply source informaton on setting property '${memberPath}' when enforce is true.`);
        }

        target[p] = value.valueOf();
        return true;
      },
    });
    cache.set(path, proxy);
  }
  return proxy;
}

export const ShadowedNodePath = Symbol("ObjectPosition");
export interface ProxyPosition {
  [ShadowedNodePath]: Array<string | number>;
}

export type ShadowedObject<T> = T & ProxyPosition;

export function shadowPosition<T extends object>(
  source: T,
  cache: WeakMap<any, any> = new WeakMap(),
  path: Array<string | number> = [],
): ShadowedObject<T> {
  const cached = cache.get(source);
  if (cached) {
    return cached;
  }
  const proxy = new Proxy<ShadowedObject<T>>(source as any, {
    get(target: any, p: PropertyKey) {
      if (p === ShadowedNodePath) {
        // they want the source location for this node.
        return path;
      }

      const value = target[p];
      const key = getKey(p);
      switch (typeOf(value)) {
        case "undefined":
        case "null":
        case "function":
        case "string":
        case "boolean":
        case "number":
          return value;
        case "array":
          return shadowPosition(value, cache, [...path, key]);
        case "object":
          return shadowPosition(value, cache, [...path, key]);

        default:
          throw new Error(`Unhandled shadow of type '${typeOf(value)}' `);
      }
    },
  });

  cache.set(source, proxy);
  return proxy;
}

function getKey(p: PropertyKey) {
  switch (typeof p) {
    case "symbol":
      return p.toString();
    case "number":
      return p;
    case "string": {
      return isNaN(p as any) || isNaN(parseFloat(p)) ? p : parseInt(p, 10);
    }
  }
}
