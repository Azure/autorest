/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfigurationManager } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/dataStore";
import { parse } from "../parsing/literateYaml";
import { mergeYamls } from "../source-map/merging";

export type PipelineProducts = { [productKey: string]: DataStoreViewReadonly };

export class Pipeline {
  constructor(private configuration: AutoRestConfigurationManager) {
  }

  private async build(): Promise<void> {
    // bleep
  }

  public async run(pipelineView: DataStoreView): Promise<PipelineProducts> {
    await this.build();

    // RUN pipeline
    const result: PipelineProducts = {};

    // load Swaggers
    const swaggerScope = pipelineView.createScope("swagger");
    const deliteralizeScope = swaggerScope.createFileScope("deliteralize");
    const rawSwaggers: DataHandleRead[] = []
    for (const inputFileUri of this.configuration.inputFileUris) {
      // read literate Swagger
      const readThroughScope = pipelineView.createReadThroughScope(KnownScopes.Input, uri => uri === inputFileUri);
      const hLiterateSwaggerFile = await readThroughScope.read(inputFileUri);
      if (hLiterateSwaggerFile === null) {
        throw new Error(`Swagger file '${inputFileUri}' not found.`);
      }

      // deliterlatize
      const hwRawSwagger = await deliteralizeScope.write(inputFileUri);
      const hRawSwagger = await parse(hLiterateSwaggerFile, hwRawSwagger, swaggerScope.createScope("tmp"));
      rawSwaggers.push(hRawSwagger);
    }
    // merge swaggers
    const hwSwagger = await swaggerScope.write("swagger.yaml");
    const hSwagger = await mergeYamls(rawSwaggers, hwSwagger);

    return result;
  }
}