/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { deserialize, serialize } from "@azure-tools/codegen";
import { Host, startSession } from "@autorest/extension-base";
import * as OpenAPI from "@azure-tools/openapi";
import { ModelerFour } from "./modelerfour";
import { codeModelSchema, CodeModel } from "@autorest/codemodel";

export async function processRequest(host: Host) {
  const debug = (await host.GetValue("debug")) || false;

  try {
    const session = await startSession<OpenAPI.Model>(host, undefined, undefined, "prechecked-openapi-document");
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
      host.WriteFile("code-model-v4.yaml", serialize(codeModel, codeModelSchema), undefined, "code-model-v4");
    }
    if (options["emit-yaml-tags"] !== true) {
      host.WriteFile("code-model-v4-no-tags.yaml", serialize(codeModel), undefined, "code-model-v4-no-tags");
    }
  } catch (E) {
    if (debug) {
      // eslint-disable-next-line no-console
      console.error(`${__filename} - FAILURE  ${JSON.stringify(E)} ${E.stack}`);
    }
    throw E;
  }
}
