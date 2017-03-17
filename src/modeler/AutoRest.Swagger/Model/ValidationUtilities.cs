// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swagger;
using AutoRest.Core.Utilities;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Swagger.Validation;

namespace AutoRest.Swagger.Model.Utilities
{
    public static class ValidationUtilities
    {
        private static readonly string XmsPageable = "x-ms-pageable";
        private static readonly Regex UrlResRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);
        private static readonly Regex ResNameRegEx = new Regex(@"Resource$", RegexOptions.IgnoreCase);

        public static bool IsTrackedResource(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.AllOf != null)
            {
                foreach (Schema item in schema.AllOf)
                {
                    if (UrlResRegEx.IsMatch(item.Reference))
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
            if (serviceDefinition.Definitions?.Any() != true)
            {
                return new List<string>();
            }

            var xmsAzureResourceModels = GetXmsAzureResourceModels(serviceDefinition.Definitions);

            // Get all models that are returned by PUT operations (200 response)
            var putOperationsResponseModels = GetOperationResponseModels("put", serviceDefinition).Except(xmsAzureResourceModels);
            // for each putResponseModel, check if the properties "id, type and name" exist anywhere in its heirarchy
            putOperationsResponseModels = putOperationsResponseModels.Where(putRespModel => ContainsProperties(putRespModel, serviceDefinition.Definitions, new List<string>() { "id", "name", "type"}));

            // Get all models that 'allOf' on models that are named 'Resource' and are returned by any GET operation
            var getOperationsResponseModels = GetOperationResponseModels("get", serviceDefinition).Except(xmsAzureResourceModels);
            getOperationsResponseModels = getOperationsResponseModels.Where(putRespModel => ContainsProperties(putRespModel, serviceDefinition.Definitions, new List<string>() { "id", "name", "type"}));

            var modelsAllOfOnResource =
                getOperationsResponseModels.Where(modelName => serviceDefinition.Definitions.ContainsKey(modelName))
                                           .Where(modelName => IsAllOfOnModelNames(modelName, serviceDefinition.Definitions, new List<string>() { "Resource" }));

            var resourceModels = putOperationsResponseModels.Union(getOperationsResponseModels);
            
            // Pick all models other than the ones that have already been determined to be resources
            // or are of type xms azure resource
            var modelsAllOfOnXmsAzureResources = serviceDefinition.Definitions.Keys.Except(resourceModels).Except(xmsAzureResourceModels);

            // Now pick all models that allOf on xmsAzureResourceModels at any level of heirarchy
            modelsAllOfOnXmsAzureResources = modelsAllOfOnXmsAzureResources.Where(modelName => serviceDefinition.Definitions.ContainsKey(modelName)
                                                                                                && IsAllOfOnModelNames(modelName, serviceDefinition.Definitions, xmsAzureResourceModels));
            
            // return the union 
            return resourceModels.Union(modelsAllOfOnXmsAzureResources);

        }

        /// <summary>
        /// Checks whether a model definition has the properties "id, name and type" (which are "Resource" type properties)
        /// anywhere in its heirarchy
        /// </summary>
        /// <param name="modelName">model for which to check the resource properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of properties to be checked for in a model heirarchy</param>
        /// <returns>true if the model heirarchy contains all of the resource model properties</returns>
        private static bool ContainsProperties(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> propertyList)
        {
            if (!definitions.ContainsKey(modelName)) return false;
            var modelSchema = definitions[modelName];

            if (modelSchema.Properties?.Any() == true)
            {
                propertyList = propertyList.Except(modelSchema.Properties.Keys);
                // if all properties are found, return true!
                if (!propertyList.Any()) return true;
            }

            if (modelSchema.AllOf?.Any() != true) return false;

            var modelRefNames = modelSchema.AllOf.Select(modelRefSchema => modelRefSchema.Reference?.StripDefinitionPath())
                                    .Where(modelRef => !string.IsNullOrEmpty(modelRef) && definitions.ContainsKey(modelRef));

            foreach (var modelRef in modelRefNames)
            {
                if (ContainsProperties(modelRef, definitions, propertyList)) return true;
            }

            return false;
        }

        /// <summary>
        /// Gets response models returned by operations with given httpVerb
        /// by default looks at the '200' response 
        /// </summary>
        /// <param name="httpVerb">operation verb for which to determine the response model</param>
        /// <param name="serviceDefinition">service definition containing the operations</param>
        /// <param name="respCode">The response code to look at when fetching models, by default '200'</param>
        /// <returns>list of model names that are returned by all operations matching the httpVerb</returns>
        public static IEnumerable<string> GetOperationResponseModels(string httpVerb, ServiceDefinition serviceDefinition, string respCode = "200")
        {
            var operations = GetOperationsByRequestMethod(httpVerb, serviceDefinition)
                                    .Where(op => op.Responses?.ContainsKey(respCode) == true);
            return operations.Select(op => op.Responses[respCode]?.Schema?.Reference?.StripDefinitionPath())
                                            .Where(modelName => !string.IsNullOrEmpty(modelName));
        }

        /// <summary>
        /// Gets all models that have the x-ms-azure-resource extension set on them
        /// </summary>
        /// <param name="definitions">model definitions in which to find the x-ms-azure-resource extension</param>
        /// <returns>list of model names that have the x-ms-azure-resource extension set on them</returns>
        private static IEnumerable<string> GetXmsAzureResourceModels(Dictionary<string, Schema> definitions)
            => definitions.Where(defPair =>
                            defPair.Value.Extensions?.ContainsKey("x-ms-azure-resource") == true &&
                            defPair.Value.Extensions["x-ms-azure-resource"].Equals(true))
                            .Select(defPair => defPair.Key);


        /// <summary>
        /// For a given model, recursively traverses its allOfs and checks if any of them refer to 
        /// the base resourceModels
        /// </summary>
        /// <param name="modelName">model for which to determine if it is allOfs on given model names</param>
        /// <param name="definitions">dictionary that contains model definitions</param>
        /// <param name="allOfedModels">list allOfed models</param>
        /// <returns>true if given model allOfs on given allOf list at any level of heirarchy</returns>
        public static bool IsAllOfOnModelNames(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> allOfedModels)
        {
            // if the model being tested belongs to the allOfed list, return false
            // if model can't be found in definitions we can't verify
            // if model does not have any allOfs, return early 
            if (allOfedModels.Contains(modelName) || !definitions.ContainsKey(modelName) || definitions[modelName]?.AllOf?.Any() != true)
            {
                return false;
            }
            
            // if model allOfs on any model in the allOfs list, return true
            if (definitions[modelName].AllOf.Select(modelRef => modelRef.Reference.StripDefinitionPath()).Intersect(allOfedModels).Any()) return true;

            // recurse into allOfed references
            foreach (var modelRef in definitions[modelName].AllOf.Select(allofModel => allofModel.Reference?.StripDefinitionPath()).Where(allOfModel => !string.IsNullOrEmpty(allOfModel)))
            {
                if (IsAllOfOnModelNames(modelRef, definitions, allOfedModels)) return true;
            }

            // if all else fails return false
            return false;
        }


        /// <summary>
        /// For a given set of resource models evaluates which models are tracked and returns those
        /// </summary>
        /// <param name="resourceModels">list of resourceModels from which to evaluate the tracked resources</param>
        /// <param name="definitions">the dictionary of model definitions</param>
        /// <returns>list of tracked resources</returns>
        public static IEnumerable<string> GetTrackedResources(IEnumerable<string> resourceModels, Dictionary<string, Schema> definitions) 
            => resourceModels.Where(resModel => ContainsProperties(resModel, definitions, new List<string>() { "location" }));


        // determine if an operation is xms pageable operation
        public static bool IsXmsPageableOperation(Operation op)
        {
            // if xmspageable type, return true
            return (op.Extensions.GetValue<object>(XmsPageable) != null);
        }

        // determine if an operation returns an object of array type
        public static bool IsArrayResponseOperation(Operation op, ServiceDefinition entity)
        {
            // if a success response is not defined, we have nothing to check, return false
            if (op.Responses?.ContainsKey("200") != true) return false;

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

                if (entity.Definitions[modelLink.StripDefinitionPath()].Properties?.Values?.Any(type => type.Type == DataType.Array) ?? false)
                {
                    return true;
                }
            }

            return false;
        }

