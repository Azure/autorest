
import { DataHandle, DataSource, Lazy, Normalize, QuickDataSource, safeEval, Stringify, YAMLNode } from '@microsoft.azure/datastore';
import { ResolveUri } from '@microsoft.azure/uri';
import { Artifact } from '../../../main';
import { ConfigurationView } from '../../configuration';
import { Channel } from '../../message';
import { IdentitySourceMapping } from '../../source-map/merging';
import { PipelinePlugin } from '../common';

function isOutputArtifactOrMapRequested(config: ConfigurationView, artifactType: string) {
  return config.IsOutputArtifactRequested(artifactType) || config.IsOutputArtifactRequested(artifactType + '.map');
}

async function emitArtifactInternal(config: ConfigurationView, artifactType: string, uri: string, handle: DataHandle): Promise<void> {
  config.Message({ Channel: Channel.Debug, Text: `Emitting '${artifactType}' at ${uri}` });
  const emitArtifact = (artifact: Artifact): void => {
    if (artifact.uri.startsWith('stdout://')) {
      config.Message({
        Channel: Channel.Information,
        Details: artifact,
        Text: `Artifact '${artifact.uri.slice('stdout://'.length)}' of type '${artifact.type}' has been emitted.`,
        Plugin: 'emitter'
      });
    } else {
      config.GeneratedFile.Dispatch(artifact);
    }
  };
  if (config.IsOutputArtifactRequested(artifactType)) {
    const content = handle.ReadData();
    if (content !== '') {
      emitArtifact({
        type: artifactType,
        uri,
        content
      });
    }
  }
  if (config.IsOutputArtifactRequested(artifactType + '.map')) {
    emitArtifact({
      type: artifactType + '.map',
      uri: uri + '.map',
      content: JSON.stringify(handle.ReadMetadata().inputSourceMap.Value, null, 2)
    });
  }
}
let emitCtr = 0;
async function emitArtifact(config: ConfigurationView, uri: string, handle: DataHandle, isObject: boolean): Promise<void> {
  const artifactType = handle.GetArtifact();
  await emitArtifactInternal(config, artifactType, uri, handle);

  if (isObject) {
    const sink = config.DataStore.getDataSink();
    const object = new Lazy<any>(() => handle.ReadObject<any>());
    const ast = new Lazy<YAMLNode>(() => handle.ReadYamlAst());

    if (isOutputArtifactOrMapRequested(config, artifactType + '.yaml')) {
      const h = await sink.WriteData(`${++emitCtr}.yaml`, Stringify(object.Value), ['fix-me'], artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await emitArtifactInternal(config, artifactType + '.yaml', uri + '.yaml', h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + '.norm.yaml')) {
      const h = await sink.WriteData(`${++emitCtr}.norm.yaml`, Stringify(Normalize(object.Value)), ['fix-me'], artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await emitArtifactInternal(config, artifactType + '.norm.yaml', uri + '.norm.yaml', h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + '.json')) {
      const h = await sink.WriteData(`${++emitCtr}.json`, JSON.stringify(object.Value, null, 2), ['fix-me'], artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await emitArtifactInternal(config, artifactType + '.json', uri + '.json', h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + '.norm.json')) {
      const h = await sink.WriteData(`${++emitCtr}.norm.json`, JSON.stringify(Normalize(object.Value), null, 2), ['fix-me'], artifactType, IdentitySourceMapping(handle.key, ast.Value), [handle]);
      await emitArtifactInternal(config, artifactType + '.norm.json', uri + '.norm.json', h);
    }
  }
}

export async function emitArtifacts(config: ConfigurationView, artifactTypeFilter: string | Array<string> | null /* what's set on the emitter */, uriResolver: (key: string) => string, scope: DataSource, isObject: boolean): Promise<void> {
  for (const key of await scope.Enum()) {
    const file = await scope.ReadStrict(key);
    const fileArtifact = file.GetArtifact();
    const ok = artifactTypeFilter ?
      typeof artifactTypeFilter === 'string' ? fileArtifact === artifactTypeFilter : // A string filter is a singular type
        Array.isArray(artifactTypeFilter) ? artifactTypeFilter.includes(fileArtifact) : // an array is any one of the types
          true : // if it's not a string or array, just emit it (no filter)
      true; // if it's null, just emit it.

    if (ok) {
      await emitArtifact(config, uriResolver(file.Description), file, isObject);
    }
  }
}

/* @internal */
export function createArtifactEmitterPlugin(inputOverride?: () => Promise<DataSource>): PipelinePlugin {
  return async (config, input) => {
    if (inputOverride) {
      input = await inputOverride();
    }

    // clear output-folder if requested
    if (config.GetEntry(<any>'clear-output-folder')) {
      config.ClearFolder.Dispatch(config.OutputFolderUri);
    }

    await emitArtifacts(
      config,
      config.GetEntry(<any>'input-artifact') || null,
      key => ResolveUri(
        config.OutputFolderUri,
        safeEval<string>(config.GetEntry(<any>'output-uri-expr') || '$key', { $key: key, $config: config.Raw })),
      input,
      config.GetEntry(<any>'is-object'));
    return new QuickDataSource([]);
  };
}
