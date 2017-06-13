// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class SummaryAndDescriptionMustNotBeSame: TypedRule<Operation>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2023";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.SummaryDescriptionVaidationError;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.DataPlane;

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
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Operation operation, RuleContext context)
        {
            if(operation.Description != null && operation.Summary != null && operation.Description.Trim().Equals(operation.Summary.Trim(), StringComparison.OrdinalIgnoreCase))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, new object[0]);
            }
        }
    }
}
