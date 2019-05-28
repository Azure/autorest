/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Clone, CreateAssignmentMapping, DataHandle, DataSink, JsonPath, JsonPathComponent, Mapping, QuickDataSource, ToAst, Transformer, AnyObject, Node } from '@microsoft.azure/datastore';
import { From } from 'linq-es2015';
import { pushAll } from '../../array';
import { ConfigurationView } from '../../autorest-core';
import { IdentitySourceMapping, MergeYamls } from '../../source-map/merging';
import { PipelinePlugin } from '../common';

function getArrayValues<T>(obj: ObjectWithPath<Array<T>>): Array<ObjectWithPath<T>> {
  const o: Array<T> = obj.obj || [];
  return o.map((x, i) => ({ obj: x, path: obj.path.concat([i]) }));
}

function distinct<T>(list: Array<T>): Array<T> {
  const sorted = list.slice().sort();
  return sorted.filter((x, i) => i === 0 || x !== sorted[i - 1]);
}

interface ObjectWithPath<T> { obj: T; path: JsonPath; }
function getPropertyValues<T, U>(obj: ObjectWithPath<T>): Array<ObjectWithPath<U>> {
  const o: T = obj.obj || <T>{};
  return Object.getOwnPropertyNames(o).map(n => getProperty<T, U>(obj, n));
}
function getProperty<T, U>(obj: ObjectWithPath<T>, key: string): ObjectWithPath<U> {
  return { obj: (<any>obj.obj)[key], path: obj.path.concat([key]) };
}

