/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { QuickDataSource } from '../data-store/data-store';
import { PipelinePlugin } from './pipeline';

export function GetPlugin_ReflectApiVersion(): PipelinePlugin {
  return async (config, input, sink) => {
    const files = await input.Enum();

    // get resolved Swagger to determine title
    const resolvedSwagger = await input.ReadStrict(files.shift() as any);
    const title = resolvedSwagger.ReadObject<any>().info.title.replace(/[^a-zA-Z]/g, "");

    // collect metadata
    const data: { namespace: string, group: string, apiVersion: string }[] = [];
    for (let file of files) {
      const swagger = (await input.ReadStrict(file)).ReadObject<any>();
      const apiVersion = swagger.info.version;
      const paths = { ...swagger["paths"], ...swagger["x-ms-paths"] };
      for (const path of Object.keys(paths)) {
        const namespace = (/\/Microsoft\.(.*?)\//i.exec(path) || [])[1];
        if (namespace) {
          const groups = Object.values(paths[path])
            .map(x => x.operationId).filter(x => !!x)
            .map(x => x.split('_')[0]).filter(x => !!x);
          for (const group of groups) {
            data.push({ namespace, group, apiVersion });
          }
        }
      }
    }

    // create C# metadata
    let tuples = data.map(x => `new Tuple<string, string, string>("${x.namespace}", "${x.group}", "${x.apiVersion}")`);
    tuples = tuples.sort();
    tuples = tuples.filter((x, i) => i === 0 || x !== tuples[i - 1]);

    return new QuickDataSource([await sink.WriteData(`SdkInfo_${title}.cs`, `
using System;
using System.Collections.Generic;
using System.Linq;

internal static partial class SdkInfo
{
    public static IEnumerable<Tuple<string, string, string>> ApiInfo_${title}
    {
        get
        {
            return new Tuple<string, string, string>[]
            {
${tuples.map(x => `                ${x},`).join("\n")}
            }.AsEnumerable();
        }
    }
}
`)]);
  };
}