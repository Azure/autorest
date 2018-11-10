/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Clone, CreateAssignmentMapping, DataHandle, DataSink, JsonPath, JsonPathComponent, Mapping, QuickDataSource, ToAst } from '@microsoft.azure/datastore';
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
  const inputSwaggerObjects = inputSwaggers.map(sw => sw.ReadObject<any>());
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
    const version = info.version;
    delete info.title;
    delete info.description;
    if (!uniqueVersion) { delete info.version; }

    // extract interesting nodes
    const paths = From<ObjectWithPath<any>>([])
      .Concat(getPropertyValues(getProperty({ obj: swagger, path: [] }, 'paths')))
      .Concat(getPropertyValues(getProperty({ obj: swagger, path: [] }, 'x-ms-paths')));
    const methods = paths.SelectMany(getPropertyValues);
    const parameters =
      methods.SelectMany((method: any) => getArrayValues<any>(getProperty<any, any>(method, 'parameters'))).Concat(
        paths.SelectMany((path: any) => getArrayValues<any>(getProperty<any, any>(path, 'parameters'))));

    // inline api-version params
    if (!uniqueVersion) {
      const clientParams = swagger.parameters || {};
      const apiVersionClientParamName = Object.getOwnPropertyNames(clientParams).filter(n => clientParams[n].name === 'api-version')[0];
      const apiVersionClientParam = apiVersionClientParamName ? clientParams[apiVersionClientParamName] : null;
      if (apiVersionClientParam) {
        const apiVersionClientParam = clientParams[apiVersionClientParamName];
        const apiVersionParameters = parameters.Where((p: any) => p.obj.$ref === `#/parameters/${apiVersionClientParamName}`);
        for (const apiVersionParameter of apiVersionParameters) {
          delete apiVersionParameter.obj.$ref;

          // forward client param
          populate.push(() => ({ ...apiVersionParameter.obj, ...apiVersionClientParam }));
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
      newIdentity.push(...each.Identity);
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
}

/* @internal */
export function createComposerPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const swaggers = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));
    const overrideInfo = config.GetEntry('override-info');
    const overrideTitle = (overrideInfo && overrideInfo.title) || config.GetEntry('title');
    const overrideDescription = (overrideInfo && overrideInfo.description) || config.GetEntry('description');
    const swagger = await composeSwaggers(config, overrideTitle, overrideDescription, swaggers, sink);
    return new QuickDataSource([await sink.Forward('composed', swagger)], input.skip);
  };
}
