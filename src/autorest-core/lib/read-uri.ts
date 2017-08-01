/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ConfigurationView } from '../dist/lib/autorest-core';
import { ReadUri } from "./ref/uri";

// this implements a very AutoRest specific layer on top of ReadUri, e.g. handling GitHub auth

export const githubAuthTokenSettingKey = "github-auth-token";

export async function SmartReadUri(uri: string, config: ConfigurationView): Promise<string> {
  const headers: { [key: string]: string } = {};
  const githubAuthToken = config.GetEntry(githubAuthTokenSettingKey as any);
  if (githubAuthToken) {
    headers.authorization = `Bearer ${githubAuthToken}`;
  }
  return ReadUri(uri, headers);
}