        // determine if the operation is xms pageable or returns an object of array type
        public static bool IsXmsPageableOrArrayResponseOperation(Operation op, ServiceDefinition entity)
        {
            if (IsXmsPageableOperation(op) || IsArrayResponseOperation(op, entity))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Returns all operations that match the httpverb (from all paths in service definitions)
        /// </summary>
        /// <param name="id">httpverb to check for</param>
        /// <param name="serviceDefinition">service definition in which to find the operations</param>
        /// <param name="includeCustomPaths">whether to include the x-ms-paths</param>
        /// <returns>list if operations that match the httpverb</returns>
        public static IEnumerable<Operation> GetOperationsByRequestMethod(string id, ServiceDefinition serviceDefinition, bool includeCustomPaths = true)
        {
            var pathOperations = SelectOperationsFromPaths(id, serviceDefinition.Paths);
            if (includeCustomPaths)
            {
                pathOperations.Concat(SelectOperationsFromPaths(id, serviceDefinition.CustomPaths));
            }
            return pathOperations;
        }

        /// <summary>
        /// Returns all operations that match the httpverb
        /// </summary>
        /// <param name="id">httpverb to check for</param>
        /// <param name="paths">paths in which to find the operations with given verb</param>
        /// <returns>list if operations that match the httpverb</returns>
        private static IEnumerable<Operation> SelectOperationsFromPaths(string id, Dictionary<string, Dictionary<string, Operation>> paths)
            => paths.Values.SelectMany(pathObjs=>pathObjs.Where(pair => pair.Key.ToLower().Equals(id.ToLower())).Select(pair => pair.Value));

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

        public static IEnumerable<KeyValuePair<string, Schema>> GetArmResources(ServiceDefinition serviceDefinition)
        {
            return serviceDefinition.Definitions.Where(defPair=> defPair.Value.Extensions?.ContainsKey("x-ms-azure-resource")==true && (bool?)defPair.Value.Extensions["x-ms-azure-resource"] == true);
        }

        /// <summary>
        /// Evaluates if the reference is of the provided data type.
        /// </summary>
        /// <param name="reference">reference to evaluate</param>
        /// <param name="definitions">definition list</param>
        /// <param name="dataType">Datatype value to evaluate</param>
        /// <returns>true if the reference is of the provided data type. False otherwise.</returns>
        public static bool IsReferenceOfType(string reference, Dictionary<string, Schema> definitions, Model.DataType dataType)
        {
            if (reference == null)
            {
                return false;
            }

            string definitionName = Extensions.StripDefinitionPath(reference);
            Schema schema = definitions.GetValueOrNull(definitionName);
            if (schema == null)
            {
                return false;
            }

            if (schema.Type == dataType || (schema.Type == null && schema.Reference != null && IsReferenceOfType(schema.Reference, definitions, dataType)))
            {
                return true;
            }

            return false;
        }
    }
}
