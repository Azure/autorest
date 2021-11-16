/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { codeModelSchema, CodeModel } from "@autorest/codemodel";
import { AutorestExtensionHost, startSession } from "@autorest/extension-base";
import { serialize } from "@azure-tools/codegen";
import { Flattener } from "./flattener";

export async function processRequest(host: AutorestExtensionHost) {
  const debug = (await host.getValue("debug")) || false;

  try {
    const session = await startSession<CodeModel>(host, codeModelSchema);
    const options = <any>await session.getValue("modelerfour", {});

    // process
    const plugin = await new Flattener(session).init();

    // go!
    const result = plugin.process();

    // output the model to the pipeline
    if (options["emit-yaml-tags"] !== false) {
      host.writeFile({
        filename: "code-model-v4.yaml",
        content: serialize(result, codeModelSchema),
        artifactType: "code-model-v4",
      });
    }

    if (options["emit-yaml-tags"] !== true) {
      host.writeFile({
        filename: "code-model-v4-no-tags.yaml",
        content: serialize(result),
        artifactType: "code-model-v4-no-tags",
      });
    }
  } catch (error: any) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(error)} ${error.stack}`);
    }
    throw error;
  }
}
