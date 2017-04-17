import { IndexToPosition } from '../parsing/text-utility';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yamlAst from "yaml-ast-parser";
import { JsonPath } from "./jsonpath";
import { Message, SourceLocation, Channel } from '../message';
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
  const todos: YAMLNodeWithPath[] = [{ path: currentPath, node: yamlAstNode }];
  let todo: YAMLNodeWithPath | undefined;
  while (todo = todos.pop()) {
    // report self
    yield todo;

    // traverse
    if (todo.node) {
      switch (todo.node.kind) {
        case Kind.MAPPING: {
          let astSub = todo.node as YAMLMapping;
          if (deferResolvingMappings) {
            todos.push({ node: astSub.value, path: todo.path });
          } else {
            todos.push({ node: astSub.value, path: todo.path.concat([astSub.key.value]) });
          }
        }
          break;
        case Kind.MAP:
          if (deferResolvingMappings) {
            for (let mapping of (todo.node as YAMLMap).mappings) {
              todos.push({ node: mapping, path: todo.path.concat([mapping.key.value]) });
            }
          } else {
            for (let mapping of (todo.node as YAMLMap).mappings) {
              todos.push({ node: mapping, path: todo.path });
            }
          }
          break;
        case Kind.SEQ: {
          let astSub = todo.node as YAMLSequence;
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
  for (let yamlAstNode of Descendants(yamlAstRoot)) {
    if (yamlAstNode.node.anchorId === anchorRef) {
      return yamlAstNode;
    }
  }
  throw new Error(`Anchor '${anchorRef}' not found`);
}

function ParseNodeInternal(yamlRootNode: YAMLNode, yamlNode: YAMLNode, onError: (message: string, index: number) => void): any {
  if (yamlNode.errors.length > 0) {
    for (const error of yamlNode.errors) {
      onError(`Syntax error: ${error.reason}`, error.mark.position);
    }
    return null;
  }

  switch (yamlNode.kind) {
    case Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject !== undefined
        ? yamlNodeScalar.valueObject
        : yamlNodeScalar.value;
    }
    case Kind.MAPPING:
      onError("Syntax error: Encountered single mapping.", yamlNode.startPosition);
      return null;
    case Kind.MAP: {
      yamlNode.valueObject = NewEmptyObject();
      const yamlNodeMapping = yamlNode as YAMLMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== Kind.SCALAR) {
          onError("Syntax error: Only scalar keys are allowed as mapping keys.", mapping.key.startPosition);
        } else if (mapping.value === null) {
          onError("Syntax error: No mapping value found.", mapping.key.endPosition);
        } else {
          yamlNode.valueObject[mapping.key.value] = ParseNodeInternal(yamlRootNode, mapping.value, onError);
        }
      }
      return yamlNode.valueObject;
    }
    case Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(ParseNodeInternal(yamlRootNode, item, onError));
      }
      return yamlNode.valueObject;
    }
    case Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as YAMLAnchorReference;
      return ResolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).node.valueObject;
    }
    case Kind.INCLUDE_REF:
      onError("Syntax error: INCLUDE_REF not implemented.", yamlNode.startPosition);
      return null;
  }
}

export function ParseNode<T>(yamlNode: YAMLNode, onError: (message: string, index: number) => void = message => { throw new Error(message); }): T {
  ParseNodeInternal(yamlNode, yamlNode, onError);
  return yamlNode.valueObject;
}

export function CloneAst<T extends YAMLNode>(ast: T): T {
  return ParseToAst(StringifyAst(ast)) as T;
}
export function StringifyAst(ast: YAMLNode): string {
  return FastStringify(ParseNode<any>(ast));
}
export function Clone<T>(object: T): T {
  return Parse<T>(FastStringify(object));
}
export function ToAst<T>(object: T): YAMLNode {
  return ParseToAst(FastStringify(object));
}

export function Parse<T>(rawYaml: string, onError: (message: string, index: number) => void = message => { throw new Error(message); }): T {
  const node = ParseToAst(rawYaml);
  const result = ParseNode<T>(node, onError);
  return result;
}

export function Stringify<T>(object: T): string {
  return "---\n" + yamlAst.safeDump(object, { skipInvalid: true });
}

export function FastStringify<T>(obj: T): string {
  try {
    return JSON.stringify(obj);
  } catch (e) {
    return Stringify(obj);
  }
}
