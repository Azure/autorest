// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import { join } from "path";
import { getSession } from "../autorest-session";
import { formatTypespecFile } from "../utils/format";
import { readFileSync } from "fs";

export async function emitLegacy(filePath: string): Promise<void> {
  const session = getSession();
  const path = join(__dirname, "..", "assets", "legacy.tsp");

  const legacyContent = readFileSync(path, "utf-8");
  session.writeFile({ filename: filePath, content: await formatTypespecFile(legacyContent, filePath) });
}
