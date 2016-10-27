// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// A rule that validates objects of type <typeparamref name="T"/>
    /// </summary>
    /// <typeparam name="T">The type of the object to validate</typeparam>
    public abstract class TypedRule<T> : Rule
    {
        protected TypedRule()
        {
        }

        public sealed override IEnumerable<ValidationMessage> GetValidationMessages(object entity, RuleContext context) => entity is T ? GetValidationMessages((T)entity, context) : Enumerable.Empty<ValidationMessage>();

        /// <summary>
        /// Overridable method that lets a child rule return multiple validation messages for the <paramref name="entity"/>
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual IEnumerable<ValidationMessage> GetValidationMessages(T entity, RuleContext context)
        {
            object[] formatParams;
            if (!IsValid(entity, context, out formatParams))
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
        public virtual bool IsValid(T entity, RuleContext context, out object[] formatParameters)
        {
            formatParameters = new object[0];
            return IsValid(entity, context);
        }

        /// <summary>
        /// Overridable method that lets a child rule specify if <paramref name="entity"/> passes validation
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public virtual bool IsValid(T entity, RuleContext context) => IsValid(entity);

        public virtual bool IsValid(T entity) => true;
    }
}
