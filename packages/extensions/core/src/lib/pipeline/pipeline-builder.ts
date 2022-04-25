import { arrayify } from "@autorest/common";
import { JsonPath } from "@azure-tools/datastore";
import { JsonPointerTokens, serializeJsonPointer } from "@azure-tools/json";
import { AutorestContext } from "../context";
import { PipelinePluginDefinition } from "./plugin-loader";

export interface PipelineNode {
  outputArtifact?: string;
  pluginName: string;
  configScope: JsonPath;
  inputs: string[];
  skip: boolean;
  requireDrain?: boolean;
  dependencies: Array<PipelineNode>;
}

export interface Pipeline {
  pipeline: { [name: string]: PipelineNode };
  configs: { [jsonPath: string]: AutorestContext };
}

/**
 * Build the pipeline for the given Autorest Context
 */
export function buildPipeline(
  context: AutorestContext,
  plugins: { [key: string]: PipelinePluginDefinition },
): Pipeline {
  const pipelineConfig = context.GetEntry("pipeline");
  const pipeline: { [name: string]: PipelineNode } = {};
  const configCache: { [jsonPath: string]: AutorestContext } = {};

  // Resolves a pipeline stage name using the current stage's name and the relative name.
  // It considers the actually existing pipeline stages.
  // Example:
  // (csharp/cm/transform, commonmarker)
  //    --> csharp/cm/commonmarker       if such a stage exists
  //    --> csharp/commonmarker          if such a stage exists
  //    --> commonmarker                 if such a stage exists
  //    --> THROWS                       otherwise
  const resolvePipelineStageName = (currentStageName: string, relativeName: string) => {
    let stageName = currentStageName;
    const stageTried: string[] = [];
    while (stageName !== "") {
      stageName = stageName.substring(0, stageName.length - 1);
      stageName = stageName.substring(0, stageName.lastIndexOf("/") + 1);

      const resolvedStageName = stageName + relativeName;
      stageTried.push(resolvedStageName);
      if (pipelineConfig[resolvedStageName]) {
        return resolvedStageName;
      }
    }
    const search = stageTried.map((x) => ` - ${x}`).join("\n");
    throw new Error(
      `Cannot resolve pipeline stage '${relativeName}' for stage '${currentStageName}'. Looked for pipeline stages:\n${search}\n`,
    );
  };

  // One pipeline stage can generate multiple nodes in the pipeline graph
  // if the stage is associated with a configuration scope that has multiple entries.
  // Example: multiple generator calls
  const createNodesAndSuffixes = (stageName: string): { name: string; suffixes: string[] } => {
    const cfg = pipelineConfig[stageName];
    if (!cfg) {
      throw new Error(`Cannot find pipeline stage '${stageName}'.`);
    }
    if (cfg.suffixes) {
      return { name: stageName, suffixes: cfg.suffixes };
    }

    // derive information about given pipeline stage
    const pluginName = cfg.plugin || stageName.split("/").reverse()[0];
    const plugin = plugins[pluginName];
    const outputArtifact = cfg["output-artifact"];
    const scope = cfg.scope ?? `pipeline.${stageName}`;

    const inputs: string[] = cfg.input ? arrayify(cfg.input).map((x) => resolvePipelineStageName(stageName, x)) : [];

    const suffixes: string[] = [];

    // adds nodes using at least suffix `suffix`, the input nodes called `inputs` using the context `config`
    // AFTER considering all the input nodes `inputNodes`
    // Example:
    // ("", [], cfg, [{ name: "a", suffixes: ["/0", "/1"] }])
    // --> ("/0", ["a/0"], cfg of "a/0", [])
    //     --> adds node `${stageName}/0`
    // --> ("/1", ["a/1"], cfg of "a/1", [])
    //     --> adds node `${stageName}/1`
    // Note: inherits the config of the LAST input node (affects for example `.../generate`)
    const addNodesAndSuffixes = (
      suffix: string,
      inputs: string[],
      configScope: JsonPointerTokens,
      inputNodes: Array<{ name: string; suffixes: string[] }>,
    ) => {
      if (inputNodes.length === 0) {
        const config = configCache[serializeJsonPointer(configScope)];
        const configs = scope
          ? [...config.getNestedConfiguration(scope, plugin)]
          : [config.getContextForPlugin(plugin)];

        for (let i = 0; i < configs.length; ++i) {
          const newSuffix = configs.length === 1 ? "" : "/" + i;
          suffixes.push(suffix + newSuffix);
          const path: JsonPointerTokens = configScope.slice();
          if (scope) {
            path.push(scope);
          }
          if (configs.length !== 1) {
            path.push(i);
          }
          configCache[serializeJsonPointer(path)] = configs[i];
          pipeline[stageName + suffix + newSuffix] = {
            pluginName: pluginName,
            outputArtifact,
            configScope: path,
            inputs,
            dependencies: [],
            skip: false,
          };
        }
      } else {
        const [inputSuffixesHead, ...inputSuffixesTail] = inputNodes;
        for (const inputSuffix of inputSuffixesHead.suffixes) {
          const additionalInput = inputSuffixesHead.name + inputSuffix;
          addNodesAndSuffixes(
            suffix + inputSuffix,
            [...inputs, additionalInput],
            pipeline[additionalInput].configScope,
            inputSuffixesTail,
          );
        }
      }
    };

    configCache[serializeJsonPointer([])] = context;
    addNodesAndSuffixes("", [], [], inputs.map(createNodesAndSuffixes));

    return { name: stageName, suffixes: (cfg.suffixes = suffixes) };
  };

  for (const pipelineStepName of Object.keys(pipelineConfig)) {
    createNodesAndSuffixes(pipelineStepName);
  }

  return {
    pipeline,
    configs: configCache,
  };
}
