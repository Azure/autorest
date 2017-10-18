/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ReadUri, ResolveUri } from '../ref/uri';
import { QuickDataSource } from '../data-store/data-store';
import { Parse } from '../ref/yaml';
import { Help } from "../../help";
import { PipelinePlugin } from "./pipeline";

export function GetPlugin_HelpAutoRest(): PipelinePlugin {
  return async config => {
    config.GeneratedFile.Dispatch({
      type: "help",
      uri: "_autorest0.json",
      content: JSON.stringify(<Help>{
        categoryFriendlyName: "Overall Verbosity",
        settings: [
          // {
          //   key: "quiet",
          //   description: "suppress most output information"
          // },
          {
            key: "verbose",
            description: "display verbose logging information"
          },
          {
            key: "debug",
            description: "display debug logging information"
          }
        ]
      })
    });
    config.GeneratedFile.Dispatch({
      type: "help",
      uri: "_autorest1.json",
      content: JSON.stringify(<Help>{
        categoryFriendlyName: "Manage Installation",
        settings: [
          {
            key: "info", // list-installed
            description: "display information about the installed version of autorest and its extensions"
          },
          {
            key: "list-available",
            description: "display available AutoRest versions"
          },
          {
            key: "reset",
            description: "removes all autorest extensions and downloads the latest version of the autorest-core extension"
          },
          {
            key: "preview",
            description: "enables using autorest extensions that are not yet released"
          },
          {
            key: "latest",
            description: "installs the latest autorest-core extension"
          },
          {
            key: "force",
            description: "force the re-installation of the autorest-core extension and frameworks"
          },
          {
            key: "version",
            description: "use the specified version of the autorest-core extension",
            type: "string"
          }
        ]
      })
    });
    return new QuickDataSource([]);
  };
}

export function GetPlugin_HelpAutoRestCore(): PipelinePlugin {
  return async config => {
    config.GeneratedFile.Dispatch({
      type: "help",
      uri: "_autorestCore0.json",
      content: JSON.stringify(<Help>{
        categoryFriendlyName: "Core Settings and Switches",
        settings: [
          {
            key: "help",
            description: "display help (combine with flags like --csharp to get further details about specific functionality)"
          },
          {
            key: "input-file",
            type: "string | string[]",
            description: "OpenAPI file to use as input (use this setting repeatedly to pass multiple files at once)"
          },
          {
            key: "output-folder",
            type: "string",
            description: "target folder for generated artifacts; default: \"<base folder>/generated\""
          },
          {
            key: "base-folder",
            description: "path to resolve relative paths (input/output files/folders) against; default: directory of configuration file, current directory otherwise"
          },
          {
            key: "message-format",
            type: "\"regular\", \"json\"",
            description: "format of messages (e.g. from OpenAPI validation); default: \"regular\""
          },
        ]
      })
    });
    config.GeneratedFile.Dispatch({
      type: "help",
      uri: "_autorestCore1.json",
      content: JSON.stringify(<Help>{
        categoryFriendlyName: "Core Functionality",
        description: "While AutoRest can be extended arbitrarily by 3rd parties (say, with a custom generator), we officially support and maintain the following functionality. More specific help is shown when --help is combined with the following switches.",
        settings: [
          {
            key: "csharp",
            description: "generate C# client code"
          },
          {
            key: "go",
            description: "generate Go client code"
          },
          {
            key: "java",
            description: "generate Java client code"
          },
          {
            key: "python",
            description: "generate Python client code"
          },
          {
            key: "nodejs",
            description: "generate NodeJS client code"
          },
          {
            key: "typescript",
            description: "generate TypeScript client code"
          },
          {
            key: "ruby",
            description: "generate Ruby client code"
          },
          {
            key: "php",
            description: "generate PHP client code"
          },
          {
            key: "azureresourceschema",
            description: "generate Azure resource schemas"
          },
          {
            key: "model-validator",
            description: "validates an OpenAPI document against linked examples (see https://github.com/Azure/azure-rest-api-specs/search?q=x-ms-examples)"
          },
          // {
          //   key: "semantic-validator",
          //   description: "validates semantic validation"
          // },
          {
            key: "azure-validator",
            description: "validates an OpenAPI document against guidelines to improve quality (and optionally Azure guidelines)"
          },
        ]
      })
    });
    return new QuickDataSource([]);
  };
}
