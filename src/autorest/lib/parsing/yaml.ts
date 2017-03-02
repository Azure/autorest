/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { safeDump } from "yaml-ast-parser";
import * as yamlAst from "./yamlAst";

function parseNodeInternal(yamlRootNode: yamlAst.YAMLNode, yamlNode: yamlAst.YAMLNode): any {
  switch (yamlNode.kind) {
    case yamlAst.Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as yamlAst.YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject || yamlNodeScalar.value;
    }
    case yamlAst.Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case yamlAst.Kind.MAP: {
      yamlNode.valueObject = {};
      const yamlNodeMapping = yamlNode as yamlAst.YAMLMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== yamlAst.Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = parseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case yamlAst.Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as yamlAst.YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(parseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case yamlAst.Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as yamlAst.YAMLAnchorReference;
      return yamlAst.resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).valueObject;
    }
    case yamlAst.Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function parseNode<T>(yamlNode: yamlAst.YAMLNode): T {
  parseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function parse<T>(rawYaml: string): T {
  const node = yamlAst.parse(rawYaml);
  return parseNode<T>(node);
}

export function stringify(object: any): string {
  return "---\n" + safeDump(object, null);
}