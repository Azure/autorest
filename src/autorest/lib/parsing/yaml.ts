/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { From } from "linq-es2015";
import * as jsonpath from "jsonpath";
import * as sourceMap from "source-map";
import * as yamlAst from "yaml-ast-parser";
import { indexToPosition } from "./textUtility";
import { DataHandleRead } from "../data-store/dataStore";

// reexport required elements
export const Kind = yamlAst.Kind;
export type YAMLNode = yamlAst.YAMLNode;
export type YAMLScalar = yamlAst.YAMLScalar;
export type YAMLMapping = yamlAst.YAMLMapping;
export type YAMLMap = yamlAst.YamlMap;
export type YAMLSequence = yamlAst.YAMLSequence;
export type YAMLAnchorReference = yamlAst.YAMLAnchorReference;

export function cloneAst(ast: YAMLNode): YAMLNode {
  return parseToAst(stringify(parseNode<any>(ast)));
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
      return resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).valueObject;
    }
    case Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function parseNode<T>(yamlNode: YAMLNode): T {
  parseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function parseToAst(rawYaml: string): YAMLNode {
  return yamlAst.safeLoad(rawYaml, null) as YAMLNode;
}

export function* descendantsWithPath(yamlAstNode: YAMLNode, currentPath: jsonpath.PathComponent[] = ["$"]): Iterable<{ path: jsonpath.PathComponent[], node: YAMLNode }> {
  yield { path: currentPath, node: yamlAstNode };
  switch (yamlAstNode.kind) {
    case Kind.MAPPING: {
      let astSub = yamlAstNode as YAMLMapping;
      yield* descendantsWithPath(astSub.value, currentPath.concat([astSub.key.value]));
    }
      break;
    case Kind.MAP:
      for (let mapping of (yamlAstNode as YAMLMap).mappings) {
        yield* descendantsWithPath(mapping, currentPath);
      }
      break;
    case Kind.SEQ: {
      let astSub = yamlAstNode as YAMLSequence;
      for (let i = 0; i < astSub.items.length; ++i) {
        yield* descendantsWithPath(astSub.items[i], currentPath.concat([i]));
      }
    }
      break;
  }
}

export function* descendantsPath(yamlAstNode: YAMLNode, currentPath: jsonpath.PathComponent[] = ["$"]): Iterable<jsonpath.PathComponent[]> {
  return From(descendantsWithPath(yamlAstNode, currentPath)).Select(x => x.path);
}

export function* descendants(yamlAstNode: YAMLNode): Iterable<YAMLNode> {
  yield yamlAstNode;
  switch (yamlAstNode.kind) {
    case Kind.MAPPING:
      let astSub = yamlAstNode as YAMLMapping;
      yield* descendants(astSub.key);
      yield* descendants(astSub.value);
      break;
    case Kind.MAP:
      for (let mapping of (yamlAstNode as YAMLMap).mappings) {
        yield* descendants(mapping);
      }
      break;
    case Kind.SEQ:
      for (let item of (yamlAstNode as YAMLSequence).items) {
        yield* descendants(item);
      }
      break;
  }
}

export function resolveAnchorRef(yamlAstRoot: YAMLNode, anchorRef: string): YAMLNode {
  for (let yamlAstNode of descendants(yamlAstRoot)) {
    if (yamlAstNode.anchorId === anchorRef) {
      return yamlAstNode;
    }
  }
  throw new Error(`Anchor '${anchorRef}' not found`);
}

/**
 * Resolves the YAML node given a path PathComponent.
 * @param yamlAstRoot            Root node of AST (required for resolving anchor references)
 * @param yamlAstCurrent         Current AST node to start resolving from
 * @param jsonPathPart           Path component to resolve
 * @param deferResolvingMappings If set to true, if resolving to a mapping, will return the entire mapping node instead of just the value (useful if desiring keys)
 */
function resolvePathPart(yamlAstRoot: YAMLNode, yamlAstCurrent: YAMLNode, jsonPathPart: jsonpath.PathComponent, deferResolvingMappings: boolean): YAMLNode {
  switch (yamlAstCurrent.kind) {
    case Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case Kind.MAPPING: {
      let astSub = yamlAstCurrent as YAMLMapping;
      if (deferResolvingMappings) {
        return resolvePathPart(yamlAstRoot, astSub.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== astSub.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${astSub.key.value}'`);
      }
      return astSub.value;
    }
    case Kind.MAP: {
      let astSub = yamlAstCurrent as YAMLMap;
      for (let mapping of astSub.mappings) {
        if (jsonPathPart.toString() === mapping.key.value) {
          return deferResolvingMappings
            ? mapping
            : resolvePathPart(yamlAstRoot, mapping, jsonPathPart, deferResolvingMappings);
        }
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case Kind.SEQ: {
      let astSub = yamlAstCurrent as YAMLSequence;
      if (typeof jsonPathPart !== "number") {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > jsonPathPart || jsonPathPart >= astSub.items.length) {
        throw new Error(`Trying to retrieve item '${jsonPathPart}' from sequence with '${astSub.items.length}' items (index out of bounds)`);
      }
      return astSub.items[jsonPathPart];
    }
    case Kind.ANCHOR_REF: {
      let astSub = yamlAstCurrent as YAMLAnchorReference;
      let newCurrent = resolveAnchorRef(yamlAstRoot, astSub.referencesAnchor);
      return resolvePathPart(yamlAstRoot, newCurrent, jsonPathPart, deferResolvingMappings);
    }
    case Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function resolvePathParts(yamlAstRoot: YAMLNode, jsonPathParts: jsonpath.PathComponent[]): number {
  if (jsonPathParts.length === 0 || jsonPathParts[0] !== "$") {
    throw new Error(`Argument: Invalid JSON path '${JSON.stringify(jsonPathParts)}' (not starting with $)`);
  }
  // special treatment of root "$", so it gets mapped to the VERY beginning of the document (possibly "---")
  // instead of the first YAML mapping node. This allows disambiguation of "$" and "$.<first prop>" in YAML.
  if (jsonPathParts.length === 1) {
    return 0;
  }

  let yamlAstCurrent = yamlAstRoot;
  for (let i = 1; i < jsonPathParts.length; ++i) {
    yamlAstCurrent = resolvePathPart(yamlAstRoot, yamlAstCurrent, jsonPathParts[i], true);
  }
  return yamlAstCurrent.startPosition;
}

/**
 * Resolves the text position of a JSON path in raw YAML.
 */
export async function resolvePath(yamlFile: DataHandleRead, jsonPath: jsonpath.PathComponent[]): Promise<sourceMap.Position> {
  const yaml = await yamlFile.readData();
  const yamlAst = await (await yamlFile.readMetadata()).yamlAst;
  const textIndex = resolvePathParts(yamlAst, jsonPath);
  return indexToPosition(yaml, textIndex);
}