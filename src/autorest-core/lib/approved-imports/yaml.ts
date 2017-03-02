/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yamlAst from "yaml-ast-parser";
import { JsonPath } from "./jsonpath";

/**
 * reexport required elements
 */
export { newScalar } from "yaml-ast-parser";
export const Kind: { SCALAR: number, MAPPING: number, MAP: number, SEQ: number, ANCHOR_REF: number, INCLUDE_REF: number } = yamlAst.Kind;
export type YAMLNode = yamlAst.YAMLNode;
export type YAMLScalar = yamlAst.YAMLScalar;
export type YAMLMapping = yamlAst.YAMLMapping;
export type YAMLMap = yamlAst.YamlMap;
export type YAMLSequence = yamlAst.YAMLSequence;
export type YAMLAnchorReference = yamlAst.YAMLAnchorReference;

export interface YAMLNodeWithPath {
  path: JsonPath;
  node: YAMLNode;
}

/**
 * Parsing
 */
export function parseToAst(rawYaml: string): YAMLNode {
  return yamlAst.safeLoad(rawYaml, null) as YAMLNode;
}

export function* descendants(yamlAstNode: YAMLNode, currentPath: JsonPath = ["$"]): Iterable<YAMLNodeWithPath> {
  yield { path: currentPath, node: yamlAstNode };
  switch (yamlAstNode.kind) {
    case Kind.MAPPING: {
      let astSub = yamlAstNode as YAMLMapping;
      yield* descendants(astSub.value, currentPath.concat([astSub.key.value]));
    }
      break;
    case Kind.MAP:
      for (let mapping of (yamlAstNode as YAMLMap).mappings) {
        yield* descendants(mapping, currentPath);
      }
      break;
    case Kind.SEQ: {
      let astSub = yamlAstNode as YAMLSequence;
      for (let i = 0; i < astSub.items.length; ++i) {
        yield* descendants(astSub.items[i], currentPath.concat([i]));
      }
    }
      break;
  }
}

export function resolveAnchorRef(yamlAstRoot: YAMLNode, anchorRef: string): YAMLNodeWithPath {
  for (let yamlAstNode of descendants(yamlAstRoot)) {
    if (yamlAstNode.node.anchorId === anchorRef) {
      return yamlAstNode;
    }
  }
  throw new Error(`Anchor '${anchorRef}' not found`);
}

function parseNodeInternal(yamlRootNode: YAMLNode, yamlNode: YAMLNode): any {
  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject || yamlNodeScalar.value;
    }
    case Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case Kind.MAP: {
      yamlNode.valueObject = {};
      const yamlNodeMapping = yamlNode as YAMLMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = parseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(parseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as YAMLAnchorReference;
      return resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).node.valueObject;
    }
    case Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function parseNode<T>(yamlNode: YAMLNode): T {
  parseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function cloneAst(ast: YAMLNode): YAMLNode {
  return parseToAst(stringifyAst(ast));
}
export function stringifyAst(ast: YAMLNode): string {
  return stringify(parseNode<any>(ast));
}
export function clone<T>(object: T): T {
  return parse<T>(stringify(object));
}

export function parse<T>(rawYaml: string): T {
  const node = parseToAst(rawYaml);
  return parseNode<T>(node);
}

export function stringify<T>(object: T): string {
  return "---\n" + yamlAst.safeDump(object, null);
}

