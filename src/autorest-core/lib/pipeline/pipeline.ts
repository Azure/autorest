/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSource, FastStringify, IFileSystem, JsonPath, QuickDataSource, safeEval, stringify } from '@microsoft.azure/datastore';
import { ConfigurationView, getExtension } from '../configuration';
import { Channel } from '../message';
import { OutstandingTaskAwaiter } from '../outstanding-task-awaiter';
import { PipelinePlugin } from './common';
import { createComponentModifierPlugin } from './component-modifier';
import { createCSharpReflectApiVersionPlugin } from './metadata-generation';
import { AutoRestExtension } from './plugin-endpoint';
import { createCommonmarkProcessorPlugin } from './plugins/commonmark';
import { createComposerPlugin } from './plugins/composer';
import { createSwaggerToOpenApi3Plugin } from './plugins/conversion';
import { createDeduplicatorPlugin } from './plugins/deduplicator';
import { createArtifactEmitterPlugin } from './plugins/emitter';
import { createExternalPlugin } from './plugins/external';
import { createHelpPlugin } from './plugins/help';
import { createIdentityPlugin } from './plugins/identity';
import { createMarkdownOverrideOpenApiLoaderPlugin, createMarkdownOverrideSwaggerLoaderPlugin, createOpenApiLoaderPlugin, createSwaggerLoaderPlugin } from './plugins/loaders';
import { createMultiApiMergerPlugin } from './plugins/merger';
import { subsetSchemaDeduplicatorPlugin } from './plugins/subset-schemas-deduplicator';
import { createEnumDeduplicator } from './plugins/enum-deduplication';
import { createImmediateTransformerPlugin, createTransformerPlugin } from './plugins/transformer';
import { createTreeShakerPlugin } from './plugins/tree-shaker';
import { createQuickCheckPlugin } from './plugins/quick-check';
import { createJsonToYamlPlugin, createYamlToJsonPlugin } from './plugins/yaml-and-json';
import { createOpenApiSchemaValidatorPlugin, createSwaggerSchemaValidatorPlugin } from './schema-validation';
import { createNewComposerPlugin } from './plugins/new-composer';
import { createComponentCleanerPlugin } from './plugins/component-cleaner';
import { createComponentKeyRenamerPlugin } from './plugins/component-key-renamer';
import { createApiVersionParameterHandlerPlugin } from './plugins/version-param-handler';
import { createProfileFilterPlugin } from './plugins/profile-filter';

interface PipelineNode {
  outputArtifact?: string;
  pluginName: string;
  configScope: JsonPath;
  inputs: Array<string>;
  skip: boolean;
  requireDrain?: boolean;
  dependencies: Array<PipelineNode>;
}

