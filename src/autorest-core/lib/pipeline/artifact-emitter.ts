import { Artifact } from '../../main';
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
  const emitArtifact = (artifact: Artifact): void => {
    if (artifact.uri.startsWith("stdout://")) {
      config.Message({
        Channel: Channel.Information,
        Details: artifact,
        Text: `Artifact '${artifact.uri.slice("stdout://".length)}' of type '${artifact.type}' has been emitted.`,
        Plugin: "emitter"
      });
    } else {
      config.GeneratedFile.Dispatch(artifact);
    }
  }
  if (config.IsOutputArtifactRequested(artifactType)) {
    const content = handle.ReadData();
    if (content !== "") {
      emitArtifact({
        type: artifactType,
        uri: uri,
        content: content
      });
    }
  }
  if (config.IsOutputArtifactRequested(artifactType + ".map")) {
    emitArtifact({
      type: artifactType + ".map",
      uri: uri + ".map",
      content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2)
    });
  }
}
let emitCtr = 0;
async function EmitArtifact(config: ConfigurationView, uri: string, handle: DataHandle, isObject: boolean): Promise<void> {
  const artifactType = handle.GetArtifact();
  await EmitArtifactInternal(config, artifactType, uri, handle);

  if (isObject) {
    const sink = config.DataStore.getDataSink();
    const object = new Lazy<any>(() => handle.ReadObject<any>());
    const ast = new Lazy<YAMLNode>(() => handle.ReadYamlAst());

    if (IsOutputArtifactOrMapRequested(config, artifactType + ".yaml")) {
      const h = await sink.WriteData(`${++emitCtr}.yaml`, Stringify(object.Value), artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".yaml", uri + ".yaml", h);
    }
    if (IsOutputArtifactOrMapRequested(config, artifactType + ".norm.yaml")) {
      const h = await sink.WriteData(`${++emitCtr}.norm.yaml`, Stringify(Normalize(object.Value)), artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".norm.yaml", uri + ".norm.yaml", h);
    }
    if (IsOutputArtifactOrMapRequested(config, artifactType + ".json")) {
      const h = await sink.WriteData(`${++emitCtr}.json`, JSON.stringify(object.Value, null, 2), artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".json", uri + ".json", h);
    }
    if (IsOutputArtifactOrMapRequested(config, artifactType + ".norm.json")) {
      const h = await sink.WriteData(`${++emitCtr}.norm.json`, JSON.stringify(Normalize(object.Value), null, 2), artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await EmitArtifactInternal(config, artifactType + ".norm.json", uri + ".norm.json", h);
    }
  }
}

export async function EmitArtifacts(config: ConfigurationView, artifactTypeFilter: string /* what's set on the emitter */, uriResolver: (key: string) => string, scope: DataSource, isObject: boolean): Promise<void> {
  for (const key of await scope.Enum()) {
    const file = await scope.ReadStrict(key);
    const fileArtifact = file.GetArtifact();
    if (fileArtifact === artifactTypeFilter) {
      await EmitArtifact(config, uriResolver(file.Description), file, isObject);
    }
  }
}