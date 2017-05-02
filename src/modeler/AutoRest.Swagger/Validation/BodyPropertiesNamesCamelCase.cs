// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Property names must be camelCase style
    /// </summary>
    public class BodyPropertiesNamesCamelCase : TypedRule<Dictionary<string, Operation>>
    {

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3016";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>;
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.BodyPropertyNameCamelCase;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        ///// <summary>
        ///// Validates whether property names are camelCase in body parameters.
        ///// </summary>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Operation> path, RuleContext context)
        {
            foreach (string operation in path.Keys)
            {
                if (path[operation]?.Parameters != null)
                {
                    foreach (SwaggerParameter param in path[operation].Parameters)
                    {
                        if (param.In == ParameterLocation.Body && param.Schema?.Properties != null)
                        {
                            foreach (KeyValuePair<string, Schema> prop in param.Schema?.Properties)
                            {
                                if (!ValidationUtilities.IsODataProperty(prop.Key) && !ValidationUtilities.IsNameCamelCase(prop.Key))
                                {
                                    Console.Error.WriteLine("Found param {0} at index {1}", param.Name, path[operation].Parameters.IndexOf(param));
                                    yield return new ValidationMessage(new FileObjectPath(context.File, 
                                        context.Path.AppendProperty(operation).AppendProperty("parameters").AppendIndex(path[operation].Parameters.IndexOf(param)).AppendProperty("schema").AppendProperty("properties").AppendProperty(prop.Key)), 
                                        this, prop.Key, ValidationUtilities.GetCamelCasedSuggestion(prop.Key));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}