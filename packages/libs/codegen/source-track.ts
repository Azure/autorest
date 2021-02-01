import { items, clone, values, keys, Dictionary } from "@azure-tools/linq";
import { typeOf, isPrimitive } from "./type";

const sourceMarker = "_#source#_";
const mapMarker = "_#map#_";
const getMap = "_#get-map#_";
const getPosition = "_#get-position#_";
const getActualValue = "_#get-value#_";
const noSource = {
  $f: "none",
  $p: "none",
};

export function getMappings(instance: any) {
  return instance[getMap];
}

export function enableSourceTracking<T extends object>(
  instance: T,
  enforce = true,
  path = "$",
  map = new Dictionary<any>(),
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

export function shadow<T extends object>(source: T, document: string, path = "$", cache = new Map<string, any>()): T {
  let proxy = cache.get(path);

  if (!proxy) {
    proxy = new Proxy<T>(source, {
      get(target: any, p: PropertyKey, receiver: any) {
        if (p === getPosition) {
          // they want the source location for this node.
          return {
            document,
            Position: { path: [path] },
          };
        }
        if (p === getActualValue) {
          return target.valueOf();
        }

        const value = target[p];
        switch (typeOf(value)) {
          case "undefined":
          case "null":
          case "function":
            return value;

          case "string":
          case "boolean":
          case "number":
            return shadow(new Object(value), document, `${path}.${String(p)}`, cache);

          case "object":
            return shadow(value, document, `${path}.${String(p)}`, cache);

          case "array":
            return shadow(value, document, `${path}[${String(p)}]`, cache);

          default:
            throw new Error(`Unhandled shadow of type '${typeOf(value)}' `);
        }
      },
    });
    cache.set(path, proxy);
  }
  return proxy;
}

/*
export function shadow1(source: any, sourceFile: string, path = '$', hash = new WeakMap()) {
  if (hash.has(source)) {
    // cyclic reference
    return hash.get(source);
  }

  if (source[sourceMarker]) {
    return source;
  }

  switch (typeOf(source)) {
    case 'null':
    case 'undefined':
    case 'symbol':
      return source;

    case 'string':
    case 'number':
    case 'boolean': {
      const v: any = new Object(source);
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }

    case 'date': {
      const v: any = new Date(source);
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }

    case 'array': {
      const v: any = [];
      hash.set(source, v);
      for (const { key, value } of items(source)) {
        v[key] = shadow1(value, sourceFile, `${path}[${key}]`, hash);
      }
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }

    case 'set': {
      const v: any = new Set();
      hash.set(source, v);
      let index = 0;
      for (const value of values(source)) {
        v[index] = shadow1(value, sourceFile, `${path}[${index}]`, hash);
        index++;
      }
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }

    case 'map': {
      const v: any = new Map();
      hash.set(source, v);
      for (const { key, value } of items(source)) {
        v[key] = shadow1(value, sourceFile, `${path}[${key}]`, hash);
      }
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }

    case 'object': {
      const v: any = {};
      hash.set(source, v);
      for (const { key, value } of items(source)) {
        v[key] = shadow1(value, sourceFile, `${path}.${key}`, hash);
      }
      v[sourceMarker] = {
        $f: sourceFile,
        $p: path
      };
      return v;
    }
  }
  // some other object type.
  // we should throw, as we should know what we're dealing with.
}

export function attachMap<T extends object>(instance: T, enforce = true, $map: any = {}): T {
  // does this already hav a map attached?
  if ((<any>instance)[mapMarker]) {
    return instance;
  }

  // is it something that we can't work with?
  if (instance === null || instance === undefined) {
    return instance;
  }

  // set the marker on the original
  (<any>instance)[mapMarker] = $map;

  return new Proxy(instance, {
    ownKeys: (target: T): Array<PropertyKey> => Object.keys(target).filter(each => !each.startsWith('_#')),
    get: (target: T, p: PropertyKey, receiver: any): any => {
      if (p === getMap) {
        return (<any>target)[sourceMarker];
      }
      if (p === getActualValue) {
        return target.valueOf();
      }

      const v: any = (<any>target)[p];
      const type = typeof (v);

      if (v === undefined || v === null || type === 'function') {
        return v;
      }

      if (type === 'object') {
        // we're asked to return a member of the object
        // if we check and see that the member isn't
        // proxied, maybe we should stop and replace it with
        // a proxied version before giving it back.
        if (!v[mapMarker]) {
          (<any>target)[p] = attachMap(v, enforce, $map);
        }
        return v[getActualValue];
      }
      // whatever it is, just let it go.

      return v.valueOf();
    },

    set: (target: T, p: PropertyKey, value: any, receiver: any): boolean => {

      if (value === undefined || value === null) {
        // remove the existing value
        delete (<any>target)[p];
        return true;
      }

      // does the object have source data?
      const sm = value[sourceMarker];
      if (sm) {

        // yes!
        if (value.valueOf() === value) {
          (<any>target)[p] = attachMap(clone(value), enforce);
        } else {

          const vv: any = new Object(value.valueOf());
          vv[sourceMarker] = sm;
          console.log(`p has sm obj ${JSON.stringify(vv[sourceMarker])}`);
          (<any>target)[p] = attachMap(vv, enforce);
        }
        return true;
      }

      // no source data, just set the object value
      if (enforce) {
        throw new Error(`Must supply source informaton on property '${new String(p)}' when enforce is true.`);
      }

      if (isPrimitive(value)) {
        console.log('prim');
        // wrap it first!
        (<any>target)[p] = attachMap(new Object(value), enforce);
        return true;
      }

      (<any>target)[p] = attachMap(value, enforce);
      return true;
    }
  });
}*/
