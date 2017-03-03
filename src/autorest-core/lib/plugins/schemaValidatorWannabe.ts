/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { DataHandleRead } from "../data-store/dataStore";

class PluginSchemaValidatorWannabe {
  public async run(hSwagger: DataHandleRead): Promise<boolean> {
    const swagger = await hSwagger.readObject<{ swagger: string }>();
    return swagger.swagger === "2.0";
  }
}