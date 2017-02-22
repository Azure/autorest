/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yaml from "js-yaml";

export function parse<T>(rawYaml: string): T {
    return yaml.safeLoad(rawYaml);
}

export function stringify(object: any): string {
    return yaml.safeDump(object);
}