import { CommonmarkSubHeadings, ParseCommonmark } from '../parsing/literate';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Channel, SourceLocation } from '../message';
import { OperationAbortedException } from "../exception";
import { safeEval } from "../ref/safe-eval";
import { ConfigurationView } from "../autorest-core";
import { DataStoreView, DataHandleRead, DataStoreViewReadonly } from "../data-store/data-store";
import { IsPrefix, JsonPath, JsonPathComponent, stringify } from "../ref/jsonpath";
import { ResolvePath, ResolveRelativeNode } from "../parsing/yaml";
import { Clone, CloneAst, Descendants, StringifyAst, ToAst, YAMLNodeWithPath } from '../ref/yaml';
import { ResolveUri } from "../ref/uri";
import { From } from "../ref/linq";
import { Mappings, Mapping } from "../ref/source-map";
import { CreateAssignmentMapping } from "../source-map/source-map";
import { Parse as ParseLiterateYaml } from "../parsing/literate-yaml";
import { MergeYamls, IdentitySourceMapping } from "../source-map/merging";

let ctr = 0;

async function EnsureCompleteDefinitionIsPresent(
  config: ConfigurationView,
  inputScope: DataStoreViewReadonly,
  workingScope: DataStoreView,
  visitedEntities: string[],
  externalFiles: { [uri: string]: DataHandleRead },
  sourceFileUri: string,
  sourceDocObj: any,
  sourceDocMappings: Mapping[],
  currentFileUri?: string,
  entityType?: string,
  modelName?: string) {

  const ensureExtFilePresent: (fileUri: string, config: ConfigurationView, complaintLocation: SourceLocation) => Promise<void> = async (fileUri: string, config: ConfigurationView, complaintLocation: SourceLocation) => {
    if (!externalFiles[fileUri]) {
      const file = await inputScope.Read(fileUri);
      if (file === null) {
        config.Message({
          Channel: Channel.Error,
          Source: [complaintLocation],
          Text: `Referenced file '${fileUri}' not found`
        })
        throw new OperationAbortedException();
      }
      const externalFile = await ParseLiterateYaml(config, file, workingScope.CreateScope(`ext_${Object.getOwnPropertyNames(externalFiles).length}`));
      externalFiles[fileUri] = externalFile;
    }
  };

  const sourceDoc = externalFiles[sourceFileUri];
  if (currentFileUri == null) {
    currentFileUri = sourceFileUri;
  }

  const references: YAMLNodeWithPath[] = [];
  var currentDoc = externalFiles[currentFileUri].ReadYamlAst();
  if (entityType == null || modelName == null) {
    // external references
    for (const node of Descendants(currentDoc)) {
      if (node.path[node.path.length - 1] === "$ref") {
        if (!(node.node.value as string).startsWith("#")) {
          references.push(node);
        }
      }
    }
  } else {
    // references within external file
    const model = ResolveRelativeNode(currentDoc, currentDoc, [entityType, modelName]);
    for (const node of Descendants(model, [entityType, modelName])) {
      if (node.path[node.path.length - 1] === "$ref") {
        references.push(node);
      }
    }
  }

  const inputs: DataHandleRead[] = [sourceDoc];
  for (const { node, path } of references) {

    const complaintLocation: SourceLocation = { document: currentFileUri, Position: <any>{ path: path } };

    const refPath = node.value as string;
    if (refPath.indexOf("#") === -1) {
      // inject entire file right here
      const fileUri = ResolveUri(currentFileUri, refPath);
      await ensureExtFilePresent(fileUri, config, complaintLocation);
      // console.error("Resolving ", fileUri);
      const targetPath = path.slice(0, path.length - 1);
      const extObj = externalFiles[fileUri].ReadObject();
      safeEval(`${stringify(targetPath)} = extObj`, { $: sourceDocObj, extObj: extObj });
      //// performance hit:
      // inputs.push(externalFiles[fileUri]);
      // sourceDocMappings.push(...CreateAssignmentMapping(
      //   extObj, externalFiles[fileUri].key,
      //   [], targetPath,
      //   `resolving '${refPath}' in '${currentFileUri}'`));

      // remove $ref
      sourceDocMappings = sourceDocMappings.filter(m => !IsPrefix(path, (m.generated as any).path));
      continue;
    }
    const refPathParts = refPath.split("#").filter(s => s.length > 0);
    let fileUri: string | null = null;
    let entityPath = refPath;
    if (refPathParts.length === 2) {
      fileUri = refPathParts[0];
      entityPath = "#" + refPathParts[1];
      fileUri = ResolveUri(currentFileUri, fileUri);
      await ensureExtFilePresent(fileUri, config, complaintLocation);
    }

    const entityPathParts = entityPath.split("/").filter(s => s.length > 0);
    const referencedEntityType = entityPathParts[1];
    const referencedModelName = entityPathParts[2];

    sourceDocObj[referencedEntityType] = sourceDocObj[referencedEntityType] || {};
    if (visitedEntities.indexOf(entityPath) === -1) {
      visitedEntities.push(entityPath);
      if (sourceDocObj[referencedEntityType][referencedModelName] === undefined) {
        if (fileUri != null) {
          sourceDocMappings = await EnsureCompleteDefinitionIsPresent(config, inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, fileUri, referencedEntityType, referencedModelName);
          const extObj = externalFiles[fileUri].ReadObject<any>();
          inputs.push(externalFiles[fileUri]);
          sourceDocObj[referencedEntityType][referencedModelName] = extObj[referencedEntityType][referencedModelName];
          sourceDocMappings.push(...CreateAssignmentMapping(
            extObj[referencedEntityType][referencedModelName], externalFiles[fileUri].key,
            [referencedEntityType, referencedModelName], [referencedEntityType, referencedModelName],
            `resolving '${refPath}' in '${currentFileUri}'`));
        }
        else {
          sourceDocMappings = await EnsureCompleteDefinitionIsPresent(config, inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, currentFileUri, referencedEntityType, referencedModelName);
          const currentObj = externalFiles[currentFileUri].ReadObject<any>();
          inputs.push(externalFiles[currentFileUri]);
          sourceDocObj[referencedEntityType][referencedModelName] = currentObj[referencedEntityType][referencedModelName];
          sourceDocMappings.push(...CreateAssignmentMapping(
            currentObj[referencedEntityType][referencedModelName], externalFiles[currentFileUri].key,
            [referencedEntityType, referencedModelName], [referencedEntityType, referencedModelName],
            `resolving '${refPath}' in '${currentFileUri}'`));
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
    for (const node of Descendants(currentDoc)) {
      const path = node.path;
      if (path.length > 3 && path[path.length - 3] === "allOf" && path[path.length - 1] === "$ref" && (node.node.value as string).indexOf(reference) !== -1) {
        dependentRefs.push(node);
      }
    }
    for (const dependentRef of dependentRefs) {
      //the JSON Path "definitions.ModelName.allOf[0].$ref" provides the name of the model that is an allOf on the current model
      const refs = dependentRef.path;
      const defSec = refs[0];
      const model = refs[1];
      if (typeof defSec === "string" && typeof model === "string" && visitedEntities.indexOf(model) === -1) {
        //recursively check if the model is completely defined.
        sourceDocMappings = await EnsureCompleteDefinitionIsPresent(config, inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, currentFileUri, defSec, model);
        const currentObj = externalFiles[currentFileUri].ReadObject<any>();
        inputs.push(externalFiles[currentFileUri]);
        sourceDocObj[defSec][model] = currentObj[defSec][model];
        sourceDocMappings.push(...CreateAssignmentMapping(
          currentObj[defSec][model], externalFiles[currentFileUri].key,
          [defSec, model], [defSec, model],
          `resolving '${stringify(dependentRef.path)}' (has allOf on '${reference}') in '${currentFileUri}'`));
      }
    }
  }

  // commit back
  const target = await workingScope.Write(`revision_${++ctr}.yaml`);
  externalFiles[sourceFileUri] = await target.WriteObject(sourceDocObj, sourceDocMappings, [...Object.getOwnPropertyNames(externalFiles).map(x => externalFiles[x]), sourceDoc] /* inputs */ /*TODO: fix*/);
  return sourceDocMappings;
}

async function StripExternalReferences(swagger: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const result = await workingScope.Write("result.yaml");
  const ast = CloneAst(swagger.ReadYamlAst());
  const mapping = IdentitySourceMapping(swagger.key, ast);
  for (const node of Descendants(ast)) {
    if (node.path[node.path.length - 1] === "$ref") {
      const parts = (node.node.value as string).split("#");
      if (parts.length === 2) {
        node.node.value = "#" + (node.node.value as string).split("#")[1];
      }
    }
  }
  return await result.WriteData(StringifyAst(ast), mapping, [swagger]);
}

export async function LoadLiterateSwaggerOverride(config: ConfigurationView, inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const commonmark = await inputScope.ReadStrict(inputFileUri);
  const commonmarkNode = await ParseCommonmark(commonmark.ReadData());

  const directives: any[] = [];
  const mappings: Mappings = [];
  const state = CommonmarkSubHeadings(commonmarkNode).map(x => ...); // make this inline DFS with current JSON query and such

  const resultHandle = await workingScope.Write("override-directives");
  return resultHandle.WriteObject({ directive: directives }, mappings, [commonmark]);
}

export async function LoadLiterateSwagger(config: ConfigurationView, inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const data = await ParseLiterateYaml(config, await inputScope.ReadStrict(inputFileUri), workingScope.CreateScope("yaml"));
  const externalFiles: { [uri: string]: DataHandleRead } = {};
  externalFiles[inputFileUri] = data;
  //WriteString(`file:///C:/output/${(<any>workingScope).name}_before.yaml`, await externalFiles[inputFileUri].ReadData());
  await EnsureCompleteDefinitionIsPresent(config,
    inputScope,
    workingScope.CreateScope("ref-resolving"),
    [],
    externalFiles,
    inputFileUri,
    data.ReadObject<any>(),
    IdentitySourceMapping(data.key, data.ReadYamlAst()));
  const result = await StripExternalReferences(externalFiles[inputFileUri], workingScope.CreateScope("strip-ext-references"));
  //WriteString(`file:///C:/output/${(<any>workingScope).name}_after.yaml`, await result.ReadData());
  return result;
}

export async function LoadLiterateSwaggers(config: ConfigurationView, inputScope: DataStoreViewReadonly, inputFileUris: string[], workingScope: DataStoreView): Promise<DataHandleRead[]> {
  const rawSwaggers: DataHandleRead[] = [];
  let i = 0;
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwagger(config, inputScope, inputFileUri, workingScope.CreateScope("swagger_" + i));
    rawSwaggers.push(pluginInput);
    i++;
  }
  return rawSwaggers;
}
export async function LoadLiterateSwaggerOverrides(config: ConfigurationView, inputScope: DataStoreViewReadonly, inputFileUris: string[], workingScope: DataStoreView): Promise<DataHandleRead[]> {
  const rawSwaggers: DataHandleRead[] = [];
  let i = 0;
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwaggerOverride(config, inputScope, inputFileUri, workingScope.CreateScope("swagger_" + i));
    rawSwaggers.push(pluginInput);
    i++;
  }
  return rawSwaggers;
}

type ObjectWithPath<T> = { obj: T, path: JsonPath };
function getPropertyValues<T, U>(obj: ObjectWithPath<T>): ObjectWithPath<U>[] {
  const o: T = obj.obj || <T>{};
  return Object.getOwnPropertyNames(o).map(n => getProperty<T, U>(obj, n));
}
function getProperty<T, U>(obj: ObjectWithPath<T>, key: string): ObjectWithPath<U> {
  return { obj: (obj.obj as any)[key], path: obj.path.concat([key]) };
}
function getArrayValues<T>(obj: ObjectWithPath<T[]>): ObjectWithPath<T>[] {
  const o: T[] = obj.obj || [];
  return o.map((x, i) => { return { obj: x, path: obj.path.concat([i]) }; });
}

export async function ComposeSwaggers(config: ConfigurationView, infoSection: any, inputSwaggers: DataHandleRead[], workingScope: DataStoreView, azureMode: boolean): Promise<DataHandleRead> {
  if (azureMode) {
    // prepare component Swaggers (override info, lift version param, ...)
    for (let i = 0; i < inputSwaggers.length; ++i) {
      const inputSwagger = inputSwaggers[i];
      const outputSwagger = await workingScope.Write(`prepared_${i}.yaml`);
      const swagger = inputSwagger.ReadObject<any>();
      const mapping: Mappings = [];
      const populate: (() => void)[] = []; // populate swagger; deferred in order to simplify source map generation

      // digest "info"
      const info = swagger.info;
      const version = info.version;
      delete info.title;
      delete info.description;
      delete info.version;

      // extract interesting nodes
      const paths = From<ObjectWithPath<any>>([])
        .Concat(getPropertyValues(getProperty({ obj: swagger, path: [] }, "paths")))
        .Concat(getPropertyValues(getProperty({ obj: swagger, path: [] }, "x-ms-paths")));
      const methods = paths.SelectMany(getPropertyValues);
      const parameters =
        methods.SelectMany(method => getArrayValues<any>(getProperty<any, any>(method, "parameters"))).Concat(
          paths.SelectMany(path => getArrayValues<any>(getProperty<any, any>(path, "parameters"))));

      // inline api-version params
      const clientParams = swagger.parameters || {};
      const apiVersionClientParamName = Object.getOwnPropertyNames(clientParams).filter(n => clientParams[n].name === "api-version")[0];
      const apiVersionClientParam = apiVersionClientParamName ? clientParams[apiVersionClientParamName] : null;
      if (apiVersionClientParam) {
        const apiVersionClientParam = clientParams[apiVersionClientParamName];
        const apiVersionParameters = parameters.Where(p => p.obj.$ref === `#/parameters/${apiVersionClientParamName}`);
        for (let apiVersionParameter of apiVersionParameters) {
          delete apiVersionParameter.obj.$ref;

          // forward client param
          populate.push(() => Object.assign(apiVersionParameter.obj, apiVersionClientParam));
          mapping.push(...CreateAssignmentMapping(
            apiVersionClientParam, inputSwagger.key,
            ["parameters", apiVersionClientParamName], apiVersionParameter.path,
            "inlining api-version"));

          // make constant
          populate.push(() => apiVersionParameter.obj.enum = [version]);
          mapping.push({
            name: "inlining api-version", source: inputSwagger.key,
            original: { path: [<JsonPathComponent>"info", "version"] },
            generated: { path: apiVersionParameter.path.concat("enum") }
          });
          mapping.push({
            name: "inlining api-version", source: inputSwagger.key,
            original: { path: [<JsonPathComponent>"info", "version"] },
            generated: { path: apiVersionParameter.path.concat("enum", 0) }
          });
        }

        // remove api-version client param
        delete clientParams[apiVersionClientParamName];
      }

      // inline produces/consumes
      for (const pc of ["produces", "consumes"]) {
        const clientPC = swagger[pc];
        if (clientPC) {
          for (const method of methods) {
            if (!method.obj[pc]) {
              populate.push(() => method.obj[pc] = Clone(clientPC));
              mapping.push(...CreateAssignmentMapping(
                clientPC, inputSwagger.key,
                [pc], method.path.concat([pc]),
                `inlining ${pc}`));
            }
          }
        }
        delete swagger[pc];
      }

      // finish source map
      mapping.push(...IdentitySourceMapping(inputSwagger.key, ToAst(swagger)));

      // populate object
      populate.forEach(f => f());

      // write back
      inputSwaggers[i] = await outputSwagger.WriteObject(swagger, mapping, [inputSwagger]);
    }
  }

  const hwSwagger = await workingScope.Write("swagger.yaml");
  let hSwagger = await MergeYamls(config, inputSwaggers, hwSwagger);

  // custom info section
  if (infoSection) {
    const hwInfo = await workingScope.Write("info.yaml");
    const hInfo = await hwInfo.WriteObject({ info: infoSection });

    const hwSwagger = await workingScope.Write("swagger_customInfo.yaml");
    hSwagger = await MergeYamls(config, [hSwagger, hInfo], hwSwagger);
  }

  return hSwagger;
}