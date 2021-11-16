/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { codeModelSchema } from "@autorest/codemodel";
import { AutorestExtensionHost, startSession } from "@autorest/extension-base";
import { serialize } from "@azure-tools/codegen";
import * as OpenAPI from "@azure-tools/openapi";
import { ModelerFour } from "./modelerfour";

export async function processRequest(host: AutorestExtensionHost) {
  const debug = (await host.getValue("debug")) || false;

  try {
    const session = await startSession<OpenAPI.Model>(host, undefined, "prechecked-openapi-document");
    const options = <any>await session.getValue("modelerfour", {});

    // process
    const modeler = await new ModelerFour(session).init();

    // go!
    const codeModel = modeler.process();

    // throw on errors.
    if (!(await session.getValue("ignore-errors", false))) {
      session.checkpoint();
    }

    // output the model to the pipeline
    if (options["emit-yaml-tags"] !== false) {
      host.writeFile({
        filename: "code-model-v4.yaml",
        content: serialize(codeModel, codeModelSchema),
        artifactType: "code-model-v4",
      });
    }
    if (options["emit-yaml-tags"] !== true) {
      host.writeFile({
        filename: "code-model-v4-no-tags.yaml",
        content: serialize(codeModel),
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
