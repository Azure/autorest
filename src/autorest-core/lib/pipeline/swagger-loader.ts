/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataStoreView, DataHandleRead, DataStoreViewReadonly } from "../data-store/data-store";
import { JsonPath, JsonPathComponent, stringify } from "../ref/jsonpath";
import { ResolveRelativeNode } from "../parsing/yaml";
import { Descendants, YAMLNodeWithPath, ToAst, StringifyAst, CloneAst } from "../ref/yaml";
import { ResolveUri } from "../ref/uri";
import { From, Enumerable } from "../ref/linq";
import { Mappings, Mapping } from "../ref/source-map";
import { CreateAssignmentMapping } from "../source-map/source-map";
import { Parse as ParseLiterateYaml } from "../parsing/literate-yaml";
import { MergeYamls, IdentitySourceMapping } from "../source-map/merging";

import { WriteString } from "../ref/writefs";

async function EnsureCompleteDefinitionIsPresent(
  inputScope: DataStoreViewReadonly,
  workingScope: DataStoreView,
  visitedEntities: string[],
  externalFiles: { [uri: string]: DataHandleRead },
  sourceFileUri: string,
  sourceDocObj: any,
  sourceDocMappings: Enumerable<Mapping>,
  currentFileUri?: string,
  entityType?: string,
  modelName?: string) {

  const references: YAMLNodeWithPath[] = [];
  const sourceDoc = externalFiles[sourceFileUri];
  if (currentFileUri == null) {
    currentFileUri = sourceFileUri;
  }

  var currentDoc = await externalFiles[currentFileUri].ReadYamlAst();
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
    const refPath = node.value as string;
    if (refPath.indexOf("#") === -1) {
      continue; // TODO: could inject entire referenced file here
    }
    const refPathParts = refPath.split("#").filter(s => s.length > 0);
    let fileUri: string | null = null;
    let entityPath = refPath;
    if (refPathParts.length === 2) {
      fileUri = refPathParts[0];
      entityPath = "#" + refPathParts[1];
      fileUri = ResolveUri(sourceFileUri, fileUri);
      if (!externalFiles[fileUri]) {
        const externalFile = await ParseLiterateYaml(await inputScope.ReadStrict(fileUri), workingScope.CreateScope(`ext_${Object.getOwnPropertyNames(externalFiles).length}`));
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
          sourceDocMappings = await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, fileUri, referencedEntityType, referencedModelName);
          const extObj = await externalFiles[fileUri].ReadObject<any>();
          inputs.push(externalFiles[fileUri]);
          sourceDocObj[referencedEntityType][referencedModelName] = extObj[referencedEntityType][referencedModelName];
          sourceDocMappings = sourceDocMappings.Concat(CreateAssignmentMapping(
            extObj[referencedEntityType][referencedModelName], externalFiles[fileUri].key,
            [referencedEntityType, referencedModelName], [referencedEntityType, referencedModelName],
            `resolving '${refPath}' in '${currentFileUri}'`));
        }
        else {
          sourceDocMappings = await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, currentFileUri, referencedEntityType, referencedModelName);
          const currentObj = await externalFiles[currentFileUri].ReadObject<any>();
          inputs.push(externalFiles[currentFileUri]);
          sourceDocObj[referencedEntityType][referencedModelName] = currentObj[referencedEntityType][referencedModelName];
          sourceDocMappings = sourceDocMappings.Concat(CreateAssignmentMapping(
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
        sourceDocMappings = await EnsureCompleteDefinitionIsPresent(inputScope, workingScope, visitedEntities, externalFiles, sourceFileUri, sourceDocObj, sourceDocMappings, currentFileUri, defSec, model);
        const currentObj = await externalFiles[currentFileUri].ReadObject<any>();
        inputs.push(externalFiles[currentFileUri]);
        sourceDocObj[defSec][model] = currentObj[defSec][model];
        sourceDocMappings = sourceDocMappings.Concat(CreateAssignmentMapping(
          currentObj[defSec][model], externalFiles[currentFileUri].key,
          [defSec, model], [defSec, model],
          `resolving '${stringify(dependentRef.path)}' (has allOf on '${reference}') in '${currentFileUri}'`));
      }
    }
  }

  // commit back
  const id = (await workingScope.Enum()).length;
  const target = await workingScope.Write(`revision_${id}.yaml`);
  externalFiles[sourceFileUri] = await target.WriteObject(sourceDocObj, sourceDocMappings, inputs);
  return sourceDocMappings;
}

