/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { serialize } from "@azure-tools/codegen";
import { Host, startSession } from "@autorest/extension-base";
import { codeModelSchema, CodeModel } from "@autorest/codemodel";
import { Example } from "./example";

export async function processRequest(host: Host) {
  const debug = (await host.GetValue("debug")) || false;

  try {
    const session = await startSession<CodeModel>(host, {}, codeModelSchema);

    // process
    const plugin = new Example(session);

    // go!
    const result = plugin.process();

    // output the model to the pipeline
    host.WriteFile("code-model-v4.yaml", serialize(result, codeModelSchema), undefined, "code-model-v4");
    host.WriteFile("code-model-v4-no-tags.yaml", serialize(result), undefined, "code-model-v4-no-tags");
  } catch (E) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(E)} ${E.stack}`);
    }
    throw E;
  }
}
