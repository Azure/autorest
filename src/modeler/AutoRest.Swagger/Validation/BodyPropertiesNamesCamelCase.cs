// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
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
        public override string Id => "R3014";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

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
                    for (var i=0; i<path[operation].Parameters.Count; ++i)
                    {
                        if (path[operation].Parameters[i].In == ParameterLocation.Body && path[operation].Parameters[i].Schema?.Properties != null)
                        {
                            foreach (KeyValuePair<string, Schema> prop in path[operation].Parameters[i].Schema?.Properties)
                            {
                                if (!ValidationUtilities.IsODataProperty(prop.Key) && !ValidationUtilities.IsNameCamelCase(prop.Key))
                                {
                                    yield return new ValidationMessage(new FileObjectPath(context.File, 
                                        context.Path.AppendProperty(operation).AppendProperty("parameters").AppendIndex(i).AppendProperty("schema").AppendProperty("properties").AppendProperty(prop.Key)), 
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