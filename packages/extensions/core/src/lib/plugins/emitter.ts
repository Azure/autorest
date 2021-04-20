import { DataHandle, DataSource, Normalize, QuickDataSource, createSandbox, Stringify } from "@azure-tools/datastore";
import { ResolveUri } from "@azure-tools/uri";
import { AutorestContext } from "../context";
import { Channel } from "../message";
import { PipelinePlugin } from "../pipeline/common";

const safeEval = createSandbox();

function isOutputArtifactOrMapRequested(config: AutorestContext, artifactType: string) {
  return config.IsOutputArtifactRequested(artifactType) || config.IsOutputArtifactRequested(artifactType + ".map");
}

async function emitArtifactInternal(
  config: AutorestContext,
  artifactType: string,
  uri: string,
  handle: DataHandle,
): Promise<void> {
  if (config.IsOutputArtifactRequested(artifactType)) {
    const content = await handle.ReadData(true);
    if (content !== "") {
      config.Message({ Channel: Channel.Debug, Text: `Emitting '${artifactType}' at ${uri}` });
      if (uri.startsWith("stdout://")) {
        config.Message({
          Channel: Channel.Information,
          Details: { type: artifactType, uri, content },
          Text: `Artifact '${uri.slice("stdout://".length)}' of type '${artifactType}' has been emitted.`,
          Plugin: "emitter",
        });
      } else {
        config.GeneratedFile.Dispatch({ type: artifactType, uri, content });
      }
      /* DISABLING SOURCE MAP SUPPORT
          if (config.IsOutputArtifactRequested(artifactType + '.map')) {
            emitArtifact({
              type: artifactType + '.map',
              uri: uri + '.map',
              content: JSON.stringify(await handle.metadata.inputSourceMap, null, 2)
            });
          }
          */
    }
  }
}

let emitCtr = 0;
async function emitArtifact(
  config: AutorestContext,
  uri: string,
  handle: DataHandle,
  isObject: boolean,
): Promise<void> {
  const artifactType = handle.artifactType;
  const result = emitArtifactInternal(config, artifactType, uri, handle);

  if (isObject) {
    const sink = config.DataStore.getDataSink();

    if (isOutputArtifactOrMapRequested(config, artifactType + ".yaml")) {
      const h = await sink.WriteData(
        `${++emitCtr}.yaml`,
        Stringify(await handle.ReadObject<any>()),
        ["fix-me"],
        artifactType,
        [] /*disabled source maps long ago */,
        [handle],
      );
      await emitArtifactInternal(config, artifactType + ".yaml", uri + ".yaml", h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + ".norm.yaml")) {
      const h = await sink.WriteData(
        `${++emitCtr}.norm.yaml`,
        Stringify(Normalize(await handle.ReadObject<any>())),
        ["fix-me"],
        artifactType,
        [] /*disabled source maps long ago */,
        [handle],
      );
      await emitArtifactInternal(config, artifactType + ".norm.yaml", uri + ".norm.yaml", h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + ".json")) {
      const h = await sink.WriteData(
        `${++emitCtr}.json`,
        JSON.stringify(await handle.ReadObject<any>(), null, 2),
        ["fix-me"],
        artifactType,
        [] /*disabled source maps long ago */,
        [handle],
      );
      await emitArtifactInternal(config, artifactType + ".json", uri + ".json", h);
    }
    if (isOutputArtifactOrMapRequested(config, artifactType + ".norm.json")) {
      const h = await sink.WriteData(
        `${++emitCtr}.norm.json`,
        JSON.stringify(Normalize(await handle.ReadObject<any>()), null, 2),
        ["fix-me"],
        artifactType,
        [] /*disabled source maps long ago */,
        [handle],
      );
      await emitArtifactInternal(config, artifactType + ".norm.json", uri + ".norm.json", h);
    }
  }
  return result;
}

export async function emitArtifacts(
  config: AutorestContext,
  artifactTypeFilter: string | Array<string> | null /* what's set on the emitter */,
  uriResolver: (key: string) => string,
  scope: DataSource,
  isObject: boolean,
): Promise<void> {
  const all = new Array<Promise<void>>();
  for (const key of await scope.Enum()) {
    const file = await scope.ReadStrict(key);
    const fileArtifact = file.artifactType;
    const ok = artifactTypeFilter
      ? typeof artifactTypeFilter === "string"
        ? fileArtifact === artifactTypeFilter // A string filter is a singular type
        : Array.isArray(artifactTypeFilter)
        ? artifactTypeFilter.includes(fileArtifact) // an array is any one of the types
        : true // if it's not a string or array, just emit it (no filter)
      : true; // if it's null, just emit it.

    if (ok) {
      all.push(emitArtifact(config, uriResolver(file.Description), file, isObject));
    }
  }
  await Promise.all(all);
}

/* @internal */
export function createArtifactEmitterPlugin(
  inputOverride?: (context: AutorestContext) => Promise<DataSource>,
): PipelinePlugin {
  return async (context, input) => {
    if (inputOverride) {
      input = await inputOverride(context);
    }

    // clear output-folder if requested
    if (context.GetEntry("clear-output-folder")) {
      context.ClearFolder.Dispatch(context.config.outputFolderUri);
    }

    await emitArtifacts(
      context,
      context.GetEntry("input-artifact") || null,
      (key) =>
        ResolveUri(
          context.config.outputFolderUri,
          safeEval<string>(context.GetEntry("output-uri-expr") || "$key", {
            $key: key,
            $config: context.config.raw,
          }),
        ),
      input,
      context.GetEntry("is-object"),
    );
    return new QuickDataSource([]);
  };
}
