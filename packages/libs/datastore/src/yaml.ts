/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// TODO: the following is only required because safeDump of "yaml-ast-parser" has this bug: https://github.com/mulesoft-labs/yaml-ast-parser/issues/30
// PLEASE: remove the entire dependency to js-yaml once that is fixed!
const { dump, load } = require("js-yaml");

import * as yamlAst from "yaml-ast-parser";
import { NewEmptyObject } from "./parsing/stable-object";
import { JsonPath } from "./json-path/json-path";

/**
 * reexport required elements
 */
export { newScalar } from "yaml-ast-parser";
export const Kind: {
  SCALAR: number;
  MAPPING: number;
  MAP: number;
  SEQ: number;
  ANCHOR_REF: number;
  INCLUDE_REF: number;
} = yamlAst.Kind;
export type YAMLNode = yamlAst.YAMLNode;
export type YAMLScalar = yamlAst.YAMLScalar;
export type YAMLMapping = yamlAst.YAMLMapping;
export type YAMLMap = yamlAst.YamlMap;
export type YAMLSequence = yamlAst.YAMLSequence;
export type YAMLAnchorReference = yamlAst.YAMLAnchorReference;

export const CreateYAMLAnchorRef: (key: string) => YAMLMap = <any>yamlAst.newAnchorRef;
export const CreateYAMLMap: () => YAMLMap = yamlAst.newMap;
export const CreateYAMLMapping: (key: YAMLScalar, value: YAMLNode) => YAMLMapping = yamlAst.newMapping;
export const CreateYAMLScalar: (value: string) => YAMLScalar = yamlAst.newScalar;

export const parseYaml = load;

export interface YAMLNodeWithPath {
  path: JsonPath;
  node: YAMLNode;
}

/**
 * Parsing
 */
export function ParseToAst(rawYaml: string): YAMLNode {
  return yamlAst.safeLoad(rawYaml);
}

export function* Descendants(
  yamlAstNode: YAMLNode,
  currentPath: JsonPath = [],
  deferResolvingMappings = false,
): Iterable<YAMLNodeWithPath> {
  const todos: Array<YAMLNodeWithPath> = [{ path: currentPath, node: yamlAstNode }];
  let todo: YAMLNodeWithPath | undefined;
  while ((todo = todos.pop())) {
    // report self
    yield todo;

    // traverse
    if (todo.node) {
      switch (todo.node.kind) {
        case Kind.MAPPING:
          {
            const astSub = todo.node as YAMLMapping;
            if (deferResolvingMappings) {
              todos.push({ node: astSub.value, path: todo.path });
            } else {
              todos.push({ node: astSub.value, path: todo.path.concat([astSub.key.value]) });
            }
          }
          break;
        case Kind.MAP:
          if (deferResolvingMappings) {
            for (const mapping of (todo.node as YAMLMap).mappings) {
              todos.push({ node: mapping, path: todo.path.concat([mapping.key.value]) });
            }
          } else {
            for (const mapping of (todo.node as YAMLMap).mappings) {
              todos.push({ node: mapping, path: todo.path });
            }
          }
          break;
        case Kind.SEQ:
          {
            const astSub = todo.node as YAMLSequence;
            for (let i = 0; i < astSub.items.length; ++i) {
              todos.push({ node: astSub.items[i], path: todo.path.concat([i]) });
            }
          }
          break;
      }
    }
  }
}

export function ResolveAnchorRef(yamlAstRoot: YAMLNode, anchorRef: string): YAMLNodeWithPath {
  for (const yamlAstNode of Descendants(yamlAstRoot)) {
    if (yamlAstNode.node.anchorId === anchorRef) {
      return yamlAstNode;
    }
  }
  throw new Error(`Anchor '${anchorRef}' not found`);
}

/**
 * Populates yamlNode.valueFunc with a function that creates a *mutable* object (i.e. no caching of the reference or such)
 */
