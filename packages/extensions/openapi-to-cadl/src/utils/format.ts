import { format } from "prettier";
import { getLogger } from "./logger";

export function formatFile(content: string, filepath: string) {
  return format(content, {
    filepath,
  });
}

export function formatCadlFile(content: string, filepath: string): string {
  try {
    return format(content, {
      plugins: ["@typespec/prettier-plugin-typespec"],
      pluginSearchDirs: ["./node_modules"],
      filepath,
    });
  } catch {
    return content;
  }
}
