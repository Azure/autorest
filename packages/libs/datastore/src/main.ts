/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
// export * from "./proxy"
export * from "./file-system";
export * from "./json-path/json-path";
export * from "./json-pointer";
export * from "./graph-builder";
export * from "./mapping-tree";
export * from "./data-store";
export * from "./cancellation";
export * from "./source-map";

export { Lazy, LazyPromise } from "./lazy";
export * from "./parsing/text-utility";

export * from "./source-map/blaming";
export * from "./parsing/stable-object";
export * from "./processor";
export * from "./transformer-via-pointer";

export { safeEval, createSandbox } from "@azure-tools/codegen";
