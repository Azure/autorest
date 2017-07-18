// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using System;

namespace AutoRest.Swagger.Validation.Core
{
    /// <summary>
    /// Defines validation logic for an object
    /// </summary>
    public abstract class Rule
    {
        protected Rule()
        {
        }

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public abstract string Id { get; }

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public abstract ServiceDefinitionDocumentType ServiceDefinitionDocumentType { get; }

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public abstract ServiceDefinitionDocumentState ValidationRuleMergeState { get; }

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public abstract ValidationCategory ValidationCategory { get; }

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public virtual ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.None;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public abstract string MessageTemplate { get; }

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public abstract Category Severity { get; }

        /// <summary>
        /// Returns the validation messages resulting from validating this object
        /// </summary>
        /// <param name="entity">The object to validate</param>
        /// <returns></returns>
        public abstract IEnumerable<ValidationMessage> GetValidationMessages(object entity, RuleContext context);
    }
}
