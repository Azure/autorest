import commonmark from "commonmark";
import { MarkdownTreeNode } from "./md-tree";
import { cleanRender } from "./md-utils";

/**
 * List of languages that can be used in code blocks.
 */
export type Language = "json" | "yaml" | "xml";

export interface ExtractedCodeBlock {
  language: Language;
  content: string;
}

/**
 * Extract a code block from a tree node.
 * @param node Tree node.
 * @param sectionName Section name(for logging).
 */
export const extractCodeBlockFromTreeNode = (node: MarkdownTreeNode, sectionName: string): ExtractedCodeBlock => {
  const child = node.children[0];
  if (child === undefined) {
    throw new Error(`${sectionName} section must have a code block content but found nothing`);
  }
  if ("heading" in child) {
    throw new Error(`Unexpected heading '${cleanRender(child.heading)}' found in ${sectionName} section.`);
  }
  return extractCodeBlockFromMarkdownNode(child, sectionName);
};

/**
 * Extract the code block information from a markdown node.
 * @param node Commonmark node
 * @param sectionName Section name(for logging)
 */
export const extractCodeBlockFromMarkdownNode = (node: commonmark.Node, sectionName: string): ExtractedCodeBlock => {
  if (node.type !== "code_block") {
    throw new Error(`Unexpected element under ${sectionName} section. Expected code block but got ${node.type}`);
  }

  if (node.literal === null) {
    throw new Error("Code block has not content under ${sectionName} section.");
  }

  return {
    language: (node.info ?? "") as ExtractedCodeBlock["language"],
    content: node.literal,
  };
};