function buildPipeline(config: ConfigurationView): { pipeline: { [name: string]: PipelineNode }, configs: { [jsonPath: string]: ConfigurationView } } {
  const cfgPipeline = config.GetEntry(<any>'pipeline');
  const pipeline: { [name: string]: PipelineNode } = {};
  const configCache: { [jsonPath: string]: ConfigurationView } = {};

  // Resolves a pipeline stage name using the current stage's name and the relative name.
  // It considers the actually existing pipeline stages.
  // Example:
  // (csharp/cm/transform, commonmarker)
  //    --> csharp/cm/commonmarker       if such a stage exists
  //    --> csharp/commonmarker          if such a stage exists
  //    --> commonmarker                 if such a stage exists
  //    --> THROWS                       otherwise
  const resolvePipelineStageName = (currentStageName: string, relativeName: string) => {
    while (currentStageName !== '') {
      currentStageName = currentStageName.substring(0, currentStageName.length - 1);
      currentStageName = currentStageName.substring(0, currentStageName.lastIndexOf('/') + 1);

      if (cfgPipeline[currentStageName + relativeName]) {
        return currentStageName + relativeName;
      }
    }
    throw new Error(`Cannot resolve pipeline stage '${relativeName}'.`);
  };

  // One pipeline stage can generate multiple nodes in the pipeline graph
  // if the stage is associated with a configuration scope that has multiple entries.
  // Example: multiple generator calls
  const createNodesAndSuffixes: (stageName: string) => { name: string, suffixes: Array<string> } = stageName => {
    const cfg = cfgPipeline[stageName];
    if (!cfg) {
      throw new Error(`Cannot find pipeline stage '${stageName}'.`);
    }
    if (cfg.suffixes) {
      return { name: stageName, suffixes: cfg.suffixes };
    }

    // derive information about given pipeline stage
    const plugin = cfg.plugin || stageName.split('/').reverse()[0];
    const outputArtifact = cfg['output-artifact'];
    const scope = cfg.scope;
    const inputs: Array<string> = (!cfg.input ? [] : (Array.isArray(cfg.input) ? cfg.input : [cfg.input])).map((x: string) => resolvePipelineStageName(stageName, x));

    const suffixes: Array<string> = [];
    // adds nodes using at least suffix `suffix`, the input nodes called `inputs` using the context `config`
    // AFTER considering all the input nodes `inputNodes`
    // Example:
    // ("", [], cfg, [{ name: "a", suffixes: ["/0", "/1"] }])
    // --> ("/0", ["a/0"], cfg of "a/0", [])
    //     --> adds node `${stageName}/0`
    // --> ("/1", ["a/1"], cfg of "a/1", [])
    //     --> adds node `${stageName}/1`
    // Note: inherits the config of the LAST input node (affects for example `.../generate`)
    const addNodesAndSuffixes = (suffix: string, inputs: Array<string>, configScope: JsonPath, inputNodes: Array<{ name: string, suffixes: Array<string> }>) => {
      if (inputNodes.length === 0) {
        const config = configCache[stringify(configScope)];
        const configs = scope ? [...config.GetNestedConfiguration(scope)] : [config];
        for (let i = 0; i < configs.length; ++i) {
          const newSuffix = configs.length === 1 ? '' : '/' + i;
          suffixes.push(suffix + newSuffix);
          const path: JsonPath = configScope.slice();
          if (scope) { path.push(scope); }
          if (configs.length !== 1) { path.push(i); }
          configCache[stringify(path)] = configs[i];
          pipeline[stageName + suffix + newSuffix] = {
            pluginName: plugin,
            outputArtifact,
            configScope: path,
            inputs,
            dependencies: [],
            skip: false,
          };
        }
      } else {
        const inputSuffixesHead = inputNodes[0];
        const inputSuffixesTail = inputNodes.slice(1);
        for (const inputSuffix of inputSuffixesHead.suffixes) {
          const additionalInput = inputSuffixesHead.name + inputSuffix;
          addNodesAndSuffixes(
            suffix + inputSuffix,
            inputs.concat([additionalInput]),
            pipeline[additionalInput].configScope,
            inputSuffixesTail);
        }
      }
    };

    configCache[stringify([])] = config;
    addNodesAndSuffixes('', [], [], inputs.map(createNodesAndSuffixes));

    return { name: stageName, suffixes: cfg.suffixes = suffixes };
  };

  for (const pipelineStepName of Object.keys(cfgPipeline)) {
    createNodesAndSuffixes(pipelineStepName);
  }

  return {
    pipeline,
    configs: configCache
  };
}

function isDrainRequired(p: PipelineNode) {
  if (p.requireDrain && p.dependencies) {
    for (const each of p.dependencies) {
      if (!isDrainRequired(each)) {
        return false;
      }
    }
    return true;
  }
  return false;
}

