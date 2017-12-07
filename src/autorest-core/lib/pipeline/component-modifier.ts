/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { CreatePerFilePlugin, PipelinePlugin } from './common';

export function GetPlugin_ComponentModifier(): PipelinePlugin {
  return CreatePerFilePlugin(async config => async (fileIn, sink) => {
    const componentModifier = (config.Raw as any).components;
    if (componentModifier) {
      const o = fileIn.ReadObject<any>();
      o["x-components"] = componentModifier;
      return await sink.WriteObject(fileIn.Description, o);
    }
    return fileIn;
  });
}