// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.JsonConverters;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Modeler.Swagger
{
    public static class SwaggerParser
    {
        public static ServiceDefinition Load(string path, IFileSystem fileSystem)
        {
            if (fileSystem == null)
            {
                throw new ArgumentNullException("fileSystem");
            }

            return SwaggerParser.Parse(fileSystem.ReadFileAsText(path));
        }

        public static ServiceDefinition Parse(string swaggerDocument)
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