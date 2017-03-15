// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace AutoRest.Swagger.Model.Utilities
{
    public static class ValidationUtilities
    {
        private static readonly string XmsPageable = "x-ms-pageable";
        private static readonly Regex ResRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);

        public static bool IsTrackedResource(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.AllOf != null)
            {
                foreach (Schema item in schema.AllOf)
                {
                    if (ResRegEx.IsMatch(item.Reference))
                    {
                        return true;
                    }
                    else
                    {
                        return IsTrackedResource(Schema.FindReferencedSchema(item.Reference, definitions), definitions);
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Populates a list of 'Resource' models found in the service definition
        /// </summary>
        /// <param name="serviceDefinition">serviceDefinition for which to populate the resources</param>
        /// <returns>List of resource models</returns>
        public static IEnumerable<string> GetResourceModels(ServiceDefinition serviceDefinition)
        {
            // Get all models that are returned by PUT operations (200 response)
            var putOperations = GetOperationsByRequestMethod("put", serviceDefinition);
            var putResponseModelNames = putOperations.Select(op => op.Responses["200"]?.Schema?.Reference.StripDefinitionPath()).Where(modelName => string.IsNullOrEmpty(modelName));

            // Get all models that 'allOf' on models that are named 'Resource' and are returned by any GET operation
            var getOperationsResponseModels = GetResponseModelDefinitions(serviceDefinition);
            var modelsAllOfOnResource =
                getOperationsResponseModels.Where(modelName => serviceDefinition.Definitions.ContainsKey(modelName))
                                           .Where(modelName => IsAllOfOnModelNamedResource(modelName, serviceDefinition.Definitions));
            
            // Get all models that have the "x-ms-azure-resource" extension set on them
            var xmsAzureResourceModels =
                serviceDefinition.Definitions
                    .Where(defPair =>
                            defPair.Value.Extensions?.ContainsKey("x-ms-azure-resource") == true &&
                            defPair.Value.Extensions["x-ms-azure-resource"].Equals(true))
                    .Select(defPair => defPair.Key);

            // set of base resource models is the union of all three aboce
            var baseResourceModels = putResponseModelNames.Union(modelsAllOfOnResource).Union(xmsAzureResourceModels);

            // for every model in definitions, recurse its allOfs and discover if there is a baseResourceModel reference
            foreach (var modelName in serviceDefinition.Definitions.Keys)
            {
                // make sure we are excluding models which have the x-ms-azure-resource extension set on them
                if (!xmsAzureResourceModels.Contains(modelName) && IsAllOfOnResourceTypeModel(modelName, serviceDefinition.Definitions, baseResourceModels))
                {
                    yield return modelName;
                }
            }
        }

        /// <summary>
        /// For a given model determines if it allOfs on a model named 'Resource'
        /// </summary>
        /// <param name="modelName">model for which to check the allOfs</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <returns>List of resource models</returns>
        public static bool IsAllOfOnModelNamedResource(string modelName, Dictionary<string, Schema> definitions)
        {
            if (!definitions.ContainsKey(modelName)) return false;

            var modelSchema = definitions[modelName];

            if (modelSchema.AllOf?.Any() != true) return false;

            if (modelSchema.AllOf != null)
            {
                foreach (Schema item in modelSchema.AllOf)
                {
                    if (ResRegEx.IsMatch(item.Reference))
                    {
                        return true;
                    }
                    else
                    {
                        return IsAllOfOnModelNamedResource(item.Reference, definitions);
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// For a given model, recursively traverses its allOfs and checks if any of them refer to 
        /// the base resourceModels
        /// </summary>
        /// <param name="modelName">model for which to determine if it is resource model type</param>
        /// <param name="definitions">dictionary that contains model definitions</param>
        /// <param name="baseResourceModels">the list of base resource models</param>
        /// <returns>true if model is of resource model type</returns>
        public static bool IsAllOfOnResourceTypeModel(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> baseResourceModels)
        {
            // if model can't be found in definitions we can't verify
            if (!definitions.ContainsKey(modelName)) return false;
            
            // if model does not have any allOfs, return early 
            if (definitions[modelName]?.AllOf?.Any() != true) return false;

            // if model allOfs on a base resource type, return true
            if (definitions[modelName].AllOf.Select(modelRef => modelRef.Reference.StripDefinitionPath()).Intersect(baseResourceModels).Any()) return true;

            // when all else fails, recurse into allOfed references, just check the first reference since we only support one
            return IsAllOfOnResourceTypeModel(definitions[modelName].AllOf.First().Reference.StripDefinitionPath(), definitions, baseResourceModels);
        }


        /// <summary>
        /// For a given set of resource models evaluates which models are tracked and returns those
        /// </summary>
        /// <param name="resourceModels">list of resourceModels from which to evaluate the tracked resources</param>
        /// <param name="definitions">the dictionary of model definitions</param>
        /// <returns>list of tracked resources</returns>
        public static IEnumerable<string> GetTrackedResources(IEnumerable<string> resourceModels, Dictionary<string, Schema> definitions) =>
            resourceModels.Where(resModel => ContainsLocationProperty(resModel, definitions));


        /// <summary>
        /// For a given set of resource models evaluates which models are tracked and returns those
        /// </summary>
        /// <param name="modelName">model for which to check the 'location' property</param>
        /// <param name="definitions">dictionary containing the model definitions</param>
        /// <returns>list of tracked resources</returns>
        private static bool ContainsLocationProperty(string modelName, Dictionary<string, Schema> definitions)
        {
            // if model name is null or empty or not found in definitions, return false
            if (string.IsNullOrEmpty(modelName) || !definitions.ContainsKey(modelName)) return false;

            // if model schema is null, return false
            var modelSchema = definitions[modelName];
            if (modelSchema == null) return false;

            // if model properties has a property named location, return true
            if (modelSchema.Properties?.ContainsKey("location") == true)  return true;

            var allOfedModels = modelSchema.AllOf?.Select(modelRef => modelRef.Reference).Where(modelRef=>!string.IsNullOrEmpty(modelRef));
            if (allOfedModels != null && allOfedModels.Any())
            {
                foreach (var modelRef in allOfedModels)
                {
                    // if any of the allOfed models have a property named location, return true
                    if (ContainsLocationProperty(modelRef, definitions)) return true;
                }
            }

            // when all else fails, return false
            return false;
        }

        public static bool IsXmsPageableOrArrayResponseOperation(Operation op, ServiceDefinition entity)
        {
            // if xmspageable type, return true
            if (op.Extensions.GetValue<object>(XmsPageable) != null) return true;

            // if a success response is not defined, we have nothing to check, return false
            if (op.Responses?.ContainsKey("200") !=true) return false;

            // if we have a non-null response schema, and the schema is of type array, return true
            if (op.Responses["200"]?.Schema?.Reference?.Equals(string.Empty) == false)
            {
                var modelLink = op.Responses["200"].Schema.Reference;
                // if the object has more than 2 properties, we can assume its a composite object
                // that does not represent a collection of some type
                if ((entity.Definitions[modelLink.StripDefinitionPath()].Properties?.Values?.Count ?? 2) >= 2)
                {
                    return false;
                }

                // if the object is an allof on some other object, let's consider it to be a composite object
                if (entity.Definitions[modelLink.StripDefinitionPath()].AllOf != null)
                {
                    return false;
                }

                if (entity.Definitions[modelLink.StripDefinitionPath()].Properties?.Values?.Any(type => type.Type == DataType.Array)??false)
                {
                    return true;
                }
            }

            return false;
        }

        public static IEnumerable<Operation> GetOperationsByRequestMethod(string id, ServiceDefinition serviceDefinition)
        {
            return serviceDefinition.Paths.Values.Select(pathObj => pathObj.Where(pair=> pair.Key.ToLower().Equals(id.ToLower()))).SelectMany(pathPair => pathPair.Select(opPair => opPair.Value));
        }

        public static IEnumerable<string> GetResponseModelDefinitions(ServiceDefinition serviceDefinition)
        {
            // for every path, check its response object and get its model definition
            var respDefinitions = serviceDefinition.Paths.SelectMany(
                                    pathPair => pathPair.Value.Select(
                                        pathObj => pathObj.Value.Responses?.ContainsKey("200") == true ? pathObj.Value.Responses["200"]?.Schema?.Reference?.StripDefinitionPath() : string.Empty));

            respDefinitions = respDefinitions.Concat(
                                    serviceDefinition.CustomPaths.SelectMany(
                                        pathPair => pathPair.Value.Select(
                                            pathObj => pathObj.Value.Responses?.ContainsKey("200") == true ? pathObj.Value.Responses["200"]?.Schema?.Reference?.StripDefinitionPath() : string.Empty)));

            respDefinitions = respDefinitions.Where(def => !string.IsNullOrWhiteSpace(def)).Distinct();

            return respDefinitions;
        }

        /// <summary>
        /// Returns whether a string follows camel case style.
        /// </summary>
        /// <param name="name">String to check for style</param>
        /// <returns>true if "name" follows camel case style, false otherwise.</returns>
        public static bool isNameCamelCase(string name)
        {
            Regex propNameRegEx = new Regex(@"^[a-z0-9]+([A-Z][a-z0-9]+)+|^[a-z0-9]+$|^[a-z0-9]+[A-Z]$");
            return (propNameRegEx.IsMatch(name));
        }

        /// <summary>
        /// Returns a suggestion of camel case styled string based on the string passed as parameter.
        /// </summary>
        /// <param name="name">String to convert to camel case style</param>
        /// <returns>A string that conforms with camel case style based on the string passed as parameter.</returns>
        public static string ToCamelCase(string name)
        {
            StringBuilder sb = new StringBuilder(name);
            if (sb.Length > 0)
            {
                sb[0] = sb[0].ToString().ToLower()[0];
            }
            bool firstUpper = true;
            for (int i = 1; i < name.Length; i++)
            {
                if (char.IsUpper(sb[i]) && firstUpper)
                {
                    firstUpper = false;
                }
                else
                {
                    firstUpper = true;
                    if (char.IsUpper(sb[i]))
                    {
                        sb[i] = sb[i].ToString().ToLower()[0];
                    }
                }
            }
            return sb.ToString();
        }
    }
}
