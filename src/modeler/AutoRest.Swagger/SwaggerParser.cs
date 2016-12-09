// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using AutoRest.Core.Logging;
using AutoRest.Core.Parsing;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.JsonConverters;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger
{
    public static class SwaggerParser
    {
        public static ServiceDefinition Load(string path, IFileSystem fileSystem)
        {
            if (fileSystem == null)
            {
                throw new ArgumentNullException("fileSystem");
            }

            var swaggerDocument = fileSystem.ReadFileAsText(path);
            return Parse(swaggerDocument);
        }

        public static ServiceDefinition Parse(string swaggerDocument)
        {
            try
            {
                if (!swaggerDocument.IsYaml()) // try parse as markdown if it is not YAML
                {
                    Logger.Instance.Log(LogMessageSeverity.Info, "Parsing as literate Swagger");
                    swaggerDocument = new LiterateYamlParser().Parse(swaggerDocument, true);
                }
                // normalize YAML to JSON since that's what we process
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

                // Extract all external references
                JObject jObject = JObject.Parse(swaggerDocument);
                foreach (JValue value in jObject.SelectTokens("$..$ref"))
                {
                    var path = (string)value;
                    if (path != null && path.Split(new[] {'#'}, StringSplitOptions.RemoveEmptyEntries).Length == 2)
                    {
                        swaggerService.ExternalReferences.Add(path);
                    }
                }

                return swaggerService;
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, ex.Message), ex);
            }
        }
    }
}