/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

export interface PathReference {
  $ref: string;
}

export interface Dereferenced<T> {
  instance: T;
  name: string;
  fromRef?: boolean;
}

export type Reference<T> = T;

export type Refable<T> = T | PathReference;

export type ExtensionKey = `x-${string}`;
