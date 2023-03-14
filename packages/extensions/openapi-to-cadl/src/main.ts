// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import { join } from "path";
import { CodeModel, codeModelSchema } from "@autorest/codemodel";
import { AutoRestExtension, AutorestExtensionHost, Session, startSession } from "@autorest/extension-base";
import { setSession } from "./autorest-session";
import { emitCadlConfig } from "./emiters/emit-cadl-config";
import { emitMain } from "./emiters/emit-main";

import { emitModels } from "./emiters/emit-models";
import { emitPackage } from "./emiters/emit-package";
import { emitRoutes } from "./emiters/emit-routes";
import { getModel } from "./model";
import { pretransformNames } from "./pretransforms/name-pretransform";
import { markErrorModels } from "./utils/errors";
import { markPagination } from "./utils/paging";
import { markResources } from "./utils/resources";

export async function processRequest(host: AutorestExtensionHost) {
  const session = await startSession<CodeModel>(host, codeModelSchema);
  setSession(session);
  const codeModel = session.model;
  pretransformNames(codeModel);
  markPagination(codeModel);
  markErrorModels(codeModel);
  markResources(codeModel);
  const cadlProgramDetails = getModel(codeModel);
  await emitModels(getFilePath(session, "models.tsp"), cadlProgramDetails);
  await emitRoutes(getFilePath(session, "routes.tsp"), cadlProgramDetails);
  await emitMain(getFilePath(session, "main.tsp"), cadlProgramDetails);
  await emitPackage(getFilePath(session, "package.json"), cadlProgramDetails);
  await emitCadlConfig(getFilePath(session, "tspconfig.yaml"));
}

function getOutuptDirectory(session: Session<CodeModel>) {
  return session.configuration["src-path"] ?? "";
}

function getFilePath(session: Session<CodeModel>, fileName: string) {
  return join(getOutuptDirectory(session), fileName);
}

async function main() {
  const pluginHost = new AutoRestExtension();
  pluginHost.add("openapi-to-cadl", processRequest);
  await pluginHost.run();
}

main().catch((e) => {
  throw new Error(e);
});
