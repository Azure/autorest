/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutoRestConfigurationManager, AutoRestConfiguration } from "../configuration/configuration";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly, KnownScopes } from "../data-store/data-store";
import { parse } from "../parsing/literateYaml";
import { mergeYamls, identitySourceMapping } from "../source-map/merging";
import { MultiPromiseUtility, MultiPromise } from "../approved-imports/multi-promise";
import { CancellationToken } from "../approved-imports/cancallation";
import { AutoRestPlugin } from "./plugin-server";
import { JsonPath } from "../approved-imports/jsonpath";
import { resolveRelativeNode } from "../parsing/yaml";
import { descendants, YAMLNodeWithPath } from "../approved-imports/yaml";
import { resolveUri } from "../approved-imports/uri";

export type DataPromise = MultiPromise<DataHandleRead>;

async function LoadUri(inputScope: DataStoreViewReadonly, inputFileUri: string): Promise<DataHandleRead> {
  const handle = await inputScope.Read(inputFileUri);
  if (handle === null) {
    throw new Error(`Input file '${inputFileUri}' not found.`);
  }
  return handle;
}

async function DeliteralizeYaml(literate: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const docScope = workingScope.CreateScope(`doc_tmp`);
  const hwRawDoc = await workingScope.Write(`doc.yaml`);
  const hRawDoc = await parse(literate, hwRawDoc, docScope);
  return hRawDoc;
}

async function LoadLiterateYaml(inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const pluginSwaggerInput = await LoadUri(inputScope, inputFileUri);
  const pluginDeliteralizeSwagger = DeliteralizeYaml(pluginSwaggerInput, workingScope);
  return pluginDeliteralizeSwagger;
}

async function EnsureCompleteDefinitionIsPresent(
  inputScope: DataStoreViewReadonly,
  workingScope: DataStoreView,
  visitedEntities: string[],
  externalFiles: { [uri: string]: DataHandleRead },
  sourceFileUri: string,
  currentFilePath?: string,
  entityType?: string,
  modelName?: string) {

  const references: YAMLNodeWithPath[] = [];
  const sourceDoc = externalFiles[sourceFileUri];
  if (currentFilePath == null) {
    currentFilePath = sourceFileUri;
  }

  var currentDoc = await externalFiles[currentFilePath].ReadYamlAst();
  if (entityType == null || modelName == null) {
    // external references
    for (const node of descendants(currentDoc)) {
      if (node.path[node.path.length - 1] === "$ref") {
        if (!(node.node.value as string).startsWith("#")) {
          references.push(node);
        }
      }
    }
  } else {
    // references within external file
    const model = resolveRelativeNode(currentDoc, currentDoc, [entityType, modelName]);
    for (const node of descendants(model, ["$", entityType, modelName])) {
      if (node.path[node.path.length - 1] === "$ref") {
        references.push(node);
      }
    }
  }

  const sourceDocObj = await sourceDoc.ReadObject<any>();
  const mappings = Array.from(identitySourceMapping(sourceDoc.key, await sourceDoc.ReadYamlAst()));
  const inputs: DataHandleRead[] = [sourceDoc];
  for (const { node, path } of references) {
    const refPath = node.value as string;
    const refPathParts = refPath.split("#").filter(s => s.length > 0);
    let fileUri: string | null = null;
    let entityPath = refPath;
    if (refPathParts.length === 2) {
      fileUri = refPathParts[0];
      entityPath = "#" + refPathParts[1];
      node.value = entityPath;
      fileUri = resolveUri(sourceFileUri, fileUri);
      if (!externalFiles[fileUri]) {
        const externalFile = await LoadLiterateYaml(inputScope, fileUri, workingScope.CreateScope(`ext_${Object.getOwnPropertyNames(externalFiles).length}`));
        if (externalFile === null) {
          throw new Error(`File ${fileUri} not found.`);
        }
        externalFiles[fileUri] = externalFile;
      }
    }

    const entityPathParts = entityPath.split("/").filter(s => s.length > 0);
    const referencedEntityType = entityPathParts[1];
    const referencedModelName = entityPathParts[2];

    sourceDocObj[referencedEntityType] = sourceDocObj[referencedEntityType] || {};
    if (visitedEntities.indexOf(entityPath) === -1) {
      visitedEntities.push(entityPath);
      if (sourceDocObj[referencedEntityType][referencedModelName] === undefined) {
        if (fileUri != null) {
          await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, fileUri, referencedEntityType, referencedModelName);
          const extObj = await externalFiles[fileUri].ReadObject<any>();
          inputs.push(externalFiles[fileUri]);
          sourceDocObj[referencedEntityType][referencedModelName] = extObj[referencedEntityType][referencedModelName];
        }
        else {
          await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, currentFilePath, referencedEntityType, referencedModelName);
          const currentObj = await externalFiles[currentFilePath].ReadObject<any>();
          inputs.push(externalFiles[currentFilePath]);
          sourceDocObj[referencedEntityType][referencedModelName] = currentObj[referencedEntityType][referencedModelName];
        }
      } else {
        // throw new Error(`Model definition '${entityPath}' already present`);
      }
    }
  }

  //ensure that all the models that are an allOf on the current model in the external doc are also included
  if (entityType != null && modelName != null) {
    var reference = "#/" + entityType + "/" + modelName;
    const dependentRefs: YAMLNodeWithPath[] = [];
    for (const node of descendants(currentDoc)) {
      const path = node.path;
      if (path.length > 3 && path[path.length - 3] === "allOf" && path[path.length - 1] === "$ref" && (node.node.value as string).indexOf(reference) !== -1) {
        dependentRefs.push(node);
      }
    }
    for (const dependentRef of dependentRefs) {
      //the JSON Path "definitions.ModelName.allOf[0].$ref" provides the name of the model that is an allOf on the current model
      const refs = dependentRef.path.slice(1);
      const defSec = refs[0];
      const model = refs[1];
      if (typeof defSec === "string" && typeof model === "string" && visitedEntities.indexOf(model) === -1) {
        //recursively check if the model is completely defined.
        await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, currentFilePath, defSec, model);
        const currentObj = await externalFiles[currentFilePath].ReadObject<any>();
        inputs.push(externalFiles[currentFilePath]);
        sourceDocObj[defSec][model] = currentObj[defSec][model];
      }
    }
  }

  // commit back
  const id = (await workingScope.Enum()).length;
  const target = await workingScope.Write(`revision_${id}.yaml`);
  externalFiles[sourceFileUri] = await target.WriteObject(sourceDocObj, mappings, inputs);
}

