import { Kind, YAMLNode as YamlNodeBase } from "yaml-ast-parser";
export { Kind } from "yaml-ast-parser";

export type YamlNode = YamlScalar | YamlMapping | YamlMap | YamlSequence | YamlAnchorReference | YamlIncludeReference;

export interface YamlScalar extends YamlNodeBase {
  kind: Kind.SCALAR;
  value: string;
  doubleQuoted?: boolean;
  singleQuoted?: boolean;
  plainScalar?: boolean;
  rawValue: string;
}

export interface YamlMapping extends YamlNodeBase {
  kind: Kind.MAPPING;
  key: YamlScalar;
  value: YamlNode;
}

export interface YamlSequence extends YamlNodeBase {
  kind: Kind.SEQ;
  items: YamlNode[];
}

export interface YamlMap extends YamlNodeBase {
  kind: Kind.MAP;
  mappings: YamlMapping[];
}

export interface YamlAnchorReference extends YamlNodeBase {
  kind: Kind.ANCHOR_REF;
  referencesAnchor: string;
  value: YamlNode;
}

export interface YamlIncludeReference extends YamlNodeBase {
  kind: Kind.INCLUDE_REF;
}
