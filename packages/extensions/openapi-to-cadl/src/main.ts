// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import { existsSync, mkdirSync } from "fs";
import { join } from "path";
import { CodeModel, codeModelSchema } from "@autorest/codemodel";
import { AutoRestExtension, AutorestExtensionHost, Session, startSession } from "@autorest/extension-base";
import { markErrorModels } from "./utils/errors";
import { setSession } from "./autorest-session";
import { emitCadlConfig } from "./emiters/emit-cadl-config";
import { emitMain } from "./emiters/emit-main";

import { emitModels } from "./emiters/emit-models";
import { emitPackage } from "./emiters/emit-package";
import { emitRoutes } from "./emiters/emit-routes";
import { getModel } from "./model";
import { markPagination } from "./utils/paging";
import { markResources } from "./utils/resources";

export async function processRequest(host: AutorestExtensionHost) {
  const session = await startSession<CodeModel>(host, codeModelSchema);
  setSession(session);
  const codeModel = session.model;
  markPagination(codeModel);
  markErrorModels(codeModel);
  markResources(codeModel);
  const cadlProgramDetails = getModel(codeModel);
  createOutputFolder(getFilePath(session, ""));
  await emitModels(getFilePath(session, "models.cadl"), cadlProgramDetails);
  await emitRoutes(getFilePath(session, "routes.cadl"), cadlProgramDetails);
  await emitMain(getFilePath(session, "main.cadl"), cadlProgramDetails);
  await emitPackage(getFilePath(session, "package.json"), cadlProgramDetails);
  await emitCadlConfig(getFilePath(session, "cadl-project.yaml"));
}

function createOutputFolder(dir: string) {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
}

function getOutuptDirectory(session: Session<CodeModel>) {
  const outputFolder = session.configuration["output-folder"] ?? ".";
  const srcPath = session.configuration["src-path"] ?? "";
  return join(outputFolder, srcPath);
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
