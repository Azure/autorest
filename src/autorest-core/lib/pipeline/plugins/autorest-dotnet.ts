/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { LazyPromise } from "../../lazy";
import { SpawnJsonRpcAutoRest } from "../../../interop/autorest-dotnet";
import { AutoRestExtension } from "../plugin-endpoint";

const instance = new LazyPromise<AutoRestExtension>(() => AutoRestExtension.FromChildProcess(SpawnJsonRpcAutoRest()));
export function GetAutoRestDotNetPlugin(): PromiseLike<AutoRestExtension> {
  return instance;
}
