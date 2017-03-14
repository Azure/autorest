// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

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
        private static readonly Regex TrackedResRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);

        public static bool IsTrackedResource(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.AllOf != null)
            {
                foreach (Schema item in schema.AllOf)
                {
                    if (TrackedResRegEx.IsMatch(item.Reference))
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
