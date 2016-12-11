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

            var swaggerDocument = fileSystem.ReadFileAsText(path);
            return Parse(swaggerDocument);
        }

        public static string ResolveExternalReferencesInJson(this string swaggerDocument)
        {
            string result = null;
            JObject swaggerObject = JObject.Parse(swaggerDocument);
            var externalFiles = new Dictionary<string, JObject>();
            externalFiles["currentDocument"] = swaggerObject;
            HashSet<string> visitedEntities = new HashSet<string>();
            EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles);
            result = swaggerObject.ToString();
            return result;
        }

        public static void EnsureCompleteDefinitionIsPresent(HashSet<string> visitedEntities, Dictionary<string, JObject> externalFiles, string entityType = null, string modelName = null, JToken externalDoc = null)
        {
            IEnumerable<JToken> references;
            var currentDoc = externalFiles["currentDocument"];
            if (entityType == null && modelName == null)
            {
                //first call to the recursive function. Hence we will process file references only.
                references = currentDoc.SelectTokens("$..$ref").Where(p => !((string)p).StartsWith("#"));
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
                    if (!Settings.FileSystem.IsCompletePath(filePath))
                    {
                        // Otherwise, root it from the current path
                        filePath = Settings.FileSystem.MakePathRooted(Settings.InputFolder, filePath);
                    }
                    if (!externalFiles.ContainsKey(filePath))
                    {
                        var externalDefinitionString = Settings.FileSystem.ReadFileAsText(filePath);
                        externalFiles[filePath] = JObject.Parse(externalDefinitionString);
                    }
                }

                entityType = entityPath.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries)[1];
                modelName = entityPath.StripDefinitionPath();

                if (currentDoc[entityType][modelName] == null && !visitedEntities.Contains(modelName))
                {
                    visitedEntities.Add(modelName);
                    if (filePath != null)
                    {
                        currentDoc[entityType][modelName] = externalFiles[filePath][entityType][modelName];
                        //recursively check if the model is completely defined.
                        EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, entityType, modelName, externalFiles[filePath]);
                    }
                    else
                    {
                        currentDoc[entityType][modelName] = externalDoc[entityType][modelName];
                        //recursively check if the model is completely defined.
                        EnsureCompleteDefinitionIsPresent(visitedEntities, externalFiles, entityType, modelName, externalDoc);
                    }
                    
                }

                //var refModelName = path.StripDefinitionPath();
                //if (!visitedModels.Contains(refModelName))
                //{
                //    visitedModels.Add(refModelName);
                //    if (currentDoc[entityType][refModelName] == null)
                //    {
                //        currentDoc[entityType][refModelName] = externalDoc[entityType][refModelName];
                //    }
                //    //recursively check if the model is completely defined.
                //    EnsureCompleteDefinitionIsPresent(entityType, refModelName, visitedModels, currentDoc, externalDoc);
                //}
            }
            return;
        }

        public static void EnsureCompleteDefinitionIsPresent2(HashSet<string> visitedModels, Dictionary<string, JObject> externalFiles, JToken currentDoc, JToken externalDoc)
        {

        }
        public static ServiceDefinition Parse(string swaggerDocument)
        {
            try
            {
                if (!swaggerDocument.IsYaml()) // try parse as markdown if it is not YAML
                {
                    Logger.Instance.Log(Category.Info, "Parsing as literate Swagger");
                    swaggerDocument = new LiterateYamlParser().Parse(swaggerDocument, true);
                }
                // normalize YAML to JSON since that's what we process
                swaggerDocument = swaggerDocument.EnsureYamlIsJson();
                swaggerDocument = ResolveExternalReferencesInJson(swaggerDocument);
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
                //JObject jObject = JObject.Parse(swaggerDocument);
                //foreach (JValue value in jObject.SelectTokens("$..$ref"))
                //{
                //    var path = (string)value;
                //    if (path != null && path.Split(new[] {'#'}, StringSplitOptions.RemoveEmptyEntries).Length == 2)
                //    {
                //        swaggerService.ExternalReferences.Add(path);
                //    }
                //}

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