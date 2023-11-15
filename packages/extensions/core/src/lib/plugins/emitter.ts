import { DataHandle, DataSource, QuickDataSource, createSandbox } from "@azure-tools/datastore";
import { resolveUri } from "@azure-tools/uri";
import { deepNormalize, Stringify } from "@azure-tools/yaml";
import { AutorestContext } from "../context";
import { Channel } from "../message";
import { PipelinePlugin } from "../pipeline/common";

const safeEval = createSandbox();

function isOutputArtifactOrMapRequested(config: AutorestContext, artifactType: string) {
  return config.IsOutputArtifactRequested(artifactType) || config.IsOutputArtifactRequested(artifactType + ".map");
}

async function emitArtifactInternal(
  context: AutorestContext,
  artifactType: string,
  uri: string,
  handle: DataHandle,
): Promise<void> {
  if (context.IsOutputArtifactRequested(artifactType)) {
    const content = await handle.readData(true);
    if (content !== "") {
      context.debug(`Emitting '${artifactType}' at ${uri}`);
      if (uri.startsWith("stdout://")) {
        context.log({
          level: "information",
          message: `Artifact '${uri.slice("stdout://".length)}' of type '${artifactType}' has been emitted.`,
          details: { type: artifactType, uri, content, plugin: "emitter" },
        });
      } else {
        context.GeneratedFile.Dispatch({ type: artifactType, uri, content });
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
  context: AutorestContext,
  uri: string,
  handle: DataHandle,
  isObject: boolean,
): Promise<void> {
  const artifactType = handle.artifactType;
  const result = emitArtifactInternal(context, artifactType, uri, handle);

  if (isObject) {
    const sink = context.DataStore.getDataSink();

    if (isOutputArtifactOrMapRequested(context, artifactType + ".yaml")) {
      const h = await sink.writeData(
        `${++emitCtr}.yaml`,
        Stringify(await handle.readObject<any>()),
        ["fix-me"],
        artifactType,
      );
      await emitArtifactInternal(context, artifactType + ".yaml", uri + ".yaml", h);
    }
    if (isOutputArtifactOrMapRequested(context, artifactType + ".norm.yaml")) {
      const h = await sink.writeData(
        `${++emitCtr}.norm.yaml`,
        Stringify(deepNormalize(await handle.readObject<any>())),
        ["fix-me"],
        artifactType,
      );
      await emitArtifactInternal(context, artifactType + ".norm.yaml", uri + ".norm.yaml", h);
    }
    if (isOutputArtifactOrMapRequested(context, artifactType + ".json")) {
      const h = await sink.writeData(
        `${++emitCtr}.json`,
        JSON.stringify(await handle.readObject<any>(), null, 2),
        ["fix-me"],
        artifactType,
      );
      await emitArtifactInternal(context, artifactType + ".json", uri + ".json", h);
    }
    if (isOutputArtifactOrMapRequested(context, artifactType + ".norm.json")) {
      const h = await sink.writeData(
        `${++emitCtr}.norm.json`,
        JSON.stringify(deepNormalize(await handle.readObject<any>()), null, 2),
        ["fix-me"],
        artifactType,
      );
      await emitArtifactInternal(context, artifactType + ".norm.json", uri + ".norm.json", h);
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
  for (const key of await scope.enum()) {
    const file = await scope.readStrict(key);
    const fileArtifact = file.artifactType;
    const ok = artifactTypeFilter
      ? typeof artifactTypeFilter === "string"
        ? fileArtifact === artifactTypeFilter // A string filter is a singular type
        : Array.isArray(artifactTypeFilter)
          ? artifactTypeFilter.includes(fileArtifact) // an array is any one of the types
          : true // if it's not a string or array, just emit it (no filter)
      : true; // if it's null, just emit it.

    if (ok) {
      all.push(emitArtifact(config, uriResolver(file.description), file, isObject));
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
        resolveUri(
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