function ParseNodeInternal(
  yamlRootNode: YAMLNode,
  yamlNode: YAMLNode,
  onError: (message: string, index: number) => void,
): (cache: WeakMap<YAMLNode, any>) => any {
  if (!yamlNode) {
    return () => null;
  }
  const errors = yamlNode.errors.filter((_) => !_.isWarning);
  if (errors.length > 0) {
    for (const error of errors) {
      onError(`Syntax error: ${error.reason}`, error.mark.position);
    }
    return ((yamlNode as any).valueFunc = () => null);
  }
  if ((yamlNode as any).valueFunc) {
    return (yamlNode as any).valueFunc;
  }

  // important for anchors!
  const memoize = (
    factory: (cache: WeakMap<YAMLNode, any>, set: (o: any) => void) => any,
  ): ((cache: WeakMap<YAMLNode, any>) => any) => (cache) => {
    if (cache.has(yamlNode)) {
      return cache.get(yamlNode);
    }
    const result = factory(cache, (o) => cache.set(yamlNode, o));
    cache.set(yamlNode, result);
    return result;
  };

  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as YAMLScalar;
      return ((yamlNode as any).valueFunc =
        yamlNodeScalar.valueObject !== undefined
          ? memoize(() => yamlNodeScalar.valueObject)
          : yamlNodeScalar.singleQuoted
          ? memoize(() => yamlNodeScalar.value)
          : memoize(() => load(yamlNodeScalar.rawValue)));
    }
    case Kind.MAPPING:
      onError("Syntax error: Encountered bare mapping.", yamlNode.startPosition);
      return ((yamlNode as any).valueFunc = () => null);
    case Kind.MAP: {
      const yamlNodeMapping = yamlNode as YAMLMap;
      return ((yamlNode as any).valueFunc = memoize((cache, set) => {
        const result = NewEmptyObject();
        set(result);
        for (const mapping of yamlNodeMapping.mappings) {
          if (mapping.key.kind !== Kind.SCALAR) {
            onError("Syntax error: Only scalar keys are allowed as mapping keys.", mapping.key.startPosition);
          } else if (mapping.value === null) {
            onError("Syntax error: No mapping value found.", mapping.key.endPosition);
          } else {
            result[mapping.key.value] = ParseNodeInternal(yamlRootNode, mapping.value, onError)(cache);
          }
        }
        return result;
      }));
    }
    case Kind.SEQ: {
      const yamlNodeSequence = yamlNode as YAMLSequence;
      return ((yamlNode as any).valueFunc = memoize((cache, set) => {
        const result: Array<any> = [];
        set(result);
        for (const item of yamlNodeSequence.items) {
          result.push(ParseNodeInternal(yamlRootNode, item, onError)(cache));
        }
        return result;
      }));
    }
    case Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as YAMLAnchorReference;
      const ref = ResolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).node;
      return memoize((cache) => ParseNodeInternal(yamlRootNode, ref, onError)(cache));
    }
    case Kind.INCLUDE_REF:
      onError("Syntax error: INCLUDE_REF not implemented.", yamlNode.startPosition);
      return ((yamlNode as any).valueFunc = () => null);
    default:
      throw new Error("Unknown YAML node kind.");
  }
}

export function ParseNode<T>(
  yamlNode: YAMLNode,
  onError: (message: string, index: number) => void = (message) => {
    throw new Error(message);
  },
): T {
  ParseNodeInternal(yamlNode, yamlNode, onError);
  if (!yamlNode) {
    return undefined as any;
  }
  return (yamlNode as any).valueFunc(new WeakMap());
}

export function CloneAst<T extends YAMLNode>(ast: T): T {
  if (ast.kind === Kind.MAPPING) {
    const astMapping = ast as YAMLMapping;
    return <T>CreateYAMLMapping(CloneAst(astMapping.key), CloneAst(astMapping.value));
  }
  return ParseToAst(StringifyAst(ast)) as T;
}
export function StringifyAst(ast: YAMLNode): string {
  return FastStringify(ParseNode<any>(ast));
}
export function Clone<T>(object: T): T {
  if (object === undefined) {
    return object;
  }
  return Parse<T>(FastStringify(object));
}

/**
 * Normalizes the order of given object's keys (sorts recursively)
 */
export function Normalize<T>(object: T): T {
  const seen = new WeakSet();
  const clone = Clone<T>(object);
  const norm = (o: any) => {
    if (Array.isArray(o)) {
      o.forEach(norm);
    } else if (o && typeof o == "object") {
      if (seen.has(o)) {
        return;
      }
      seen.add(o);
      const keys = Object.keys(o).sort();
      const oo = { ...o };
      for (const k of keys) {
        delete o[k];
      }
      for (const k of keys) {
        norm((o[k] = oo[k]));
      }
    }
  };
  norm(clone);
  return clone;
}
export function ToAst<T>(object: T): YAMLNode {
  return ParseToAst(FastStringify(object));
}

export function Parse<T>(
  rawYaml: string,
  onError: (message: string, index: number) => void = (message) => {
    throw new Error(message);
  },
): T {
  const node = ParseToAst(rawYaml);
  const result = ParseNode<T>(node, onError);
  return result;
}

export function Stringify<T>(object: T): string {
  return "---\n" + dump(object, { skipInvalid: true });
}

export function FastStringify<T>(obj: T): string {
  // has duplicate objects?
  const seen = new WeakSet();
  const losslessJsonSerializable = (o: any): boolean => {
    if (o && typeof o == "object") {
      if (seen.has(o)) {
        return false;
      }
      seen.add(o);
    }
    if (Array.isArray(o)) {
      return o.every(losslessJsonSerializable);
    } else if (o && typeof o == "object") {
      return Object.values(o).every(losslessJsonSerializable);
    }
    return true;
  };
  if (losslessJsonSerializable(obj)) {
    try {
      return JSON.stringify(obj, null, 1);
    } catch {
      // ignore.
    }
  }
  return Stringify(obj);
}

export function StrictJsonSyntaxCheck(json: string): { message: string; index: number } | null {
  try {
    // quick check on data.
    JSON.parse(json);
  } catch (e) {
    if (e instanceof SyntaxError) {
      const message = "" + e.message;
      try {
        return {
          message: message.substring(0, message.lastIndexOf("at")).trim(),
          index: parseInt(e.message.substring(e.message.lastIndexOf(" ")).trim()),
        };
      } catch {
        // ignore.
      }
    }
  }
  return null;
}
