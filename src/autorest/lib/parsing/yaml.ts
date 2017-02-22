/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yaml from "yaml-ast-parser";
import * as yamlAst from "./yamlAst";

function parseNodeInternal(yamlRootNode: yaml.YAMLNode, yamlNode: yaml.YAMLNode): any {
  switch (yamlNode.kind) {
    case yaml.Kind.SCALAR: {
      const yamlNodeScalar = yamlNode as yaml.YAMLScalar;
      return yamlNode.valueObject = yamlNodeScalar.valueObject || yamlNodeScalar.value;
    }
    case yaml.Kind.MAPPING:
      throw new Error(`Cannot turn single mapping into an object`);
    case yaml.Kind.MAP: {
      yamlNode.valueObject = {};
      const yamlNodeMapping = yamlNode as yaml.YamlMap;
      for (const mapping of yamlNodeMapping.mappings) {
        if (mapping.key.kind !== yaml.Kind.SCALAR) {
          throw new Error(`Only scalar keys are allowed`);
        }
        yamlNode.valueObject[mapping.key.value] = parseNodeInternal(yamlRootNode, mapping.value);
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.SEQ: {
      yamlNode.valueObject = [];
      const yamlNodeSequence = yamlNode as yaml.YAMLSequence;
      for (const item of yamlNodeSequence.items) {
        yamlNode.valueObject.push(parseNodeInternal(yamlRootNode, item));
      }
      return yamlNode.valueObject;
    }
    case yaml.Kind.ANCHOR_REF: {
      const yamlNodeRef = yamlNode as yaml.YAMLAnchorReference;
      return yamlAst.resolveAnchorRef(yamlRootNode, yamlNodeRef.referencesAnchor).valueObject;
    }
    case yaml.Kind.INCLUDE_REF:
      throw new Error(`INCLUDE_REF not implemented`);
  }
}

export function parseNode<T>(yamlNode: yaml.YAMLNode): T {
  parseNodeInternal(yamlNode, yamlNode);
  return yamlNode.valueObject;
}

export function parse<T>(rawYaml: string): T {
  const node = yamlAst.parse(rawYaml);
  return parseNode<T>(node);
}

export function stringify(object: any): string {
  return yaml.safeDump(object, null);
}