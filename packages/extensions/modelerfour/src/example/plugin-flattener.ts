/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { codeModelSchema, CodeModel } from "@autorest/codemodel";
import { AutorestExtensionHost, startSession } from "@autorest/extension-base";
import { serialize } from "@azure-tools/codegen";
import { Example } from "./example";

export async function processRequest(host: AutorestExtensionHost) {
  const debug = (await host.getValue("debug")) || false;

  try {
    const session = await startSession<CodeModel>(host, codeModelSchema);

    // process
    const plugin = new Example(session);

    // go!
    const result = plugin.process();

    // output the model to the pipeline
    host.writeFile({
      filename: "code-model-v4.yaml",
      content: serialize(result, codeModelSchema),
      artifactType: "code-model-v4",
    });
    host.writeFile({
      filename: "code-model-v4-no-tags.yaml",
      content: serialize(result),
      artifactType: "code-model-v4-no-tags",
    });
  } catch (error: any) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(error)} ${error.stack}`);
    }
    throw error;
  }
}
