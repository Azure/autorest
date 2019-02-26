/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandle, DataSink } from '@microsoft.azure/datastore';
import { Oai2ToOai3 } from '@microsoft.azure/oai2-to-oai3';
import { clone } from '@microsoft.azure/linq';

export async function convertOAI2toOAI3(input: DataHandle, sink: DataSink): Promise<DataHandle> {
  const converter = new Oai2ToOai3(input.originalFullPath, input.ReadObject());
  converter.convert();
  const generated = clone(converter.generated);
  return sink.WriteObject('OpenAPI', generated, input.identity);
}
