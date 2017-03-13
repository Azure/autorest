/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import * as path from "path";
import { ResolveUri } from "./lib/approved-imports/uri";
import { DataHandleRead, DataStoreViewReadonly } from "./lib/data-store/data-store";
import { MultiPromiseUtility } from "./lib/approved-imports/multi-promise";
import { AutoRestConfiguration } from "./lib/configuration/configuration"

const regexLegacyArg = /^-[^-]/;

export function isLegacy(args: string[]): boolean {
  return args.some(arg => regexLegacyArg.test(arg));
}

async function ParseCompositeSwagger(inputScope: DataStoreViewReadonly, uri: string, targetConfig: AutoRestConfiguration): Promise<void> {
  const compositeSwaggerFile = await inputScope.ReadStrict(uri);
  const data = await compositeSwaggerFile.ReadObject<{ info: any, documents: string[] }>();
  const documents = data.documents;
  targetConfig["input-file"] = documents.map(d => ResolveUri(uri, d));

  // forward info section
  targetConfig.__specials = targetConfig.__specials || {};
  targetConfig.__specials.infoSectionOverride = data.info;
}

export async function CreateConfiguration(baseFolderUri: string, inputScope: DataStoreViewReadonly, args: string[]): Promise<AutoRestConfiguration> {
  let result: AutoRestConfiguration = {
    "input-file": []
  };
  const switches: { [key: string]: string | null } = {};

  // parse
  let lastValue: string | null = null;
  for (const arg of args.reverse()) {
    if (arg.startsWith("-")) {
      switches[arg.substr(1).toLowerCase()] = lastValue;
      lastValue = null;
    } else {
      lastValue = arg;
    }
  }

  // extract
  const inputFile = switches["i"] || switches["input"];
  if (inputFile === null) {
    throw new Error("No input specified.");
  }
  result["input-file"] = inputFile;

  result["output-folder"] = switches["o"] || switches["output"] || switches["outputdirectory"] || "Generated";

  result.__specials = result.__specials || {};
  result.__specials.namespace = switches["n"] || switches["namespace"] || (() => { const x = inputFile.split("/").reverse()[0].split("\\").reverse()[0]; return x.substr(0, x.length - path.extname(x).length); })();

  const modeler = switches["m"] || switches["modeler"] || "Swagger";
  if (modeler === "CompositeSwagger") {
    await ParseCompositeSwagger(inputScope, ResolveUri(baseFolderUri, inputFile), result);
  }

  const codegenerator = switches["g"] || switches["codegenerator"] || "CSharp";
  result.__specials = result.__specials || {};
  if (codegenerator.toLowerCase() === "none") {
    result.__specials.azureValidator = true;
  } else {
    result.__specials.codeGenerator = codegenerator;
  }

  result.__specials.header = switches["header"] || null;

  result.__specials.payloadFlatteningThreshold = parseInt(switches["fs"] || switches["payloadflatteningthreshold"] || "0");

  result.__specials.syncMethods = <any>switches["syncmethods"] || null;

  return result;
}