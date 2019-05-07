/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Oai2ToOai3 } from '@microsoft.azure/oai2-to-oai3';
import { DataHandle, DataSink } from '../data-store/data-store';
/* @internal */ export async function ConvertOAI2toOAI3(input: DataHandle, sink: DataSink): Promise<DataHandle> {
  const converter = new Oai2ToOai3(input.key, input.ReadObject());
  converter.convert();
  const generated = converter.generated;
  return sink.WriteObject('OpenAPI', generated, input.GetArtifact());
}
