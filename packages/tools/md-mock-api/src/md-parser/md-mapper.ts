import * as commonmark from "commonmark";
import { MarkdownTreeNode } from "./md-tree";
import { cleanRender, renderSectionPath } from "./md-utils";

export type TreeNodeMapping<K extends string> = {
  [P in K]: MappingEntry;
};

export type MappingEntry = HeadingMapping | NodeMapping;

export type HeadingMapping = {
  type: "heading";
  name: string;
  required?: boolean;
  process: (child: MarkdownTreeNode) => unknown;
};

export type NodeMapping = {
  type: "code_block"; // Only code block supported for now.
  required?: boolean;
  process: (child: commonmark.Node) => unknown;
};

export type InferType<T extends MappingEntry> = T extends { required: true }
  ? RequiredType<T>
  : RequiredType<T> | undefined;

export type RequiredType<T extends MappingEntry> = T extends { process: (arg: never) => infer T } ? T : unknown;

type WithKey<T> = T & { key: string };
type HeadingMap = { [key: string]: WithKey<HeadingMapping> };

export const mapMarkdownTree = <K extends string, U extends TreeNodeMapping<K>>(
  path: string[],
  node: MarkdownTreeNode,
  mapping: U,
): { [P in K]: InferType<U[P]> } => {
  const sectionName = renderSectionPath(path);
  const { headings, codeBlock } = processMappings(mapping);

  const result: { [key: string]: unknown } = {};
  for (const child of node.children) {
    if ("heading" in child) {
      const childTitle = cleanRender(child.heading);
      const mapping = headings[childTitle];
      if (mapping) {
        result[mapping.key] = mapping.process(child);
      } else {
        throw new Error(`Unexpected heading ${childTitle} under section ${sectionName}`);
      }
    } else if (child.type === "code_block" && codeBlock) {
      result[codeBlock.key] = codeBlock.process(child);
    } else {
      throw new Error(`Unexpected element ${child.type} under section ${sectionName}`);
    }
  }

  validateRequiredMapping(sectionName, mapping, result);

  return result as unknown as { [P in K]: InferType<U[P]> };
};

const processMappings = (mapping: TreeNodeMapping<string>) => {
  const headings: HeadingMap = {};
  let codeBlock: WithKey<NodeMapping> | undefined;
  for (const [key, value] of Object.entries<MappingEntry>(mapping)) {
    switch (value.type) {
      case "heading":
        headings[value.name] = { key, ...value };
        break;
      case "code_block":
        if (codeBlock !== undefined) {
          throw new Error("Found 2 mapping definition for the code_block");
        }
        codeBlock = { key, ...value };
        break;
    }
  }
  return { headings, codeBlock };
};

const validateRequiredMapping = (
  sectionName: string,
  mapping: TreeNodeMapping<string>,
  result: { [key: string]: unknown },
) => {
  for (const [key, value] of Object.entries<MappingEntry>(mapping)) {
    if (value.required && result[key] === undefined) {
      const name = value.type === "heading" ? `heading named '${value.name}'` : value.type;
      throw new Error(`Error: expected section ${sectionName} to contain a ${name}`);
    }
  }
};
