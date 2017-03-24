// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if the name of parameter and x-ms-client-name(if exists) does not match.
    /// </summary>
    public class XmsClientNameParameterValidation : TypedRule<SwaggerParameter>
    {
        private static readonly string extensionToCheck = "x-ms-client-name";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2013";

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
        public override string MessageTemplate => Resources.XmsClientNameInValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Validates if the name of property and x-ms-client-name(if exists) does not match.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns>true if the validation succeeds. false otherwise.</returns>
        public override bool IsValid(SwaggerParameter parameter)
        {
            if(parameter.Extensions != null && parameter.Extensions.Count != 0)
            {
                string valueToCompare = (string)parameter.Extensions.GetValueOrNull(extensionToCheck);
                if (valueToCompare != null && valueToCompare.Equals(parameter.Name))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
