/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { codeModelSchema, CodeModel } from "@autorest/codemodel";
import { Host, Session, startSession } from "@autorest/extension-base";
import { deserialize, serialize } from "@azure-tools/codegen";
import { RealFileSystem } from "@azure-tools/datastore";
import { resolveUri } from "@azure-tools/uri";
import { ModelerFourOptions } from "modeler/modelerfour-options";
import { mergeCodeModelWithPreviousVersion } from "./previous-version-merger";

export async function processRequest(host: Host) {
  const debug = (await host.GetValue("debug")) || false;

  try {
    const session = await startSession<CodeModel>(host, {}, codeModelSchema);
    const options = await session.getValue<ModelerFourOptions>("modelerfour", {});

    // process
    let result = session.model;

    if (options["merge-with-older-version"]) {
      const previousModel = await loadPreviousVersion(session, options["merge-with-older-version"]);
      result = await mergeCodeModelWithPreviousVersion(session, session.model, previousModel);
    }

    // throw on errors.
    if (!(await session.getValue("no-errors", false))) {
      session.checkpoint();
    }

    // output the model to the pipeline
    if ((options as any)["emit-yaml-tags"] !== false) {
      host.WriteFile("code-model-v4.yaml", serialize(result, codeModelSchema), undefined, "code-model-v4");
    }

    if ((options as any)["emit-yaml-tags"] !== true) {
      host.WriteFile("code-model-v4-no-tags.yaml", serialize(result), undefined, "code-model-v4-no-tags");
    }
  } catch (error: any) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(error)} ${error.stack}`);
    }
    throw error;
  }
}

async function loadPreviousVersion(session: Session<CodeModel>, path: string): Promise<CodeModel> {
  const configFileFolderUri = await session.getValue<string>("configFileFolderUri");
  const fs = new RealFileSystem();

  const content = await fs.read(resolveUri(configFileFolderUri, path));
  return deserialize<CodeModel>(content, path, codeModelSchema);
}
