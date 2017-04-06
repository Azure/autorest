/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// polyfills for language support
require("../../polyfill.min.js");

import { createMessageConnection, Logger } from "vscode-jsonrpc";
import { IAutoRestPluginInitiator, IAutoRestPluginInitiator_Types, IAutoRestPluginTarget, IAutoRestPluginTarget_Types } from "../plugin-api";
import { EnhancedPosition, Mapping, RawSourceMap, SmartPosition } from '../../ref/source-map';
import { Parse, Stringify } from "../../ref/yaml";
import { Message, Channel } from "../../message";
const utils = require("../../../node_modules/oav/lib/util/utils");
const validation = require("../../../node_modules/oav/index");

class OpenApiValidationSemantic {
  public static readonly Name = "semantic-validatior";

  public async Process(sessionId: string, initiator: IAutoRestPluginInitiator): Promise<boolean> {
    const swaggerFileNames = await initiator.ListInputs(sessionId);
    for (const swaggerFileName of swaggerFileNames) {
      const swaggerFile = await initiator.ReadFile(sessionId, swaggerFileName);
      const swagger = Parse<any>(swaggerFile);

      utils.clearCache();
      utils.docCache["cache.json"] = swagger;
      const specValidationResult = await validation.validateSpec("cache.json", "off");
      const messages = specValidationResult.validateSpec;
      for (const message of messages.errors) {
        initiator.Message(sessionId, {
          Channel: Channel.Error,
          Details: message,
          Text: message.message,
          Source: [{ document: swaggerFileName, Position: <any>{ path: message["jsonref"].split("#/")[1].split("/") } }]
        });
      }
      for (const message of messages.warnings) {
        initiator.Message(sessionId, {
          Channel: Channel.Warning,
          Details: message,
          Text: message.message,
          Source: [{ document: swaggerFileName, Position: <any>{ path: message["jsonref"].split("#/")[1].split("/") } }]
        });
      }
    }
    return true;
  }
}

class OpenApiValidationExample {
  public static readonly Name = "example-validatior";

  public async Process(sessionId: string, initiator: IAutoRestPluginInitiator): Promise<boolean> {
    const swaggerFileNames = await initiator.ListInputs(sessionId);
    for (const swaggerFileName of swaggerFileNames) {
      const swaggerFile = await initiator.ReadFile(sessionId, swaggerFileName);
      const swagger = Parse<any>(swaggerFile);

      utils.clearCache();
      utils.docCache["cache.json"] = swagger;
      const specValidationResult = await validation.validateExamples("cache.json", null, "off");

      for (const op in specValidationResult.operations) {
        const opObj = specValidationResult.operations[op]["x-ms-examples"];
        if (opObj.isValid === false) {
          console.error(opObj);
          // TODO: dispatch meaningful messages at the right spots
        }
      }
    }
    return true;
  }
}

class PluginHost implements IAutoRestPluginTarget {
  public constructor(private readonly initiator: IAutoRestPluginInitiator) { }

  public async GetPluginNames(): Promise<string[]> {
    return [OpenApiValidationSemantic.Name, OpenApiValidationExample.Name];
  }

  public async Process(pluginName: string, sessionId: string): Promise<boolean> {
    switch (pluginName) {
      case OpenApiValidationSemantic.Name:
        return new OpenApiValidationSemantic().Process(sessionId, this.initiator);
      case OpenApiValidationExample.Name:
        return new OpenApiValidationExample().Process(sessionId, this.initiator);
      default:
        return false;
    }
  }
}


async function main() {
  // connection setup
  const channel = createMessageConnection(
    process.stdin,
    process.stdout,
    {
      error(message) { console.error(message); },
      info(message) { console.info(message); },
      log(message) { console.log(message); },
      warn(message) { console.warn(message); }
    }
  );

  const initiator: IAutoRestPluginInitiator = {
    async ReadFile(sessionId: string, filename: string): Promise<string> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.ReadFile, sessionId, filename);
    },
    async GetValue(sessionId: string, key: string): Promise<any> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.GetValue, sessionId, key);
    },
    async ListInputs(sessionId: string): Promise<string[]> {
      return await channel.sendRequest(IAutoRestPluginInitiator_Types.ListInputs, sessionId);
    },

    WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Mapping[] | RawSourceMap): void {
      channel.sendNotification(IAutoRestPluginInitiator_Types.WriteFile, sessionId, filename, content, sourceMap);
    },
    Message(sessionId: string, message: Message, path?: SmartPosition, sourceFile?: string): void {
      channel.sendNotification(IAutoRestPluginInitiator_Types.Message, sessionId, message, path, sourceFile);
    }
  };
  const target: IAutoRestPluginTarget = new PluginHost(initiator);
  channel.onRequest(IAutoRestPluginTarget_Types.GetPluginNames, target.GetPluginNames.bind(target));
  channel.onRequest(IAutoRestPluginTarget_Types.Process, target.Process.bind(target));

  // activate
  channel.listen();
}

main();