async function StripExternalReferences(swagger: DataHandleRead, workingScope: DataStoreView): Promise<DataHandleRead> {
  const result = await workingScope.Write("result.yaml");
  const ast = CloneAst(await swagger.ReadYamlAst());
  const mapping = IdentitySourceMapping(swagger.key, ast);
  for (const node of Descendants(ast)) {
    if (node.path[node.path.length - 1] === "$ref") {
      const parts = (node.node.value as string).split('#');
      if (parts.length === 2) {
        node.node.value = "#" + (node.node.value as string).split('#')[1];
      }
    }
  }
  return await result.WriteData(StringifyAst(ast), mapping, [swagger]);
}

export async function LoadLiterateSwagger(inputScope: DataStoreViewReadonly, inputFileUri: string, workingScope: DataStoreView): Promise<DataHandleRead> {
  const data = await ParseLiterateYaml(await inputScope.ReadStrict(inputFileUri), workingScope.CreateScope("yaml"));
  const externalFiles: { [uri: string]: DataHandleRead } = {};
  externalFiles[inputFileUri] = data;
  //WriteString(`file:///C:/output/${(<any>workingScope).name}_before.yaml`, await externalFiles[inputFileUri].ReadData());
  await EnsureCompleteDefinitionIsPresent(inputScope,
    workingScope.CreateScope("ref-resolving"),
    [],
    externalFiles,
    inputFileUri,
    await data.ReadObject<any>(),
    From(IdentitySourceMapping(data.key, await data.ReadYamlAst())));
  const result = await StripExternalReferences(externalFiles[inputFileUri], workingScope.CreateScope("strip-ext-references"));
  //WriteString(`file:///C:/output/${(<any>workingScope).name}_after.yaml`, await result.ReadData());
  return result;
}

export async function LoadLiterateSwaggers(inputScope: DataStoreViewReadonly, inputFileUris: string[], workingScope: DataStoreView): Promise<DataHandleRead[]> {
  const rawSwaggers: DataHandleRead[] = [];
  let i = 0;
  for (const inputFileUri of inputFileUris) {
    // read literate Swagger
    const pluginInput = await LoadLiterateSwagger(inputScope, inputFileUri, workingScope.CreateScope("swagger_" + i));
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

export async function ComposeSwaggers(infoSection: any, inputSwaggers: DataHandleRead[], workingScope: DataStoreView, azureMode: boolean): Promise<DataHandleRead> {
  if (azureMode) {
    // prepare component Swaggers (override info, lift version param, ...)
    for (let i = 0; i < inputSwaggers.length; ++i) {
      const inputSwagger = inputSwaggers[i];
      const outputSwagger = await workingScope.Write(`prepared_${i}.yaml`);
      const swagger = await inputSwagger.ReadObject<any>();
      let mapping = From([] as Mappings);
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
          mapping = mapping.Concat(CreateAssignmentMapping(
            apiVersionClientParam, inputSwagger.key,
            ["parameters", apiVersionClientParamName], apiVersionParameter.path,
            "inlining api-version"));

          // make constant
          populate.push(() => apiVersionParameter.obj.enum = [version]);
          mapping = mapping.Concat([
            {
              name: "inlining api-version", source: inputSwagger.key,
              original: { path: [<JsonPathComponent>"info", "version"] },
              generated: { path: apiVersionParameter.path.concat("enum") }
            },
            {
              name: "inlining api-version", source: inputSwagger.key,
              original: { path: [<JsonPathComponent>"info", "version"] },
              generated: { path: apiVersionParameter.path.concat("enum", 0) }
            }]);
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
              populate.push(() => method.obj[pc] = clientPC);
              mapping = mapping.Concat(CreateAssignmentMapping(
                clientPC, inputSwagger.key,
                [pc], method.path.concat([pc]),
                `inlining ${pc}`));
            }
          }
        }
        delete swagger[pc];
      }

      // finish source map
      mapping = mapping.Concat(IdentitySourceMapping(inputSwagger.key, ToAst(swagger)));

      // populate object
      populate.forEach(f => f());

      // write back
      inputSwaggers[i] = await outputSwagger.WriteObject(swagger, mapping, [inputSwagger]);
    }
  }

  const hwSwagger = await workingScope.Write("swagger.yaml");
  let hSwagger = await MergeYamls(inputSwaggers, hwSwagger);

  // custom info section
  if (infoSection) {
    const hwInfo = await workingScope.Write("info.yaml");
    const hInfo = await hwInfo.WriteObject({ info: infoSection });

    const hwSwagger = await workingScope.Write("swagger_customInfo.yaml");
    hSwagger = await MergeYamls([hSwagger, hInfo], hwSwagger);
  }

  return hSwagger;
}