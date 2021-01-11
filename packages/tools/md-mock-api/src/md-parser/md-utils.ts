import * as commonmark from "commonmark";

/**
 * Minimal rendering of the provided node(Will not apply any style).
 * @param node Markdown node.
 */
export const cleanRender = (node: commonmark.Node): string => {
  const walker = node.walker();
  let current;
  const results = [];
  while ((current = walker.next())) {
    results.push(current.node.literal);
  }
  return results.join(" ").trim();
};

export const renderSectionPath = (path: string[]): string => path.join(" > ");
