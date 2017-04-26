/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// polyfills for language support
require("../../polyfill.min.js");

import { JsonPath, nodes } from '../../ref/jsonpath';
import { createMessageConnection, Logger } from "vscode-jsonrpc";
import { IAutoRestPluginInitiator, IAutoRestPluginInitiator_Types, IAutoRestPluginTarget, IAutoRestPluginTarget_Types } from "../plugin-api";
import { EnhancedPosition, Mapping, RawSourceMap, SmartPosition } from "../../ref/source-map";
import { Parse, Stringify } from "../../ref/yaml";
import { Message, Channel } from "../../message";
import { From } from "../../ref/linq";
const utils = require("../../../node_modules/oav/lib/util/utils");
const validation = require("../../../node_modules/oav/index");

/**
 * The tools report paths in a way that does not represent indices as numbers.
 * This method tries to recover this information.
 */
function UnAmarifyPath(path: string[]): JsonPath {
  const result: JsonPath = path.slice();
  for (let i = 1; i < result.length; ++i) {
    const num = +result[i];
    if (!isNaN(num) && result[i - 1] === "parameters") {
      result[i] = num;
    }
  }
  return result;
}

class OpenApiValidationSemantic {
  public static readonly Name = "semantic-validator";

  public async Process(sessionId: string, initiator: IAutoRestPluginInitiator): Promise<boolean> {
    const swaggerFileNames = await initiator.ListInputs(sessionId);
    for (const swaggerFileName of swaggerFileNames) {
      const swaggerFile = await initiator.ReadFile(sessionId, swaggerFileName);
      const swagger = Parse<any>(swaggerFile);

      Object.defineProperty(utils, "docCache", {
        configurable: true,
        get: () => <any>{ "cache.json": swagger },
        set: () => { }
      });
      const specValidationResult = await validation.validateSpec("cache.json", "off");
      const messages = specValidationResult.validateSpec;
      for (const message of messages.errors) {
        initiator.Message(sessionId, {
          Channel: Channel.Error,
          Details: message,
          Text: message.message,
          Source: [{ document: swaggerFileName, Position: <any>{ path: UnAmarifyPath(message["jsonref"].split("#/")[1].split("/")) } }]
        });
      }
      for (const message of messages.warnings) {
        initiator.Message(sessionId, {
          Channel: Channel.Warning,
          Details: message,
          Text: message.message,
          Source: [{ document: swaggerFileName, Position: <any>{ path: UnAmarifyPath(message["jsonref"].split("#/")[1].split("/")) } }]
        });
      }
    }
    return true;
  }
}

class OpenApiValidationExample {
  public static readonly Name = "model-validator";

  public async Process(sessionId: string, initiator: IAutoRestPluginInitiator): Promise<boolean> {
    const swaggerFileNames = await initiator.ListInputs(sessionId);
    for (const swaggerFileName of swaggerFileNames) {
      const swaggerFile = await initiator.ReadFile(sessionId, swaggerFileName);
      const swagger = Parse<any>(swaggerFile);

      Object.defineProperty(utils, "docCache", {
        configurable: true,
        get: () => <any>{ "cache.json": swagger },
        set: () => { }
      });
      const specValidationResult = await validation.validateExamples("cache.json", null, "off");

      for (const op of Object.getOwnPropertyNames(specValidationResult.operations)) {
        const opObj = specValidationResult.operations[op]["x-ms-examples"];
        // remove circular reference...
        opObj.scenarios = null;

        // invalid?
        if (opObj.isValid === false) {
          // get path to x-ms-examples in swagger
          const xmsexPath = From(nodes(swagger, `$.paths[*][?(@.operationId==='${op}')]["x-ms-examples"]`))
            .Select(x => x.path)
            .FirstOrDefault();
          if (!xmsexPath) {
            throw new Error("Model Validator: Path to x-ms-examples not found.");
          }

          // console.error(JSON.stringify(opObj, null, 2));
          initiator.Message(sessionId, {
            Channel: Channel.Verbose,
            Details: opObj,
            Text: "Model validator found issue (see details).",
            Source: [{ document: swaggerFileName, Position: <any>{ path: xmsexPath } }]
          });

          // request
          const request = opObj.request;
          if (request.isValid === false) {
            const error = request.error;
            const innerErrors = error.innerErrors;

            if (!innerErrors || !innerErrors.length) {
              throw new Error("Model Validator: Unexpected format.");
            }

            for (const error of innerErrors) {
              const path = UnAmarifyPath(error.path);
              // console.error(JSON.stringify(error, null, 2));
              initiator.Message(sessionId, {
                Channel: Channel.Error,
                Details: error,
                Text: error.message,
                Key: [error.code],
                Source: [
                  { document: swaggerFileName, Position: <any>{ path: xmsexPath } },
                  { document: swaggerFileName, Position: <any>{ path: path } }
                ]
              });

              // TODO: more detailed error by traversing into "error.errors"? Can Amar make this easier?
            }
          }

          // responses
          const responseCodes = Object.getOwnPropertyNames(opObj.responses);
          for (const responseCode of responseCodes) {
            const response = opObj.responses[responseCode];
            if (response.isValid === false) {
              const error = response.error;
              const innerErrors = error.innerErrors;

              if (!innerErrors || !innerErrors.length) {
                throw new Error("Model Validator: Unexpected format.");
              }

              for (const error of innerErrors) {
                // console.error(JSON.stringify(error, null, 2));
                initiator.Message(sessionId, {
                  Channel: Channel.Error,
                  Details: error,
                  Text: error.message,
                  Key: [error.code],
                  Source: [
                    { document: swaggerFileName, Position: <any>{ path: xmsexPath } },
                    { document: swaggerFileName, Position: <any>{ path: xmsexPath.slice(0, xmsexPath.length - 1).concat(["responses", responseCode]) } }
                  ]
                });

                // TODO: more detailed error by traversing into "error.errors"? Can Amar make this easier?
              }
            }
          }
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