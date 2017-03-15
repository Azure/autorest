// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
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
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger
{
    public static class SwaggerParser
    {
        public static ServiceDefinition Parse(string path, string swaggerDocument)
        {
            try
            {
                swaggerDocument = swaggerDocument.EnsureYamlIsJson();
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
                Uri filePath = null;
                Uri.TryCreate(path, UriKind.RelativeOrAbsolute, out filePath);
                swaggerService.FilePath = filePath;
                return swaggerService;
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError("{0}. {1}", Resources.ErrorParsingSpec, ex.Message);
            }
        }
    }
}