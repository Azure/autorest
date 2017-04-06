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
        public static Settings Settings => Settings.Instance;

        public static ServiceDefinition Load(string path, IFileSystem fileSystem)
        {
            if (fileSystem == null)
            {
                throw new ArgumentNullException("fileSystem");
            }

            var swaggerDocument = fileSystem.ReadAllText(path);
            return Parse(path, swaggerDocument);
        }

        public static string ResolveExternalReferencesInJson(this string path, string swaggerDocument)
        {
            string result = null;
            JObject swaggerObject = JObject.Parse(swaggerDocument);
            var externalFiles = new Dictionary<string, JObject>();
            externalFiles[path] = swaggerObject;
            HashSet<string> visitedEntities = new HashSet<string>();
            EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, path);
            result = swaggerObject.ToString();
            return result;
        }

        public static void EnsureCompleteDefinitionIsPresent(HashSet<string> visitedEntities, Dictionary<string, JObject> externalFiles, string sourceFilePath, string currentFilePath = null, string entityType = null, string modelName = null)
        {
            IEnumerable<JToken> references;
            var sourceDoc = externalFiles[sourceFilePath];
            if (currentFilePath == null)
            {
                currentFilePath = sourceFilePath;
            }

            var currentDoc = externalFiles[currentFilePath];
            if (entityType == null && modelName == null)
            {
                //first call to the recursive function. Hence we will process file references only.
                references = currentDoc.SelectTokens("$..$ref").Where(p => !((string)p).StartsWith("#") && !((string)p).Contains("/example"));
            }
            else
            {
                //It is possible that the external doc had a fully defined model. Hence we need to process all the refs of that model.
                references = currentDoc[entityType][modelName].SelectTokens("$..$ref");
            }

            foreach (JValue value in references)
            {
                var path = (string)value;
                string[] splitReference = path.Split(new[] { '#' }, StringSplitOptions.RemoveEmptyEntries);
                string filePath = null, entityPath = path;
                if (path != null && splitReference.Length == 2)
                {
                    filePath = splitReference[0];
                    entityPath = "#" + splitReference[1];
                    value.Value = entityPath;
                    // Make sure the filePath is either an absolute uri, or a rooted path
                    if (!Settings.FileSystemInput.IsCompletePath(filePath))
                    {
                        // Otherwise, root it from the directory (one level up) of the current swagger file path
                        filePath = Settings.FileSystemInput.MakePathRooted(Settings.FileSystemInput.GetParentDir(currentFilePath), filePath);
                    }
                    if (!externalFiles.ContainsKey(filePath))
                    {
                        var externalDefinitionString = Settings.FileSystemInput.ReadAllText(filePath);
                        externalFiles[filePath] = JObject.Parse(externalDefinitionString);
                    }
                }

                var referencedEntityType = entityPath.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries)[1];
                var referencedModelName = entityPath.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries)[2];

                if (sourceDoc[referencedEntityType] == null)
                {
                    sourceDoc[referencedEntityType] = new JObject();
                }
                if (sourceDoc[referencedEntityType][referencedModelName] == null && !visitedEntities.Contains(referencedModelName))
                {
                    visitedEntities.Add(referencedModelName);
                    if (filePath != null)
                    {
                        //recursively check if the model is completely defined.
                        EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, sourceFilePath, filePath, referencedEntityType, referencedModelName);
                        sourceDoc[referencedEntityType][referencedModelName] = externalFiles[filePath][referencedEntityType][referencedModelName];
                    }
                    else
                    {
                        //recursively check if the model is completely defined.
                        EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, sourceFilePath, currentFilePath, referencedEntityType, referencedModelName);
                        sourceDoc[referencedEntityType][referencedModelName] = currentDoc[referencedEntityType][referencedModelName];
                    }

                }
            }

            //ensure that all the models that are an allOf on the current model in the external doc are also included
            if (entityType != null && modelName != null) {
                var reference = "#/" + entityType + "/" + modelName;
                IEnumerable<JToken> dependentRefs = currentDoc.SelectTokens("$..allOf[*].$ref").Where(r => ((string)r).Contains(reference));
                foreach (JToken dependentRef in dependentRefs)
                {
                    //the JSON Path "definitions.ModelName.allOf[0].$ref" provides the name of the model that is an allOf on the current model
                    string[] refs = dependentRef.Path.Split(new[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    if (refs[1] != null && !visitedEntities.Contains(refs[1]))
                    {
                        //recursively check if the model is completely defined.
                        EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, sourceFilePath, currentFilePath, refs[0], refs[1]);
                        sourceDoc[refs[0]][refs[1]] = currentDoc[refs[0]][refs[1]];
                    }
                }
            }
        }

        public static string Normalize(string path, string swaggerDocument)
        {
            if (!swaggerDocument.IsYaml()) // try parse as markdown if it is not YAML
            {
                Logger.Instance.Log(Category.Info, "Parsing as literate Swagger");
                swaggerDocument = LiterateYamlParser.Parse(swaggerDocument);
            }
            // normalize YAML to JSON since that's what we process
            swaggerDocument = swaggerDocument.EnsureYamlIsJson();
            swaggerDocument = ResolveExternalReferencesInJson(path, swaggerDocument);
            return swaggerDocument;
        }

        public static ServiceDefinition Parse(string path, string swaggerDocument)
        {
            try
            {
                swaggerDocument = Normalize(path, swaggerDocument);
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
                throw ErrorManager.CreateError("{0}. {1}\n{2}", Resources.ErrorParsingSpec, ex.Message,swaggerDocument);
            }
        }
    }
}
