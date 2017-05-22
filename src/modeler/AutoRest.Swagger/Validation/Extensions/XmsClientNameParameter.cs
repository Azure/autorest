// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if the name of parameter and x-ms-client-name(if exists) does not match.
    /// </summary>
    public class XmsClientNameParameter : TypedRule<SwaggerParameter>
    {
        private static readonly string extensionToCheck = "x-ms-client-name";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2012";

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
        public override string MessageTemplate => Resources.XmsClientNameInvalid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Validates if the name of parameter model and x-ms-client-name(if exists) does not match.
        /// </summary>
        /// <param name="parameter">Paramter model.</param>
        /// <param name="context">Rule context.</param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(SwaggerParameter parameter, RuleContext context)
        {
            if (parameter?.Extensions?.ContainsKey(extensionToCheck) == true)
            {
                if (parameter.Extensions[extensionToCheck].ToString().EqualsIgnoreCase(parameter.Name))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, parameter.Name);
                }
            }
        }
    }
}