async function composeSwaggers(config: ConfigurationView, overrideInfoTitle: any, overrideInfoDescription: any, inputSwaggers: Array<DataHandle>, sink: DataSink): Promise<DataHandle> {
  const inputSwaggerObjects = await Promise.all(inputSwaggers.map(sw => sw.ReadObject<any>()));
  try {
    for (let i = 0; i < inputSwaggers.length; ++i) {
      const swagger = inputSwaggerObjects[i];
      // in x-ms-secondary-file files, remove everything not in components
      if (swagger['x-ms-secondary-file']) {
        for (const key of Object.keys(swagger)) {
          if (!key.startsWith('x-') && key !== 'components') {
            delete swagger[key];
          }
        }
      }
    }

    const candidateTitles: Array<string> = overrideInfoTitle
      ? [overrideInfoTitle]
      : distinct(inputSwaggerObjects.map(s => s.info).filter(i => !!i).map(i => i.title));
    const candidateDescriptions: Array<string> = overrideInfoDescription
      ? [overrideInfoDescription]
      : distinct(inputSwaggerObjects.map(s => s.info).filter(i => !!i).map(i => i.description).filter(i => !!i));
    const uniqueVersion: boolean = distinct(inputSwaggerObjects.map(s => s.info).filter(i => !!i).map(i => i.version)).length === 1;


    if (candidateTitles.length === 0) { throw new Error(`No 'title' in provided OpenAPI definition(s).`); }
    if (candidateTitles.length > 1) { throw new Error(`The 'title' across provided OpenAPI definitions has to match. Found: ${candidateTitles.map(x => `'${x}'`).join(', ')}. Please adjust or provide an override (--title=...).`); }
    if (candidateDescriptions.length !== 1) { candidateDescriptions.splice(0, candidateDescriptions.length); }

    // prepare component Swaggers (override info, lift version param, ...)
    for (let i = 0; i < inputSwaggers.length; ++i) {
      const inputSwagger = inputSwaggers[i];
      const swagger = inputSwaggerObjects[i];
      const mapping = new Array<Mapping>();
      const populate: Array<() => void> = []; // populate swagger; deferred in order to simplify source map generation

      // digest "info"
      const info = swagger.info;
      const version = (info ? info.version : '') || '';
      if (info) {
        delete info.title;
        delete info.description;

        if (!uniqueVersion) { delete info.version; }
      }

      const root = { obj: swagger, path: [] };
      const paths = getPropertyValues(getProperty(root, 'paths'));
      const xmspaths = getPropertyValues(getProperty(root, 'x-ms-paths'));

      // extract interesting nodes
      const allPaths = From<ObjectWithPath<any>>([]).Concat(paths).Concat(xmspaths);

      const methods = allPaths.SelectMany(getPropertyValues);

      const parameters =
        methods.SelectMany((method: any) => getArrayValues<any>(getProperty<any, any>(method, 'parameters'))).Concat(
          allPaths.SelectMany((path: any) => getArrayValues<any>(getProperty<any, any>(path, 'parameters'))));

      // inline api-version params
      if (!uniqueVersion) {
        const clientParams = swagger.components.parameters || {};
        const apiVersionClientParamName = Object.getOwnPropertyNames(clientParams).filter(n => clientParams[n].name === 'api-version')[0];
        const apiVersionClientParam = apiVersionClientParamName ? clientParams[apiVersionClientParamName] : null;
        if (apiVersionClientParam) {
          const apiVersionClientParam = clientParams[apiVersionClientParamName];
          const apiVersionParameters = parameters.Where((p: any) => p.obj.$ref.endsWith(`#/components/parameters/${apiVersionClientParamName}`));
          for (const apiVersionParameter of apiVersionParameters) {
            delete apiVersionParameter.obj.$ref;

            // this inlines the apiversion parameter as a constant.
            for (const each of Object.keys(apiVersionClientParam)) {
              if (each === 'schema') {
                apiVersionParameter.obj[each] = {
                  type: 'string',
                  enum: [version]
                };
              } else {
                apiVersionParameter.obj[each] = apiVersionClientParam[each];
              }
            }
            // forward client param
            //populate.push(() => ({ ...apiVersionParameter.obj, ...apiVersionClientParam }));
            mapping.push(...CreateAssignmentMapping(
              apiVersionClientParam, inputSwagger.key,
              ['parameters', apiVersionClientParamName], apiVersionParameter.path,
              'inlining api-version'));

            // make constant
            populate.push(() => apiVersionParameter.obj.enum = [version]);
            mapping.push({
              name: 'inlining api-version', source: inputSwagger.key,
              original: { path: [<JsonPathComponent>'info', 'version'] },
              generated: { path: apiVersionParameter.path.concat('enum') }
            });

            mapping.push({
              name: 'inlining api-version', source: inputSwagger.key,
              original: { path: [<JsonPathComponent>'info', 'version'] },
              generated: { path: apiVersionParameter.path.concat('enum', 0) }
            });
          }

          // remove api-version client param
          delete clientParams[apiVersionClientParamName];
        }
      }


      // Massive Hack:
      // inline schema $refs for operation parameters because the existing modeler doesn't unwrap $ref'd schemas for parameters
      // this is required to keep existing generators working with the newer loader pipeline without updating the modeler
      if (swagger.components.parameters) {
        for (const p of Object.keys(swagger.components.parameters)) {
          const parameter = swagger.components.parameters[p];
          if (parameter.schema && parameter.schema.$ref) {
            const schemaName = parameter.schema.$ref.replace(/.*\//g, '');
            const schema = swagger.components.schemas[schemaName];
            if (schema) {
              delete parameter.schema.$ref;
              for (const item of Object.keys(schema)) {
                parameter.schema[item] = schema[item];
              }
            }
          }
        }
      }
      if (swagger.components.responses) {
        for (const r of Object.keys(swagger.components.responses)) {
          const response = swagger.components.responses[r];
          if (response.headers) {
            for (const h of Object.keys(response.headers)) {
              const header = response.headers[h];
              if (header.$ref) {

                const headerName = header.$ref.replace(/.*\//g, '');
                const actual = swagger.components.headers[headerName];

                delete header.$ref;
                for (const item of Object.keys(actual)) {
                  header[item] = actual[item];
                }
              }
            }
          }
        }
      }





      // inline produces/consumes
      for (const pc of ['produces', 'consumes']) {
        const clientPC = swagger[pc];
        if (clientPC) {
          for (const method of methods) {
            if (typeof method.obj === 'object' && !Array.isArray(method.obj) && !(<any>method.obj)[pc]) {
              populate.push(() => (<any>method.obj)[pc] = Clone(clientPC));
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
      pushAll(mapping, IdentitySourceMapping(inputSwagger.key, ToAst(swagger)));

      // populate object
      populate.forEach(f => f());

      // write back
      const newIdentity = new Array<string>();
      for (const each of inputSwaggers) {
        newIdentity.push(...each.identity);
      }

      inputSwaggers[i] = await sink.WriteObject('prepared', swagger, newIdentity, undefined, mapping, [inputSwagger]);
    }

    let hSwagger = await MergeYamls(config, inputSwaggers, sink, true);

    // override info section
    const info: any = { title: candidateTitles[0] };
    if (candidateDescriptions[0]) { info.description = candidateDescriptions[0]; }
    const hInfo = await sink.WriteObject('info.yaml', { info }, ['fix-me-4']);

    hSwagger = await MergeYamls(config, [hSwagger, hInfo], sink);

    return hSwagger;
  } catch (E) {
    console.error(`${__filename} - FAILURE ${JSON.stringify(E)}`);
    throw E;
  }
}

class ExternalRefCleaner extends Transformer<any, any> {

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === '$ref') {
        const newReference = value.replace(/^.+#/g, '#');
        this.copy(targetParent, key, pointer, newReference);
      } else if (Array.isArray(value)) {
        await this.process(this.newArray(targetParent, key, pointer), children);
      } else if (value && typeof (value) === 'object') {
        await this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        this.copy(targetParent, key, pointer, value);
      }
    }
  }
}

/* @internal */
export function createComposerPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const swaggers = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
    const overrideInfo = config.GetEntry('override-info');
    const overrideTitle = (overrideInfo && overrideInfo.title) || config.GetEntry('title');
    const overrideDescription = (overrideInfo && overrideInfo.description) || config.GetEntry('description');
    const swagger = await composeSwaggers(config, overrideTitle, overrideDescription, swaggers, sink);
    const refCleaner = new ExternalRefCleaner(swagger);
    const result = await sink.WriteObject(swagger.Description, await refCleaner.getOutput(), swagger.identity, swagger.artifactType, await refCleaner.getSourceMappings(), [swagger]);
    return new QuickDataSource([result], input.skip);
  };
}
