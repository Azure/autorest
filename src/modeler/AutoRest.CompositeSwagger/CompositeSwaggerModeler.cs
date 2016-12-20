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
using AutoRest.Core.Validation;
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
                if (!Settings.FileSystem.IsCompletePath(compositeDocument) || !Settings.FileSystem.FileExists(compositeDocument))
                {
                    // Otherwise, root it from the current path
                    compositeSwaggerModel.Documents[i] = Settings.FileSystem.MakePathRooted(Settings.InputFolder, compositeDocument);
                }
            }

            // construct merged swagger document
            var mergedSwagger = new YamlMappingNode();
            mergedSwagger.Set("swagger", new YamlScalarNode("2.0"));
            mergedSwagger.Set("info", (Settings.FileSystem.ReadFileAsText(Settings.Input).ParseYaml() as YamlMappingNode)?.Get("info") as YamlMappingNode);
            mergedSwagger.Set("host", new YamlScalarNode("management.azure.com"));
            mergedSwagger.Set("schemes", new YamlSequenceNode(new YamlScalarNode("https")));

            // merge child swaggers
            foreach (var childSwaggerPath in compositeSwaggerModel.Documents)
            {
                var childSwagger = Settings.FileSystem.ReadFileAsText(childSwaggerPath).ParseYaml() as YamlMappingNode;
                if (childSwagger == null)
                {
                    throw ErrorManager.CreateError("Failed parsing referenced Swagger file {0}.", childSwaggerPath);
                }

                // remove info
                var info = childSwagger.Get("info") as YamlMappingNode;
                var version = info.Get("version");
                childSwagger.Remove("info");

                // fix up api version
                var apiVersionParam = (childSwagger.Get("parameters") as YamlMappingNode).Children.First(param => ((param.Value as YamlMappingNode).Get("name") as YamlScalarNode).Value == "api-version");
                // TODO: add checks with meaningful errors instead of NRE exceptions...
                var apiVersionParamName = (apiVersionParam.Key as YamlScalarNode).Value;
                var apiVersionParams = (childSwagger.Get("paths") as YamlMappingNode).Children.Values.OfType<YamlMappingNode>()
                    .SelectMany(path => path.Children.Values.OfType<YamlMappingNode>())
                    .SelectMany(method => (method.Get("parameters") as YamlSequenceNode).Children.OfType<YamlMappingNode>())
                    .Where(param => (param.Get("$ref") as YamlScalarNode)?.Value == $"#/parameters/{apiVersionParamName}");
                foreach (var param in apiVersionParams)
                {
                    param.Remove("$ref");
                    foreach (var child in (apiVersionParam.Value as YamlMappingNode).Children)
                    {
                        param.Children.Add(child);
                    }
                    param.Set("enum", new YamlSequenceNode(version));
                }

                // merge
                mergedSwagger = mergedSwagger.MergeWith(childSwagger);
                (mergedSwagger.Get("parameters") as YamlMappingNode).Remove(apiVersionParamName);
            }

            // CodeModel compositeClient = InitializeServiceClient(compositeSwaggerModel);
            using (NewContext)
            {
                var swaggerModeler = new SwaggerModeler();
                return swaggerModeler.Build(SwaggerParser.Parse(mergedSwagger.Serialize()));
            }
        }
        
        private CompositeServiceDefinition Parse(string input)
        {
            var inputBody = Settings.FileSystem.ReadFileAsText(input);
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
        public override IEnumerable<ComparisonMessage> Compare()
        {
            throw new NotImplementedException("Version comparison of compositions. Please run the comparison on individual specifications");
        }
    }
}