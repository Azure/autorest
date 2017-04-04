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
        private static readonly IEnumerable<string> baseResourceModelNames = 
            new List<string>() { "trackedresource", "proxyresource", "resource" };

        private static readonly Regex TrackedResRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);

        // This needs to be deprecated in favor of context.TrackedResources
        public static readonly Regex ResourcePathPattern = new Regex(@"/providers/(?<providerNamespace>[^{/]+)((/(?<resource>[^{/]+)/)((?<resourceName>[^/]+)))+(/(?<resource>[^{/]+))");

        private static readonly Regex resourceProviderPathPattern = new Regex(@"/providers/(?<resPath>[^{/]+)/", RegexOptions.IgnoreCase);

        // This needs to be deprecated in favor of context.TrackedResources
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

            // Get all models that are returned by PUT operations (200/201 response)
            var putOperationsResponseModels = GetOperationResponseModels("put", serviceDefinition);
            putOperationsResponseModels = putOperationsResponseModels.Union(GetOperationResponseModels("put", serviceDefinition, "201"));

            // Get all models that 'allOf' on models that are named 'Resource' and are returned by any GET operation
            var getOperationsResponseModels = GetOperationResponseModels("get", serviceDefinition);

            getOperationsResponseModels =
                getOperationsResponseModels.Where(modelName => serviceDefinition.Definitions.ContainsKey(modelName))
                                           .Where(modelName => IsAllOfOnModelNames(modelName, serviceDefinition.Definitions, new List<string>() { "Resource" }));

            var resourceModels = putOperationsResponseModels.Union(getOperationsResponseModels);

            // Pick all models other than the ones that have already been determined to be resources
            // then pick all models that allOf on xmsAzureResourceModels at any level of hierarchy
            var modelsAllOfOnXmsAzureResources = serviceDefinition.Definitions.Keys.Except(resourceModels)
                                                    .Where(modelName => !(IsBaseResourceModelName(modelName))
                                                                        && serviceDefinition.Definitions.ContainsKey(modelName)
                                                                        && IsAllOfOnModelNames(modelName, serviceDefinition.Definitions, xmsAzureResourceModels));
            
            // return the union 
            return resourceModels.Union(modelsAllOfOnXmsAzureResources);

        }

        /// <summary>
        /// checks if a model is a base resource type (resource, trackedresource or proxyresource)
        /// </summary>
        /// <param name="modelName">model name to check</param>
        /// <returns> true if model is a base resource type </returns>
        public static bool IsBaseResourceModelName(string modelName) => baseResourceModelNames.Contains(modelName.ToLower());

        /// <summary>
        /// Returns the cumulative list of all 'allOfed' references for a model
        /// </summary>
        /// <param name="modelName">model for which to determine the model hierarchy</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of 'allOfed' models</param>
        public static IEnumerable<string> EnumerateModelHierarchy(string modelName, Dictionary<string, Schema> definitions)
        {
            if (!definitions.ContainsKey(modelName)) return new List<string>();

            IEnumerable<string> modelHierarchy = new List<string>() { modelName };

            // If schema has no allOfs, return 
            var modelSchema = definitions[modelName];
            if (modelSchema.AllOf?.Any() != true) return modelHierarchy;

            // for each allOf in the schema, recursively pick the models
            var allOfs = modelSchema.AllOf.Select(allOfSchema => allOfSchema.Reference?.StripDefinitionPath()).Where(modelRef => !string.IsNullOrEmpty(modelRef));
            return modelHierarchy.Union(allOfs.SelectMany(allOf => EnumerateModelHierarchy(allOf, definitions))).ToList();
        }

        /// <summary>
        /// Returns the cumulative list of all properties found in the entire model hierarchy
        /// </summary>
        /// <param name="modelName">model for which to check the  properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <returns>List of properties found in model hierarchy</returns>
        private static IEnumerable<KeyValuePair<string, Schema>> EnumerateProperties(string modelName, Dictionary<string, Schema> definitions)
        {
            var modelsToCheck = EnumerateModelHierarchy(modelName, definitions);
            var propertiesList = new List<KeyValuePair<string, Schema>>();
            foreach (var modelRef in modelsToCheck)
            {
                if (!definitions.ContainsKey(modelRef) || definitions[modelRef].Properties?.Any() != true) continue;

                propertiesList = propertiesList.Union(definitions[modelRef].Properties).ToList();
            }
            return propertiesList;
        }

        /// <summary>
        /// Returns the cumulative list of all required properties found in the entire model hierarchy
        /// </summary>
        /// <param name="modelName">model for which to check the required properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of required properties found in model hierarchy</param>
        private static IEnumerable<string> EnumerateRequiredProperties(string modelName, Dictionary<string, Schema> definitions)
        {
            var modelsToCheck = EnumerateModelHierarchy(modelName, definitions);
            var propertiesList = new List<string>();
            foreach (var modelRef in modelsToCheck)
            {
                if (!definitions.ContainsKey(modelRef) || definitions[modelRef].Properties?.Any() != true) continue;
                
                propertiesList = propertiesList.Union(definitions[modelRef].Required.Where(reqProp => !string.IsNullOrEmpty(reqProp))).ToList();
            }
            return propertiesList;
        }

        /// <summary>
        /// Returns the cumulative list of all read only properties found in the entire model hierarchy
        /// </summary>
        /// <param name="modelName">model for which to find the read only properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of read only properties found in model hierarchy</param>
        private static IEnumerable<string> EnumerateReadOnlyProperties(string modelName, Dictionary<string, Schema> definitions)
            => EnumerateProperties(modelName, definitions).Where(prop => prop.Value.ReadOnly).Select(prop => prop.Key);


        /// <summary>
        /// Checks if model hierarchy consists of given set of properties
        /// </summary>
        /// <param name="modelName">model for which to check the resource properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of properties to be checked for in a model hierarchy</param>
        /// <returns>true if the model hierarchy contains all of the resource model properties</returns>
        public static bool ContainsProperties(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> propertiesToCheck)
        {
            var propertyList = EnumerateProperties(modelName, definitions);
            return !propertiesToCheck.Except(propertyList.Select(prop=>prop.Key)).Any();
        }

        /// <summary>
        /// Checks if model hierarchy consists of given set of required properties
        /// </summary>
        /// <param name="modelName">model for which to check the resource properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of required properties to be checked for in a model hierarchy</param>
        /// <returns>true if the model hierarchy contains all of the required properties</returns>
        public static bool ContainsRequiredProperties(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> requiredPropertiesToCheck)
        {
            var propertyList = EnumerateRequiredProperties(modelName, definitions);
            return !requiredPropertiesToCheck.Except(propertyList).Any();
        }

        /// <summary>
        /// Checks if model hierarchy consists of given set of read only properties
        /// </summary>
        /// <param name="modelName">model for which to check the resource properties</param>
        /// <param name="definitions">dictionary of model definitions</param>
        /// <param name="propertyList">List of read only properties to be checked for in a model hierarchy</param>
        /// <returns>true if the model hierarchy contains all of the read only properties</returns>
        public static bool ContainsReadOnlyProperties(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> readOnlyPropertiesToCheck)
        {
            var propertyList = EnumerateRequiredProperties(modelName, definitions);
            return !readOnlyPropertiesToCheck.Except(propertyList).Any();
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
        /// <param name="allOfedModels">list of allOfed models</param>
        /// <returns>true if given model allOfs on given allOf list at any level of hierarchy</returns>
        public static bool IsAllOfOnModelNames(string modelName, Dictionary<string, Schema> definitions, IEnumerable<string> allOfedModels)
        {
            // if the model being tested belongs to the allOfed list, return false
            // if model can't be found in definitions we can't verify
            // if model does not have any allOfs, return early 
            if (allOfedModels.Contains(modelName) || !definitions.ContainsKey(modelName) || definitions[modelName]?.AllOf?.Any() != true)
            {
                return false;
            }

            var modelHierarchy = EnumerateModelHierarchy(modelName, definitions);
            // if the given model is allOfing on any of the given models, return true
            return allOfedModels.Intersect(modelHierarchy).Any();
        }


        /// <summary>
        /// For a given set of resource models evaluates which models are tracked and returns those
        /// </summary>
        /// <param name="resourceModels">list of resourceModels from which to evaluate the tracked resources</param>
        /// <param name="definitions">the dictionary of model definitions</param>
        /// <returns>list of tracked resources</returns>
        public static IEnumerable<string> GetTrackedResources(IEnumerable<string> resourceModels, Dictionary<string, Schema> definitions) 
            => resourceModels.Where(resModel => ContainsRequiredProperties(resModel, definitions, new List<string>() { "location" }));


        /// <summary>
        /// Determines if an operation is xms pageable operation
        /// </summary>
        /// <param name="op">Operation for which to check the x-ms-pageable extension</param>
        /// <returns>true if operation is x-ms-pageable</returns>
        public static bool IsXmsPageableResponseOperation(Operation op) => (op.Extensions?.GetValue<object>(XmsPageable) != null);

        /// <summary>
        /// Determines if an operation returns an object of array type
        /// </summary>
        /// <param name="op">Operation for which to check the x-ms-pageable extension</param>
        /// <param name="serviceDefinition">Service definition that contains the operation</param>
        /// <returns>true if operation returns an array type</returns>
        public static bool IsArrayTypeResponseOperation(Operation op, ServiceDefinition entity)
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


        public static bool IsXmsPageableOrArrayTypeResponseOperation(Operation op, ServiceDefinition entity) => 
            (IsXmsPageableResponseOperation(op) || IsArrayTypeResponseOperation(op, entity));
        
        /// <summary>
        /// Returns all operations that match the httpverb
        /// </summary>
        /// <param name="id">httpverb to check for</param>
        /// <param name="paths">paths in which to find the operations with given verb</param>
        /// <returns>list if operations that match the httpverb</returns>
        private static IEnumerable<Operation> SelectOperationsFromPaths(string id, Dictionary<string, Dictionary<string, Operation>> paths)
            => paths.Values.SelectMany(pathObjs=>pathObjs.Where(pair => pair.Key.ToLower().Equals(id.ToLower())).Select(pair => pair.Value));

        /// <summary>
        /// Returns whether a string follows camel case style, allowing for 2 consecutive upper case characters for acronyms.
        /// </summary>
        /// <param name="name">String to check for style</param>
        /// <returns>true if "name" follows camel case style (allows for 2 consecutive upper case characters), false otherwise.</returns>
        public static bool isNameCamelCase(string name)
        {
            Regex propNameRegEx = new Regex(@"^[a-z0-9\$-]+([A-Z]{1,2}[a-z0-9\$-]+)+$|^[a-z0-9\$-]+$|^[a-z0-9\$-]+([A-Z]{1,2}[a-z0-9\$-]+)*[A-Z]{1,2}$");
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

        public static bool ListByXCheck(IEnumerable<Operation> getOperations, Regex regEx, string definitionKey, Dictionary<string, Schema> definitions)
        {
            return getOperations.Any(operation =>
                       regEx.IsMatch(operation.OperationId) &&
                       IsXmsPageableResponseOperation(operation) &&
                       operation.Responses.Any(
                           response => response.Key.Equals("200") &&
                           IsArrayOf(response.Value.Schema?.Reference, definitionKey, definitions))
                    );
        }

        private static bool IsArrayOf(string reference, string referenceToMatch, Dictionary<string, Schema> definitions)
        {
            if (reference == null)
                return false;

            Schema schema = Schema.FindReferencedSchema(reference, definitions);
            return schema.Properties.Any(property => property.Value.Type == DataType.Array && (bool)property.Value.Items?.Reference?.EndsWith("/" + referenceToMatch));
        }

        /// <summary>
        /// Returns array of resource providers
        /// </summary>
        /// <param name="paths">Dictionary of paths to look for</param>
        /// <returns>Array of resource providers</returns>
        public static IEnumerable<string> GetResourceProviders(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            IEnumerable<string> resourceProviders = paths?.Keys.SelectMany(path => resourceProviderPathPattern.Matches(path)
                                                    .OfType<Match>()
                                                    .Select(match => match.Groups["resPath"].Value.ToString()))
                                                    .Distinct()
                                                    .ToList();

            return resourceProviders;
        }
    }
}
