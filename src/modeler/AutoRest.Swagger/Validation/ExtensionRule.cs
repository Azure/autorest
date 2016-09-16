// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// A rule that validates extensions (e.g. x-ms-pageable)
    /// </summary>
    public abstract class ExtensionRule : Rule
    {
        protected abstract string ExtensionName { get; }

        /// <summary>
        /// Overridable method that lets a child rule return multiple validation messages for the <paramref name="entity"/>
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(object entity, RuleContext context)
        {
            object[] formatParams;
            // Only try to validate an object with this extension rule if the extension name matches the key
            if (context.Key == ExtensionName && !IsValid(entity, context, out formatParams))
            {
                yield return new ValidationMessage(this, formatParams);
            }
        }

        /// <summary>
        /// Overridable method that lets a child rule return objects to be passed to string.Format
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="formatParameters"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters", MessageId = "1#")]
        public virtual bool IsValid(object entity, RuleContext context, out object[] formatParameters)
        {
            formatParameters = new object[0];
            return IsValid(entity, context);
        }

        /// <summary>
        /// Overridable method that lets a child rule specify if <paramref name="entity"/> passes validation
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual bool IsValid(object entity, RuleContext context) => IsValid(entity);

        public virtual bool IsValid(object entity) => true;
    }
}
