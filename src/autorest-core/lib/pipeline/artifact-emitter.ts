/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Lazy } from "../lazy";
import { Stringify, YAMLNode, Normalize } from "../ref/yaml";
import { IdentitySourceMapping } from "../source-map/merging";
import { Channel } from "../message";
import { ConfigurationView } from "../configuration";
import { DataHandle, DataSource } from "../data-store/data-store";

function IsOutputArtifactOrMapRequested(config: ConfigurationView, artifactType: string) {
  return config.IsOutputArtifactRequested(artifactType) || config.IsOutputArtifactRequested(artifactType + ".map");
}

async function EmitArtifactInternal(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandle): Promise<void> {
  config.Message({ Channel: Channel.Debug, Text: `Emitting '${artifactType}' at ${uri}` });
  if (config.IsOutputArtifactRequested(artifactType)) {
    const content = handle.ReadData();
    if (content !== "") {
      config.GeneratedFile.Dispatch({
        type: artifactType,
        uri: uri,
        content: content
      });
    }
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
async function EmitArtifact(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandle, isObject: boolean): Promise<void> {
  await EmitArtifactInternal(config, artifactType, uri, handle);

  if (isObject) {
    const sink = config.DataStore.getDataSink();
    const object = new Lazy<any>(() => handle.ReadObject<any>());
    const ast = new Lazy<YAMLNode>(() => handle.ReadYamlAst());

    if (IsOutputArtifactOrMapRequested(config, artifactType + ".yaml")) {
      const h = await sink.WriteData(`${++emitCtr}.yaml`, Stringify(Normalize(object.Value)), IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".yaml", uri + ".yaml", h);
    }
    if (IsOutputArtifactOrMapRequested(config, artifactType + ".json")) {
      const h = await sink.WriteData(`${++emitCtr}.json`, JSON.stringify(Normalize(object.Value), null, 2), IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".json", uri + ".json", h);
    }
  }
}

export async function EmitArtifacts(config: ConfigurationView, artifactType: string, uriResolver: (key: string) => string, scope: DataSource, isObject: boolean): Promise<void> {
  for (const key of await scope.Enum()) {
    const file = await scope.ReadStrict(key);
    await EmitArtifact(config, artifactType, uriResolver(file.Description), file, isObject);
  }
}