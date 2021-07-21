import { YamlNodeWithPath } from "./parser";
import { Kind, YamlNode } from "./types";

/**
 * List all the child nodes of the providede root.
 * @param yamlAstNode Root.
 * @param currentPath
 * @param deferResolvingMappings
 */
export function* listYamlAstDecendants(
  yamlAstNode: YamlNode,
  currentPath: string[] = [],
  deferResolvingMappings = false,
): Iterable<YamlNodeWithPath> {
  const todos: YamlNodeWithPath[] = [{ path: currentPath, node: yamlAstNode }];
  let todo: YamlNodeWithPath | undefined;
  while ((todo = todos.pop())) {
    // report self
    yield todo;

    // traverse
    if (todo.node) {
      switch (todo.node.kind) {
        case Kind.MAPPING:
          {
            if (deferResolvingMappings) {
              todos.push({ node: todo.node.value, path: todo.path });
            } else {
              todos.push({ node: todo.node.value, path: todo.path.concat([todo.node.key.value]) });
            }
          }
          break;
        case Kind.MAP:
          if (deferResolvingMappings) {
            for (const mapping of todo.node.mappings) {
              todos.push({ node: mapping, path: todo.path.concat([mapping.key.value]) });
            }
          } else {
            for (const mapping of todo.node.mappings) {
              todos.push({ node: mapping, path: todo.path });
            }
          }
          break;
        case Kind.SEQ:
          {
            for (let i = 0; i < todo.node.items.length; ++i) {
              todos.push({ node: todo.node.items[i], path: todo.path.concat([i]) });
            }
          }
          break;
      }
    }
  }
}
