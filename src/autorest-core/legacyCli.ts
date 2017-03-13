/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

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

export async function CreateConfiguration(inputScope: DataStoreViewReadonly, args: string[]): Promise<AutoRestConfiguration> {
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

  const modeler = switches["m"] || switches["modeler"] || "Swagger";
  if (modeler === "CompositeSwagger") {
    await ParseCompositeSwagger(inputScope, inputFile, result);
  }

  return result;
}