/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy, LazyPromise } from '../lazy';
import { Stringify, YAMLNode } from "../ref/yaml";
import { IdentitySourceMapping } from "../source-map/merging";
import { Channel } from "../message";
import { ConfigurationView } from "../configuration";
import { DataHandleRead, DataStoreViewReadonly } from "../data-store/data-store";

function IsOutputArtifactOrMapRequested(config: ConfigurationView, artifactType: string) {
  return config.IsOutputArtifactRequested(artifactType) || config.IsOutputArtifactRequested(artifactType + ".map");
}

async function EmitArtifactInternal(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandleRead): Promise<void> {
  config.Message({ Channel: Channel.Debug, Text: `Emitting '${artifactType}' at ${uri}` });
  if (config.IsOutputArtifactRequested(artifactType)) {
    config.GeneratedFile.Dispatch({
      type: artifactType,
      uri: uri,
      content: handle.ReadData()
    });
  }
  if (config.IsOutputArtifactRequested(artifactType + ".map")) {
    config.GeneratedFile.Dispatch({
      type: artifactType + ".map",
      uri: uri + ".map",
      content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2)
    });
  }
}
let emitCtr = 0;
async function EmitArtifact(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandleRead, isObject: boolean): Promise<void> {
  await EmitArtifactInternal(config, artifactType, uri, handle);

  if (isObject) {
    const scope = config.DataStore.CreateScope("emitObjectArtifact");
    const object = new Lazy<any>(() => handle.ReadObject<any>());
    const ast = new Lazy<YAMLNode>(() => handle.ReadYamlAst());

    if (IsOutputArtifactOrMapRequested(config, artifactType + ".yaml")) {
      const hw = await scope.Write(`${++emitCtr}.yaml`);
      const h = await hw.WriteData(Stringify(object.Value), IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".yaml", uri + ".yaml", h);
    }
    if (IsOutputArtifactOrMapRequested(config, artifactType + ".json")) {
      const hw = await scope.Write(`${++emitCtr}.json`);
      const h = await hw.WriteData(JSON.stringify(object.Value, null, 2), IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".json", uri + ".json", h);
    }
  }
}

export async function EmitArtifacts(config: ConfigurationView, artifactType: string, uriResolver: (key: string) => string, scope: DataStoreViewReadonly, isObject: boolean): Promise<void> {
  for (const key of await scope.Enum()) {
    const file = await scope.ReadStrict(key);
    await EmitArtifact(config, artifactType, uriResolver(file.key), file, isObject);
  }
}