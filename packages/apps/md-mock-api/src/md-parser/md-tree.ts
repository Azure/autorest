import * as commonmark from "commonmark";
import { cleanRender } from "./md-utils";

export interface MarkdownTreeNode {
  heading: commonmark.Node;
  children: Array<MarkdownTreeNode | commonmark.Node>;
}

export const convertToTree = (document: commonmark.Node): MarkdownTreeNode => {
  const firstNode: commonmark.Node | null = document.firstChild;
  if (firstNode === null || firstNode.type !== "heading") {
    throw new Error("Document must start with a heading.");
  }

  // This lets have the title of the document not take a makrdown hading level(So the structure can start at heading 1: #)
  firstNode.level = 0;
  const root: MarkdownTreeNode = {
    heading: firstNode,
    children: [],
  };
  readAtLevel(firstNode, root, firstNode.level);
  return root;
};

const readAtLevel = (
  previousNode: commonmark.Node,
  treeNode: MarkdownTreeNode,
  level: number,
): commonmark.Node | null => {
  let currentNode: commonmark.Node | null = previousNode.next;
  while (currentNode) {
    if (currentNode.type === "heading") {
      if (currentNode.level > level) {
        const child: MarkdownTreeNode = {
          heading: currentNode,
          children: [],
        };
        treeNode.children.push(child);
        const result = readAtLevel(currentNode, child, currentNode.level);
        if (result === null) {
          return null;
        }
        if (result.level <= level) {
          return result;
        }
        currentNode = result;
        continue; // Skip currentNode.next
      } else {
        return currentNode;
      }
    } else {
      treeNode.children.push(currentNode);
    }
    currentNode = currentNode.next;
  }
  return null;
};

export const dumpMarkdownTree = (tree: MarkdownTreeNode): string => dumpMarkdownTreeAtLevel(tree, 0);

const dumpMarkdownTreeAtLevel = (node: MarkdownTreeNode, level: number) => {
  const indent = "  ".repeat(level);
  let result = `${indent}${cleanRender(node.heading)}\n`;

  for (const child of node.children) {
    if ("heading" in child) {
      result += dumpMarkdownTreeAtLevel(child, level + 1);
    }
  }
  return result;
};
