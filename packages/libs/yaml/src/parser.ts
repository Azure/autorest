/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// TODO: the following is only required because safeDump of "yaml-ast-parser" has this bug: https://github.com/mulesoft-labs/yaml-ast-parser/issues/30
// PLEASE: remove the entire dependency to js-yaml once that is fixed!
import { dump, load } from "js-yaml";
import { cloneDeep } from "lodash";
import { newMapping, safeLoad } from "yaml-ast-parser";
import { YamlMap, YamlNode, YamlScalar, Kind, YamlSequence } from "./types";

export interface YamlNodeWithPath {
  path: (string | number)[];
  node: YamlNode;
}

/**
 * Parse YAML without creating the AST tree.
 */
export const parseYAMLFast = load;

/**
 * Parse YAML to AST tree.
 */
export function parseYAMLAst(rawYaml: string): YamlNode {
  return safeLoad(rawYaml) as any;
}

export interface YAMLParseError {
  message: string;
  position: number;
}

export interface ParseResult<T> {
  result: T;
  errors: YAMLParseError[];
}

export function getYamlNodeValue<T>(yamlNode: YamlNode): ParseResult<T> {
  return computeNodeValue(yamlNode, new WeakMap());
}

function computeNodeValue<T>(yamlNode: YamlNode, cache: WeakMap<YamlNode, any>): ParseResult<T> {
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

  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      return computeScalarNodeValue(yamlNode, cache);
    }
    case Kind.MAPPING:
      return {
        result: undefined as any,
        errors: [{ message: "Syntax error: Encountered bare mapping.", position: yamlNode.startPosition }],
      };

    case Kind.MAP: {
      return computeMapNodeValue(yamlNode, cache);
    }
    case Kind.SEQ: {
      return computeSequenceNodeValue(yamlNode, cache);
    }
    case Kind.ANCHOR_REF: {
      return computeNodeValue(yamlNode.value, cache);
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

function computeScalarNodeValue<T>(yamlNodeScalar: YamlScalar, cache: WeakMap<YamlNode, any>): ParseResult<T> {
  const value =
    yamlNodeScalar.valueObject !== undefined
      ? yamlNodeScalar.valueObject
      : yamlNodeScalar.singleQuoted
      ? yamlNodeScalar.value
      : load(yamlNodeScalar.rawValue);
  cache.set(yamlNodeScalar, value);

  return { result: value, errors: [] };
}

function computeMapNodeValue<T>(yamlNodeMapping: YamlMap, cache: WeakMap<YamlNode, any>): ParseResult<T> {
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
      const parsed = computeNodeValue<any>(mapping.value, cache);
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

function computeSequenceNodeValue<T>(yamlNodeSequence: YamlSequence, cache: WeakMap<YamlNode, any>): ParseResult<T> {
  const result: any[] = [];
  cache.set(yamlNodeSequence, result);
  let errors: YAMLParseError[] = [];
  for (const item of yamlNodeSequence.items) {
    const itemResult = computeNodeValue(item, cache);
    if (itemResult.errors.length === 0) {
      result.push(itemResult.result);
    } else {
      errors = errors.concat(itemResult.errors);
    }
  }

  return { result: result as any, errors };
}

export function cloneYamlAst<T extends YamlNode>(ast: T): T {
  if (ast.kind === Kind.MAPPING) {
    return <T>newMapping(cloneYamlAst(ast.key), cloneYamlAst(ast.value));
  }
  return parseYAMLAst(stringifyYamlAst(ast)) as T;
}

export function stringifyYamlAst(ast: YamlNode): string {
  return fastStringify(getYamlNodeValue<any>(ast).result);
}

/**
 * Normalizes the order of given object's keys (sorts recursively)
 */
export function deepNormalize<T>(object: T): T {
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

/**
 * Create an AST tree of a given object.
 */
export function valueToAst<T>(object: T): YamlNode {
  return parseYAMLAst(fastStringify(object));
}

export function parseYAML<T>(rawYaml: string): ParseResult<T> {
  const node = parseYAMLAst(rawYaml);
  return getYamlNodeValue<T>(node);
}

/**
 * @deprecated use @see stringify
 */
export function Stringify<T>(object: T): string {
  return "---\n" + dump(object, { skipInvalid: true });
}

export function stringify(object: unknown) {
  return dump(object);
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