export async function LoadLiterateSwagger(inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const data = await LoadLiterateYaml(inputScope, inputFileUri, workingScope.CreateScope("yaml"));
  const externalFiles: { [uri: string]: DataHandleRead } = {};
  externalFiles[inputFileUri] = data;
  await EnsureCompleteDefinitionIsPresent(inputScope, workingScope.CreateScope("ref-resolving"), [], externalFiles, inputFileUri);
  return externalFiles[inputFileUri];
}

async function LoadLiterateSwaggers(inputScope: DataStoreViewReadonly, inputFileUris: string[], workingScope: DataStoreView): Promise<DataHandleRead[]> {
  const swaggerScope = workingScope.CreateScope("swagger");
  const rawSwaggers: DataHandleRead[] = [];
  let i = 0;
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwagger(inputScope, inputFileUri, swaggerScope.CreateScope("deliteralize_" + i));
    rawSwaggers.push(pluginInput);
    i++;
  }
  return rawSwaggers;
}

async function MergeYaml(inputSwaggers: DataHandleRead[], workingScope: DataStoreView): Promise<DataHandleRead> {
  const hwSwagger = await workingScope.Write("swagger.yaml");
  const hSwagger = await mergeYamls(inputSwaggers, hwSwagger);
  return hSwagger;
}

export async function RunPipeline(configurationUri: string, workingScope: DataStoreView): Promise<{ [name: string]: DataPromise }> {
  // load config
  const hConfig = await LoadLiterateYaml(
    workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => uri === configurationUri),
    configurationUri,
    workingScope.CreateScope("config"));
  const config = new AutoRestConfigurationManager(await hConfig.ReadObject<AutoRestConfiguration>(), configurationUri);

  // load Swaggers
  const swaggers = await LoadLiterateSwaggers(
    // TODO: unlock further URIs here
    workingScope.CreateScope(KnownScopes.Input).AsFileScopeReadThrough(uri => config.inputFileUris.indexOf(uri) !== -1),
    config.inputFileUris, workingScope.CreateScope("loader"));

  //
  const swagger = await MergeYaml(swaggers, workingScope.CreateScope("compose"));

  return {
    componentSwaggers: MultiPromiseUtility.list(swaggers),
    swagger: MultiPromiseUtility.single(swagger)
  };
}