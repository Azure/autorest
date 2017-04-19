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
        public virtual string Id => "!!! implement me and make me abstract !!!";


        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public virtual ServiceDefinitionDocumentType OpenApiDocumentValidationType => ServiceDefinitionDocumentType.Default;

        /// <summary>
        /// When to apply the validation rule, before or after it has been merged as a part of its composite document
        /// By default consider all rules to be applied for After only
        /// </summary>
        public virtual ServiceDefinitionMergeState ValidationRuleMergeState => ServiceDefinitionMergeState.After;

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public virtual ValidationCategory ValidationCategory => ValidationCategory.None; // !!! implement me and make me abstract !!!

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
