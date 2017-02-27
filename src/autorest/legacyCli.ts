/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import { AutoRestConfiguration } from "./lib/configuration/configuration"

const regexLegacyArg = /^-[^-]/;

export function isLegacy(args: string[]): boolean {
  return args.some(arg => regexLegacyArg.test(arg));
}

export function configurationFromLegacyArgs(args: string[]): AutoRestConfiguration {
  return {
    "input-file": []
  }
}