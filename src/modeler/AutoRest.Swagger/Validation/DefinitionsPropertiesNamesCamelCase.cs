﻿// Copyright (c) Microsoft Corporation. All rights reserved.
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
    public class DefinitionsPropertiesNamesCamelCase : TypedRule<Dictionary<string, Schema>>
    {

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3016";

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

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
        public override string MessageTemplate => Resources.DefinitionsPropertiesNameCamelCase;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.Default;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// Validates whether property names are camelCase for definitions.
        /// </summary>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (definition.Value.Properties != null)
                {
                    foreach (KeyValuePair<string, Schema> prop in definition.Value.Properties)
                    {
                        if (!ValidationUtilities.IsODataProperty(prop.Key) && !ValidationUtilities.IsNameCamelCase(prop.Key))
                        {
                            yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(definition.Key).AppendProperty("properties").AppendProperty(prop.Key)), this, prop.Key, definition.Key, ValidationUtilities.GetCamelCasedSuggestion(prop.Key));
                        }
                    }
                }
            }
        }
    }
}