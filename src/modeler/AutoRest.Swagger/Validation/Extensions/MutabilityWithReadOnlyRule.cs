// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class MutabilityWithReadOnlyRule : MutabilityValidValuesRule
    {
        /// <summary>
        /// Array of valid values for x-ms-mutability extension when property is marked as "readonly": true.
        /// </summary>
        protected readonly string[] ValidValuesForReadOnlyProperty = { "read" };

        /// <summary>
        /// An x-ms-mutability extension passes this rule if it has only valid possible values in context of Read Only property.
        /// </summary>
        /// <param name="mutable">mutability extension object.</param>
        /// <param name="context">Rule context.</param>
        /// <param name="formatParameters">array of invalid parameters to be returned.</param>
        /// <returns><c>true</c> if all values for x-ms-mutability are valid in context of Read Only property, otherwise <c>false</c>.</returns>
        /// <remarks>This rule corresponds to M2006.</remarks>
        public override bool IsValid(object mutable, RuleContext context, out object[] formatParameters) => 
            ValidateMutabilityValuesWithReadOnlyProperty(mutable, context, out formatParameters);

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.InvalidMutabilityValueForReadOnly;

        /// <summary>
        /// Verify that mutability values are valid in context of Read Only property.
        /// </summary>
        /// <param name="mutable">mutability extension object.</param>
        /// <param name="context">Rule context.</param>
        /// <param name="formatParameters">array of invalid parameters to be returned.</param>
        /// <returns><c>true</c> if all values for x-ms-mutability are valid in context of Read Only property, otherwise <c>false</c>.</returns>
        private bool ValidateMutabilityValuesWithReadOnlyProperty(object mutable, RuleContext context, out object[] formatParameters)
        {
            string[] values = ((Newtonsoft.Json.Linq.JArray)mutable).ToObject<string[]>();
            string[] invalidValues = null;

            var resolver = new SchemaResolver(context?.GetServiceDefinition());
            Schema schema = resolver.Unwrap(context?.GetFirstAncestor<Schema>());

            if (schema.ReadOnly)
            {
                // Property with "readOnly": true must only have "read" value in x-ms-mutability extension.
                invalidValues = values.Except(ValidValuesForReadOnlyProperty, StringComparer.OrdinalIgnoreCase).ToArray();
            }
            else
            {
                // Property with "readOnly": false must have more than "read" value in x-ms-mutability extension.
                if (values.Length == 1)
                {
                    invalidValues = values.Contains(ValidValuesForReadOnlyProperty[0], StringComparer.OrdinalIgnoreCase) ? 
                        ValidValuesForReadOnlyProperty : new string[0];
                }
            }

            bool isValid = invalidValues == null || invalidValues.Length == 0;
            formatParameters = isValid ? new object[0] : new string[] { String.Join(",", invalidValues) };

            return isValid;
        }
    }
}
