// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Globalization;
using System.Linq;
using AutoRest.CompositeSwagger.Model;
using AutoRest.CompositeSwagger.Properties;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Collections.Generic;
using static AutoRest.Core.Utilities.DependencyInjection;
using YamlDotNet.RepresentationModel;
using AutoRest.Core.Parsing;

namespace AutoRest.CompositeSwagger
{
    public class CompositeSwaggerModeler : Modeler
    {
        public CompositeSwaggerModeler()
        {
        }

        public override string Name
        {
            get { return "CompositeSwagger"; }
        }

        public override CodeModel Build()
        {
            var compositeSwaggerModel = Parse(Settings.Input);
            if (compositeSwaggerModel == null)
            {
                throw ErrorManager.CreateError(Resources.ErrorParsingSpec);
            }

            if (!compositeSwaggerModel.Documents.Any())
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, "Documents collection can not be empty."));
            }

            if (compositeSwaggerModel.Info == null)
            {
                throw ErrorManager.CreateError(Resources.InfoSectionMissing);
            }

            // Ensure all the docs are absolute URIs or rooted paths
            for (var i = 0; i < compositeSwaggerModel.Documents.Count; i++)
            {
                var compositeDocument = compositeSwaggerModel.Documents[i];
                if (!Settings.FileSystemInput.IsCompletePath(compositeDocument) || !Settings.FileSystemInput.FileExists(compositeDocument))
                {
                    // Otherwise, root it from the current path
                    compositeSwaggerModel.Documents[i] = Settings.FileSystemInput.MakePathRooted(Settings.FileSystemInput.GetParentDir(Settings.Input), compositeDocument);
                }
            }

            // construct merged swagger document
            var mergedSwagger = new YamlMappingNode();
            mergedSwagger.Set("info", (Settings.FileSystemInput.ReadAllText(Settings.Input).ParseYaml() as YamlMappingNode)?.Get("info") as YamlMappingNode);

            // merge child swaggers
            foreach (var childSwaggerPath in compositeSwaggerModel.Documents)
            {
                var childSwaggerRaw = Settings.FileSystemInput.ReadAllText(childSwaggerPath);
                childSwaggerRaw = SwaggerParser.Normalize(childSwaggerPath, childSwaggerRaw);
                var childSwagger = childSwaggerRaw.ParseYaml() as YamlMappingNode;
                if (childSwagger == null)
                {
                    throw ErrorManager.CreateError("Failed parsing referenced Swagger file {0}.", childSwaggerPath);
                }

                // remove info
                var info = childSwagger.Get("info") as YamlMappingNode;
                var version = info.Get("version");
                info.Remove("title");
                info.Remove("description");
                info.Remove("version");

                // fix up api version
                var apiVersionParam = (childSwagger.Get("parameters") as YamlMappingNode)?.Children?.FirstOrDefault(param => ((param.Value as YamlMappingNode)?.Get("name") as YamlScalarNode)?.Value == "api-version");
                var apiVersionParamName = (apiVersionParam?.Key as YamlScalarNode)?.Value;
                if (apiVersionParamName != null)
                {
                    var paths =
                        ((childSwagger.Get("paths") as YamlMappingNode)?.Children?.Values ?? Enumerable.Empty<YamlNode>()).Concat
                        ((childSwagger.Get("x-ms-paths") as YamlMappingNode)?.Children?.Values ?? Enumerable.Empty<YamlNode>());
                    var methods = paths.OfType<YamlMappingNode>().SelectMany(path => path.Children.Values.OfType<YamlMappingNode>());
                    var parameters = methods.SelectMany(method => (method.Get("parameters") as YamlSequenceNode)?.Children?.OfType<YamlMappingNode>() ?? Enumerable.Empty<YamlMappingNode>());
                    var apiVersionParams = parameters.Where(param => (param.Get("$ref") as YamlScalarNode)?.Value == $"#/parameters/{apiVersionParamName}");
                    foreach (var param in apiVersionParams)
                    {
                        param.Remove("$ref");
                        foreach (var child in (apiVersionParam?.Value as YamlMappingNode).Children)
                        {
                            param.Children.Add(child);
                        }
                        param.Set("enum", new YamlSequenceNode(version));
                    }
                }

                // merge
                mergedSwagger = mergedSwagger.MergeWith(childSwagger);
            }
            // remove apiVersion client property
            var mergedSwaggerApiVersionParam = (mergedSwagger.Get("parameters") as YamlMappingNode)?.Children?.FirstOrDefault(param => ((param.Value as YamlMappingNode)?.Get("name") as YamlScalarNode)?.Value == "api-version");
            var mergedSwaggerApiVersionParamName = (mergedSwaggerApiVersionParam?.Key as YamlScalarNode)?.Value;
            if (mergedSwaggerApiVersionParamName != null)
            {
                (mergedSwagger.Get("parameters") as YamlMappingNode).Remove(mergedSwaggerApiVersionParamName);
            }

            // CodeModel compositeClient = InitializeServiceClient(compositeSwaggerModel);
            using (NewContext)
            {
                var swaggerModeler = new SwaggerModeler();
                return swaggerModeler.Build(SwaggerParser.Parse(Settings.Input, mergedSwagger.Serialize()));
            }
        }
        
        private CompositeServiceDefinition Parse(string input)
        {
            var inputBody = Settings.FileSystemInput.ReadAllText(input);
            try
            {
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                return JsonConvert.DeserializeObject<CompositeServiceDefinition>(inputBody, settings);
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, ex.Message), ex);
            }
        }
        
        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public override IEnumerable<LogMessage> Compare()
        {
            throw new NotImplementedException("Version comparison of compositions. Please run the comparison on individual specifications");
        }
    }
}