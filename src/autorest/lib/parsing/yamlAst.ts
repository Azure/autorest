/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as jsonpath from "jsonpath";
import * as sourceMap from "source-map";
import * as yamlAst from "yaml-ast-parser";
import { indexToPosition } from "./textUtility";

export function parse(rawYaml: string): yamlAst.YAMLNode {
  return yamlAst.safeLoad(rawYaml, null) as yamlAst.YAMLNode;
}

export function renameAnchors(yamlNode: yamlAst.YAMLNode, anchorNameMap: (anchorName: string) => string) {
  for (const node of descendants(yamlNode)) {
    if (node.anchorId !== undefined) {
      node.anchorId = anchorNameMap(node.anchorId);
    }
    if (node.kind === yamlAst.Kind.ANCHOR_REF) {
      const nodeAnchorRef = node as yamlAst.YAMLAnchorReference;
      nodeAnchorRef.referencesAnchor = anchorNameMap(nodeAnchorRef.referencesAnchor);
    }
  }
}

export function* descendantPaths(yamlAstNode: yamlAst.YAMLNode, currentPath: jsonpath.PathComponent[] = ["$"]): Iterable<jsonpath.PathComponent[]> {
  yield currentPath;
  switch (yamlAstNode.kind) {
    case yamlAst.Kind.MAPPING: {
      let astSub = yamlAstNode as yamlAst.YAMLMapping;
      yield* descendantPaths(astSub.value, currentPath.concat([astSub.key.value]));
    }
      break;
    case yamlAst.Kind.MAP:
      for (let mapping of (yamlAstNode as yamlAst.YamlMap).mappings) {
        yield* descendantPaths(mapping, currentPath);
      }
      break;
    case yamlAst.Kind.SEQ: {
      let astSub = yamlAstNode as yamlAst.YAMLSequence;
      for (let i = 0; i < astSub.items.length; ++i) {
        yield* descendantPaths(astSub.items[i], currentPath.concat([i]));
      }
    }
      break;
  }
}

export function* descendants(yamlAstNode: yamlAst.YAMLNode): Iterable<yamlAst.YAMLNode> {
  yield yamlAstNode;
  switch (yamlAstNode.kind) {
    case yamlAst.Kind.MAPPING:
      let astSub = yamlAstNode as yamlAst.YAMLMapping;
      yield* descendants(astSub.key);
      yield* descendants(astSub.value);
      break;
    case yamlAst.Kind.MAP:
      for (let mapping of (yamlAstNode as yamlAst.YamlMap).mappings) {
        yield* descendants(mapping);
      }
      break;
    case yamlAst.Kind.SEQ:
      for (let item of (yamlAstNode as yamlAst.YAMLSequence).items) {
        yield* descendants(item);
      }
      break;
  }
}

export function resolveAnchorRef(yamlAstRoot: yamlAst.YAMLNode, anchorRef: string): yamlAst.YAMLNode {
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
function resolvePathPart(yamlAstRoot: yamlAst.YAMLNode, yamlAstCurrent: yamlAst.YAMLNode, jsonPathPart: jsonpath.PathComponent, deferResolvingMappings: boolean): yamlAst.YAMLNode {
  switch (yamlAstCurrent.kind) {
    case yamlAst.Kind.SCALAR:
      throw new Error(`Trying to retrieve '${jsonPathPart}' from scalar value`);
    case yamlAst.Kind.MAPPING: {
      let astSub = yamlAstCurrent as yamlAst.YAMLMapping;
      if (deferResolvingMappings) {
        return resolvePathPart(yamlAstRoot, astSub.value, jsonPathPart, deferResolvingMappings);
      }
      if (jsonPathPart.toString() !== astSub.key.value) {
        throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping with key '${astSub.key.value}'`);
      }
      return astSub.value;
    }
    case yamlAst.Kind.MAP: {
      let astSub = yamlAstCurrent as yamlAst.YamlMap;
      for (let mapping of astSub.mappings) {
        if (jsonPathPart.toString() === mapping.key.value) {
          return deferResolvingMappings
            ? mapping
            : resolvePathPart(yamlAstRoot, mapping, jsonPathPart, deferResolvingMappings);
        }
      }
      throw new Error(`Trying to retrieve '${jsonPathPart}' from mapping that contains no such key`);
    }
    case yamlAst.Kind.SEQ: {
      let astSub = yamlAstCurrent as yamlAst.YAMLSequence;
      if (typeof jsonPathPart !== "number") {
        throw new Error(`Trying to retrieve non-string item '${jsonPathPart}' from sequence`);
      }
      if (0 > jsonPathPart || jsonPathPart >= astSub.items.length) {
        throw new Error(`Trying to retrieve item '${jsonPathPart}' from sequence with '${astSub.items.length}' items (index out of bounds)`);
      }
      return astSub.items[jsonPathPart];
    }
    case yamlAst.Kind.ANCHOR_REF: {
      let astSub = yamlAstCurrent as yamlAst.YAMLAnchorReference;
      let newCurrent = resolveAnchorRef(yamlAstRoot, astSub.referencesAnchor);
      return resolvePathPart(yamlAstRoot, newCurrent, jsonPathPart, deferResolvingMappings);
    }
    case yamlAst.Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function resolvePathParts(yamlAstRoot: yamlAst.YAMLNode, jsonPathParts: jsonpath.PathComponent[]): number {
  if (jsonPathParts[0] !== "$") {
    throw new Error("Argument: Expected JSON path starting with $");
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
export function resolvePath(yaml: string, yamlAstRoot: yamlAst.YAMLNode, jsonPath: string | jsonpath.PathComponent[]): sourceMap.Position {
  if (typeof jsonPath === "string") {
    jsonPath = jsonpath.parse(jsonPath).map(part => part.value);
  }
  let textIndex = resolvePathParts(yamlAstRoot, jsonPath);
  return indexToPosition(yaml, textIndex);
}