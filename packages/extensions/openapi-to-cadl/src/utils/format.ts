import { format } from "prettier";

export function formatFile(content: string, filepath: string) {
  return format(content, {
    filepath,
  });
}

export async function formatCadlFile(content: string, filepath: string): Promise<string> {
  try {
    return await format(content, {
      plugins: ["@typespec/prettier-plugin-typespec"],
      filepath,
    });
  } catch {
    return content;
  }
}
