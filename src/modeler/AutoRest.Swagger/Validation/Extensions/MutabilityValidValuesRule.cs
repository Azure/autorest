// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class MutabilityValidValuesRule : MutabilityExtensionRule
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2008";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// Array of valid values for x-ms-mutability extension.
        /// </summary>
        protected readonly string[] ValidValues = { "create", "read", "update" };

        /// <summary>
        /// An x-ms-mutability extension passes this rule if it has only valid possible values.
        /// </summary>
        /// <param name="mutable">mutability extension object.</param>
        /// <param name="context">Rule context.</param>
        /// <param name="formatParameters">array of invalid parameters to be returned.</param>
        /// <returns><c>true</c> if all values for x-ms-mutability are valid, otherwise <c>false</c>.</returns>
        /// <remarks>This rule corresponds to M2008.</remarks>
        public override bool IsValid(object mutable, RuleContext context, out object[] formatParameters) => ValidateMutabilityValues(mutable, context, out formatParameters);

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.InvalidMutabilityValues;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Verify that mutability values are valid.
        /// </summary>
        /// <param name="mutable">mutability extension object.</param>
        /// <param name="context">Rule context.</param>
        /// <param name="formatParameters">array of invalid parameters to be returned.</param>
        /// <returns><c>true</c> if all values for x-ms-mutability are valid, otherwise <c>false</c>.</returns>
        private bool ValidateMutabilityValues(object mutable, RuleContext context, out object[] formatParameters)
        {
            string[] values = ((Newtonsoft.Json.Linq.JArray)mutable).ToObject<string[]>();
            string[] invalidValues = values.Except(ValidValues, StringComparer.OrdinalIgnoreCase).ToArray();
            formatParameters = invalidValues.Length == 0 ? new object[0] : new string[] { String.Join(",", invalidValues) };

            return invalidValues.Length == 0;
        }
    }
}