export async function runPipeline(configView: ConfigurationView, fileSystem: IFileSystem): Promise<void> {
  // built-in plugins
  const plugins: { [name: string]: PipelinePlugin } = {
    'help': createHelpPlugin(),
    'identity': createIdentityPlugin(),
    'loader-swagger': createSwaggerLoaderPlugin(),
    'loader-openapi': createOpenApiLoaderPlugin(),
    'md-override-loader-swagger': createMarkdownOverrideSwaggerLoaderPlugin(),
    'md-override-loader-openapi': createMarkdownOverrideOpenApiLoaderPlugin(),
    'transform': createTransformerPlugin(),
    'transform-immediate': createImmediateTransformerPlugin(),
    // 'compose': createComposerPlugin(),
    'compose': createNewComposerPlugin(),
    'schema-validator-openapi': createOpenApiSchemaValidatorPlugin(),
    'schema-validator-swagger': createSwaggerSchemaValidatorPlugin(),
    // TODO: replace with OAV again
    'semantic-validator': createIdentityPlugin(),
    'openapi-document-converter': createSwaggerToOpenApi3Plugin(),
    'component-modifiers': createComponentModifierPlugin(),
    'yaml2jsonx': createYamlToJsonPlugin(),
    'jsonx2yaml': createJsonToYamlPlugin(),
    'reflect-api-versions-cs': createCSharpReflectApiVersionPlugin(),
    'commonmarker': createCommonmarkProcessorPlugin(),
    'profile-definition-emitter': createArtifactEmitterPlugin(),
    'emitter': createArtifactEmitterPlugin(),
    'pipeline-emitter': createArtifactEmitterPlugin(async () => new QuickDataSource([await configView.DataStore.getDataSink().WriteObject('pipeline', pipeline.pipeline, ['fix-me-3'], 'pipeline')])),
    'configuration-emitter': createArtifactEmitterPlugin(async () => new QuickDataSource([await configView.DataStore.getDataSink().WriteObject('configuration', configView.Raw, ['fix-me-4'], 'configuration')])),
    'tree-shaker': createTreeShakerPlugin(),
    'enum-deduplicator': createEnumDeduplicator(),
    'quick-check': createQuickCheckPlugin(),
    'model-deduplicator': createDeduplicatorPlugin(),
    'subset-reducer': subsetSchemaDeduplicatorPlugin(),
    'multi-api-merger': createMultiApiMergerPlugin(),
    'component-cleaner': createComponentCleanerPlugin(),
    'component-key-renamer': createComponentKeyRenamerPlugin(),
    'api-version-parameter-handler': createApiVersionParameterHandlerPlugin(),
    'profile-filter': createProfileFilterPlugin()
  };




  // dynamically loaded, auto-discovered plugins
  const __extensionExtension: { [pluginName: string]: AutoRestExtension } = {};
  for (const useExtensionQualifiedName of configView.GetEntry(<any>'used-extension') || []) {
    const extension = await getExtension(useExtensionQualifiedName);
    for (const plugin of await extension.GetPluginNames(configView.CancellationToken)) {
      if (!plugins[plugin]) {
        plugins[plugin] = createExternalPlugin(extension, plugin);
        __extensionExtension[plugin] = extension;
      }
    }
  }

  // __status scope
  const startTime = Date.now();
  (<any>configView.Raw).__status = new Proxy<any>({}, {
    get(_, key) {
      if (key === '__info') { return false; }
      const expr = Buffer.from(key.toString(), 'base64').toString('ascii');
      try {
        return JSON.stringify(safeEval(expr, {
          pipeline: pipeline.pipeline,
          external: __extensionExtension,
          tasks,
          startTime,
          blame: (uri: string, position: any /*TODO: cleanup, nail type*/) => {
            return configView.DataStore.Blame(uri, position);
          }

        }), (k, v) => k === 'dependencies' ? undefined : v, 2);
      } catch (e) {
        return `${e}`;
      }
    }
  });

  // TODO: think about adding "number of files in scope" kind of validation in between pipeline steps

  const fsInput = configView.DataStore.GetReadThroughScope(fileSystem);
  const pipeline = buildPipeline(configView);

  const ScheduleNode: (nodeName: string) => Promise<DataSource> =
    async (nodeName) => {
      const node = pipeline.pipeline[nodeName];

      if (!node) {
        throw new Error(`Cannot find pipeline node ${nodeName}.`);
      }

      // get input
      const inputScopes: Array<DataSource> = await Promise.all(node.inputs.map(getTask));

      let inputScope: DataSource;
      if (inputScopes.length === 0) {
        inputScope = fsInput;
      } else {
        let skip: boolean | undefined;

        const handles: Array<DataHandle> = [];
        for (const pscope of inputScopes) {
          const scope = await pscope;
          if (pscope.skip !== undefined) {
            skip = skip === undefined ? pscope.skip : skip && pscope.skip;
          }
          for (const handle of await scope.Enum()) {
            handles.push(await scope.ReadStrict(handle));
          }
        }
        inputScope = new QuickDataSource(handles, skip);
      }

      const config = pipeline.configs[stringify(node.configScope)];
      const pluginName = node.pluginName;
      const plugin = plugins[pluginName];



      if (!plugin) {
        throw new Error(`Plugin '${pluginName}' not found.`);
      }

      if (inputScope.skip) {
        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - SKIPPING` });
        return inputScope;
      }
      try {
        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - START inputs = ${(await inputScope.Enum()).length}` });

        const scopeResult = await plugin(config, inputScope, config.DataStore.getDataSink(node.outputArtifact));

        config.Message({ Channel: Channel.Debug, Text: `${nodeName} - END` });
        return scopeResult;
      } catch (e) {
        console.error(`${__filename} - FAILURE ${JSON.stringify(e)}`);
        throw e;

        config.Message({ Channel: Channel.Fatal, Text: `${nodeName} - FAILED` });
        config.Message({ Channel: Channel.Fatal, Text: `${e}` });
        throw e;
      }
    };

  // schedule pipeline
  const tasks: { [name: string]: Promise<DataSource> } = {};
  const getTask = (name: string) => name in tasks ?
    tasks[name] :
    tasks[name] = ScheduleNode(name);

  // execute pipeline
  const barrier = new OutstandingTaskAwaiter();
  const barrierRobust = new OutstandingTaskAwaiter();

  for (const name of Object.keys(pipeline.pipeline)) {
    const node = pipeline.pipeline[name];
    node.dependencies = new Array<PipelineNode>();

    // find nodes that list this as a antecedent
    for (const k of Object.keys(pipeline.pipeline)) {
      // does anyone take this as an input?
      const candidate = pipeline.pipeline[k];
      if (candidate.inputs.indexOf(name)) {
        node.dependencies.push(candidate);
      }
    }
  }
  for (const name of Object.keys(pipeline.pipeline)) {
    // walk thru the list of nodes, and if a given node is skipable beacuse nobody is consuming it
    // we'll mark it skip: true
    const node = pipeline.pipeline[name];
    if (isDrainRequired(node)) {
      console.log(`Marking ${name} skippable`);
      node.skip = true;
    }
  }
  /*
  we should be able to look at all the tasks,
  recursively find out who the children are of a given task
  and then find out if they all have requireDrain === false
  and f
  for (const name of Object.keys(pipeline.pipeline)) {
    const node = pipeline.pipeline[name];
    if (node.requireDrain === true) {
      for (const k of Object.keys(pipeline.pipeline) ) {
        // does anyone take this as an input?
        const candidate= pipeline.pipeline[k];
        if( candidate.inputs.indexOf(name)  )
      }
    }
  }
*/
  for (const name of Object.keys(pipeline.pipeline)) {

    const task = getTask(name);

    const taskx: { _state: 'running' | 'failed' | 'complete'; _result(): Array<DataHandle>; _finishedAt: number } = task as any;
    taskx._state = 'running';
    task.then(async x => {
      const res = await Promise.all((await x.Enum()).map(key => x.ReadStrict(key)));
      taskx._result = () => res;
      taskx._state = 'complete';
      taskx._finishedAt = Date.now();
    }).catch(() => taskx._state = 'failed');
    barrier.Await(task);
    barrierRobust.Await(task.catch(() => { }));
  }

  try {
    await barrier.Wait();
  } catch (e) {
    // wait for outstanding nodes
    try {
      await barrierRobust.Wait();
    } catch {
      // wait for others to fail or whatever...
    }
    throw e;
  }
}
