/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yamlAst from "yaml-ast-parser";
import { JsonPath } from "./jsonpath";
import { NewEmptyObject } from "../parsing/stable-object";

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

export const CreateYAMLMapping: (key: YAMLScalar, value: YAMLNode) => YAMLMapping = yamlAst.newMapping;
export const CreateYAMLScalar: (value: string) => YAMLScalar = yamlAst.newScalar;

export interface YAMLNodeWithPath {
  path: JsonPath;
  node: YAMLNode;
}

/**
 * Parsing
*/
export function ParseToAst(rawYaml: string): YAMLNode {
  return yamlAst.safeLoad(rawYaml, null) as YAMLNode;
}

export function* Descendants(yamlAstNode: YAMLNode, currentPath: JsonPath = [], deferResolvingMappings: boolean = false): Iterable<YAMLNodeWithPath> {
  yield { path: currentPath, node: yamlAstNode };
  switch (yamlAstNode.kind) {
    case Kind.MAPPING: {
      let astSub = yamlAstNode as YAMLMapping;
      if (deferResolvingMappings) {
        yield* Descendants(astSub.value, currentPath);
      } else {
        yield* Descendants(astSub.value, currentPath.concat([astSub.key.value]));
      }
    }
      break;
    case Kind.MAP:
      if (deferResolvingMappings) {
        for (let mapping of (yamlAstNode as YAMLMap).mappings) {
          yield* Descendants(mapping, currentPath.concat([mapping.key.value]));
        }
      } else {
        for (let mapping of (yamlAstNode as YAMLMap).mappings) {
          yield* Descendants(mapping, currentPath);
        }
      }
      break;
    case Kind.SEQ: {
      let astSub = yamlAstNode as YAMLSequence;
      for (let i = 0; i < astSub.items.length; ++i) {
        yield* Descendants(astSub.items[i], currentPath.concat([i]));
      }
    }
      break;
  }
}

export function ResolveAnchorRef(yamlAstRoot: YAMLNode, anchorRef: string): YAMLNodeWithPath {
  for (let yamlAstNode of Descendants(yamlAstRoot)) {
    if (yamlAstNode.node.anchorId === anchorRef) {
      return yamlAstNode;
    }
  }
  throw new Error(`Anchor '${anchorRef}' not found`);
}

function ParseNodeInternal(yamlRootNode: YAMLNode, yamlNode: YAMLNode): any {
  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject !== undefined
        ? yamlNodeScalar.valueObject
        : yamlNodeScalar.value;
    }
    case Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case Kind.MAP: {
      yamlNode.valueObject = NewEmptyObject();
      const yamlNodeMapping = yamlNode as YAMLMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = ParseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(ParseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as YAMLAnchorReference;
      return ResolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).node.valueObject;
    }
    case Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function ParseNode<T>(yamlNode: YAMLNode): T {
  ParseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function CloneAst<T extends YAMLNode>(ast: T): T {
  return ParseToAst(StringifyAst(ast)) as T;
}
export function StringifyAst(ast: YAMLNode): string {
  return Stringify(ParseNode<any>(ast));
}
export function Clone<T>(object: T): T {
  return Parse<T>(Stringify(object));
}
export function ToAst<T>(object: T): YAMLNode {
  return ParseToAst(Stringify(object));
}

export function Parse<T>(rawYaml: string): T {
  const node = ParseToAst(rawYaml);
  return ParseNode<T>(node);
}

export function Stringify<T>(object: T): string {
  return "---\n" + yamlAst.safeDump(object, null);
}

