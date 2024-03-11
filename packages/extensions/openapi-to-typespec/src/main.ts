// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

import { join } from "path";
import { CodeModel, codeModelSchema } from "@autorest/codemodel";
import { AutoRestExtension, AutorestExtensionHost, Session, startSession } from "@autorest/extension-base";
import { OpenAPI3Document } from "@azure-tools/openapi";
import { setArmCommonTypeVersion, setSession } from "./autorest-session";
import { emitArmResources } from "./emiters/emit-arm-resources";
import { emitClient } from "./emiters/emit-client";
import { emitMain } from "./emiters/emit-main";

import { emitModels } from "./emiters/emit-models";
import { emitPackage } from "./emiters/emit-package";
import { emitRoutes } from "./emiters/emit-routes";
import { emitTypespecConfig } from "./emiters/emit-typespec-config";
import { getModel } from "./model";
import { pretransformArmResources } from "./pretransforms/arm-pretransform";
import { pretransformNames } from "./pretransforms/name-pretransform";
import { pretransformRename } from "./pretransforms/rename-pretransform";
import { markErrorModels } from "./utils/errors";
import { markPagination } from "./utils/paging";
import { markResources } from "./utils/resources";

export async function processConverter(host: AutorestExtensionHost) {
  const session = await startSession<CodeModel>(host, codeModelSchema);
  setSession(session);
  const codeModel = session.model;
  pretransformNames(codeModel);
  pretransformArmResources(codeModel);
  pretransformRename(codeModel);
  markPagination(codeModel);
  markErrorModels(codeModel);
  markResources(codeModel);
  const programDetails = getModel(codeModel);
  await emitArmResources(programDetails, getOutuptDirectory(session));
  await emitModels(getFilePath(session, "models.tsp"), programDetails);
  await emitRoutes(getFilePath(session, "routes.tsp"), programDetails);
  await emitMain(getFilePath(session, "main.tsp"), programDetails);
  await emitPackage(getFilePath(session, "package.json"), programDetails);
  await emitTypespecConfig(getFilePath(session, "tspconfig.yaml"), programDetails);
  await emitClient(getFilePath(session, "client.tsp"), programDetails);
}

function getOutuptDirectory(session: Session<CodeModel>) {
  return session.configuration["src-path"] ?? "";
}

function getFilePath(session: Session<CodeModel>, fileName: string) {
  return join(getOutuptDirectory(session), fileName);
}

async function main() {
  const pluginHost = new AutoRestExtension();
  pluginHost.add("source-swagger-detector", processDetector);
  pluginHost.add("openapi-to-typespec", processConverter);
  await pluginHost.run();
}

main().catch((e) => {
  throw new Error(e);
});

export async function processDetector(host: AutorestExtensionHost) {
  const session = await startSession<OpenAPI3Document>(host, codeModelSchema);
  if (session.model.components?.schemas) {
    for (const v of Object.values(session.model.components.schemas)) {
      if (v["x-ms-metadata"]?.originalLocations) {
        for (const p of v["x-ms-metadata"].originalLocations) {
          const result = p.match(/\/common-types\/resource-management\/(v\d)\//);
          if (result) {
            setArmCommonTypeVersion(result[1]);
            return;
          }
        }
      }
    }
  }
}
