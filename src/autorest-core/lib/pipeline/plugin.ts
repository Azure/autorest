/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandleRead, DataStoreView } from "../data-store/dataStore";
import { MultiPromise, MultiPromiseUtility } from "./multi-promise";

export type DataPromise = MultiPromise<DataHandleRead>;
export type DataFactory = (workingScope: DataStoreView) => DataPromise;

// async function pluginJsonRpc(): DataPromise {
//   return (workingScope: DataStoreView) => MultiPromiseUtility.map(literate, async (literateDoc, index) => {
//     const docScope = workingScope.createScope(`doc${index}_tmp`);
//     const hwRawDoc = await workingScope.write(`doc${index}.yaml`);
//     const hRawDoc = await parse(literateDoc, hwRawDoc, docScope);
//     return hRawDoc;
//   });
// }