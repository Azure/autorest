// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using System;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// Defines validation logic for an object
    /// </summary>
    public abstract class Rule
    {
        protected Rule()
        {
        }

        public virtual string Id => "!!! implement me and make me abstract !!!";

        public ValidationCategory ValidationCategory => ((ValidationCategory)0); // !!! implement me and make me abstract !!!

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
