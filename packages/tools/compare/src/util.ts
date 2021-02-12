// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import * as fs from "fs";
import * as path from "path";

/**
 * Returns a flat list of file paths recursively under the specified folderPath.
 */
export function getPathsRecursively(folderPath: string): string[] {
  let filesInPath: string[] = [];

  if (!fs.existsSync(folderPath)) {
    return [];
  }

  for (const childPath of fs.readdirSync(folderPath)) {
    const rootedPath = path.join(folderPath, childPath);
    if (fs.statSync(rootedPath).isDirectory()) {
      filesInPath = filesInPath.concat(getPathsRecursively(rootedPath));
    } else {
      filesInPath.push(rootedPath);
    }
  }

  return filesInPath;
}
