// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Parsing;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.JsonConverters;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.IO;

namespace AutoRest.Swagger
{
    public static class SwaggerParser
    {
        static string Normalize(string swaggerDocument)
        {
            // normalize YAML to JSON since that's what we process
            swaggerDocument = swaggerDocument.EnsureYamlIsJson();
            return swaggerDocument;
        }

        public static ServiceDefinition Parse(string swaggerDocument)
        {
            try
            {
                swaggerDocument = Normalize(swaggerDocument);
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                settings.Converters.Add(new ResponseRefConverter(swaggerDocument));
                settings.Converters.Add(new PathItemRefConverter(swaggerDocument));
                settings.Converters.Add(new PathLevelParameterConverter(swaggerDocument));
                settings.Converters.Add(new SchemaRequiredItemConverter());
                settings.Converters.Add(new SecurityDefinitionConverter());
                var swaggerService = JsonConvert.DeserializeObject<ServiceDefinition>(swaggerDocument, settings);

                // for parameterized host, will be made available via JsonRpc accessible state in the future
                ServiceDefinition.Instance = swaggerService;
                if (swaggerService.Schemes == null || swaggerService.Schemes.Count != 1)
                {
                    swaggerService.Schemes = new List<TransferProtocolScheme> { TransferProtocolScheme.Http };
                }
                if (string.IsNullOrEmpty(swaggerService.Host))
                {
                    swaggerService.Host = "localhost";
                }
                return swaggerService;
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError("{0}. {1}\n{2}", Resources.ErrorParsingSpec, ex.Message,swaggerDocument);
            }
        }
    }
}
