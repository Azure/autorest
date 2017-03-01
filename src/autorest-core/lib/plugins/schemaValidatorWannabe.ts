/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Readable } from "stream";
import { DataHandleRead } from "../data-store/dataStore";

class PluginSchemaValidatorWannabe {
  public run(hSwagger: DataHandleRead): Readable {
    const readable = new Readable({ objectMode: true });
    (async () => {
      const swagger = await hSwagger.readObject<{ swagger: string }>();
      readable.push(swagger.swagger === "2.0");
    })();
    return readable;
  }
}