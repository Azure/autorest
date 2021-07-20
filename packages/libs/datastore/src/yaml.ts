/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// TODO: the following is only required because safeDump of "yaml-ast-parser" has this bug: https://github.com/mulesoft-labs/yaml-ast-parser/issues/30
// PLEASE: remove the entire dependency to js-yaml once that is fixed!
const { dump, load } = require("js-yaml");

import * as yamlAst from "yaml-ast-parser";
import { JsonPath } from "./json-path/json-path";
import { cloneDeep } from "lodash";

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

export const parseYAMLFast = load;

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

export interface YAMLParseError {
  message: string;
  position: number;
}

export interface ParseResult<T> {
  result: T;
  errors: YAMLParseError[];
}

export function parseNode<T>(yamlNode: YAMLNode): ParseResult<T> {
  return parseNodeInternal(yamlNode, new WeakMap());
}

function parseNodeInternal<T>(yamlNode: YAMLNode, cache: WeakMap<YAMLNode, any>): ParseResult<T> {
  if (yamlNode === undefined) {
    return { result: undefined as any, errors: [] };
  }
  const cachedValue = cache.get(yamlNode);
  if (cachedValue) {
    return { result: cachedValue as T, errors: [] };
  }

  const errors = yamlNode.errors.filter((x) => !x.isWarning);
  if (errors.length > 0) {
    return {
      result: undefined as any,
      errors: errors.map((error) => {
        return { message: `Syntax error: ${error.reason}`, position: error.mark.position };
      }),
    };
  }

  return computeNodeValue<T>(yamlNode, cache);
}

function computeScalarNodeValue<T>(yamlNodeScalar: YAMLScalar, cache: WeakMap<YAMLNode, any>): ParseResult<T> {
  const value =
    yamlNodeScalar.valueObject !== undefined
      ? yamlNodeScalar.valueObject
      : yamlNodeScalar.singleQuoted
      ? yamlNodeScalar.value
      : load(yamlNodeScalar.rawValue);
  cache.set(yamlNodeScalar, value);

  return { result: value, errors: [] };
}

function computeMapNodeValue<T>(yamlNodeMapping: YAMLMap, cache: WeakMap<YAMLNode, any>): ParseResult<T> {
  const result: any = {};
  cache.set(yamlNodeMapping, result);

  let errors: YAMLParseError[] = [];
  for (const mapping of yamlNodeMapping.mappings) {
    if (mapping.key.kind !== Kind.SCALAR) {
      errors.push({
        message: "Syntax error: Only scalar keys are allowed as mapping keys.",
        position: mapping.key.startPosition,
      });
    } else if (mapping.value === null) {
      errors.push({ message: "Syntax error: No mapping value found.", position: mapping.key.endPosition });
    } else {
      const parsed = parseNode<any>(mapping.value);
      if (parsed.errors.length === 0) {
        if (mapping.key.value === "<<") {
          for (const [key, value] of Object.entries(parsed.result)) {
            result[key] = value;
          }
        } else {
          result[mapping.key.value] = parsed.result;
        }
      } else {
        errors = errors.concat(parsed.errors);
      }
    }
  }

  return { result, errors };
}

function computeSequenceNodeValue<T>(yamlNodeSequence: YAMLSequence, cache: WeakMap<YAMLNode, any>): ParseResult<T> {
  const result: any[] = [];
  cache.set(yamlNodeSequence, result);
  let errors: YAMLParseError[] = [];
  for (const item of yamlNodeSequence.items) {
    const itemResult = parseNode(item);
    if (itemResult.errors.length === 0) {
      result.push(itemResult.result);
    } else {
      errors = errors.concat(itemResult.errors);
    }
  }

  return { result: result as any, errors };
}

function computeNodeValue<T>(yamlNode: YAMLNode, cache: WeakMap<YAMLNode, any>): ParseResult<T> {
  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      return computeScalarNodeValue(yamlNode as YAMLScalar, cache);
    }
    case Kind.MAPPING:
      return {
        result: undefined as any,
        errors: [{ message: "Syntax error: Encountered bare mapping.", position: yamlNode.startPosition }],
      };

    case Kind.MAP: {
      return computeMapNodeValue(yamlNode as YAMLMap, cache);
    }
    case Kind.SEQ: {
      return computeSequenceNodeValue(yamlNode as YAMLSequence, cache);
    }
    case Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as YAMLAnchorReference;
      return parseNode(yamlNodeRef.value);
    }
    case Kind.INCLUDE_REF:
      return {
        result: undefined as any,
        errors: [{ message: "Syntax error: INCLUDE_REF not implemented.", position: yamlNode.startPosition }],
      };
    default:
      throw new Error("Unknown YAML node kind.");
  }
}

export function CloneAst<T extends YAMLNode>(ast: T): T {
  if (ast.kind === Kind.MAPPING) {
    const astMapping = ast as YAMLMapping;
    return <T>CreateYAMLMapping(CloneAst(astMapping.key), CloneAst(astMapping.value));
  }
  return ParseToAst(StringifyAst(ast)) as T;
}

export function StringifyAst(ast: YAMLNode): string {
  return fastStringify(parseNode<any>(ast).result);
}

/**
 * Normalizes the order of given object's keys (sorts recursively)
 */
export function Normalize<T>(object: T): T {
  const seen = new WeakSet();
  const clone = cloneDeep<T>(object);
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
  return ParseToAst(fastStringify(object));
}

export function parseYAML<T>(rawYaml: string): ParseResult<T> {
  const node = ParseToAst(rawYaml);
  return parseNode<T>(node);
}

export function Stringify<T>(object: T): string {
  return "---\n" + dump(object, { skipInvalid: true });
}

export function fastStringify<T>(obj: T): string {
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
