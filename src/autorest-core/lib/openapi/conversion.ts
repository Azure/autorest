/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink } from '../data-store/data-store';
const convertOAI2toOAI3 = (oa2def: OpenApi2Definition): Promise<OpenApi3Definition> => require("swagger2openapi").convert(oa2def, {});

export async function ConvertOAI2toOAI3(input: DataHandle, sink: DataSink): Promise<DataHandle> {
  const oa2 = input.ReadObject<OpenApi2Definition>();
  const oa3 = await convertOAI2toOAI3(oa2);
  return await sink.WriteObject("OpenAPI", oa3);
}

