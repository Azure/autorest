import fs from "fs";
import { join } from "path";
import glob from "glob";

export const findFilesFromPattern = async (include: string): Promise<string[]> => {
  const pattern = await ensurePattern(include);
  return new Promise((resolve, reject) => {
    glob(pattern, (err, matches) => {
      if (err) {
        reject(err);
      }
      resolve(matches);
    });
  });
};

const ensurePattern = async (include: string) => {
  const stat = await fs.promises.stat(include);
  if (stat.isDirectory()) {
    return join(include, "**/*.md");
  }
  return include;
};

export const findFiles = async (include: string[]): Promise<string[]> => {
  const result = await Promise.all(include.map((path) => findFilesFromPattern(path)));
  return result.flatMap((x) => x);
};
