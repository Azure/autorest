import glob from "glob";

export async function findFilesFromPattern(pattern: string): Promise<string[]> {
  return new Promise((resolve, reject) => {
    glob(pattern, (err, matches) => {
      if (err) {
        reject(err);
      }
      resolve(matches);
    });
  });
}

export async function findFiles(include: string[]): Promise<string[]> {
  const result = await Promise.all(include.map((path) => findFilesFromPattern(path)));
  return result.flat();
}
