// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ServiceDefinitionParameters : TypedRule<Dictionary<string, SwaggerParameter>>
    {
        private static readonly string SubscriptionId = "subscriptionId";
        private static readonly string ApiVersion = "api-version";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2014";

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
        public override string MessageTemplate => Resources.ServiceDefinitionParametersMissingMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// This rule passes if the parameters section contains both subscriptionId and api-version parameters
        /// </summary>
        /// <param name="ParametersMap">Dictionary of swagger parameters</param>
        /// <param name="context">Rule context</param>
        /// <param name="formatParameters">Formatted parameters</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, SwaggerParameter> ParametersMap, RuleContext context, out object[] formatParameters)
        {
            formatParameters = new object[0];
            ServiceDefinition serviceDefinition = context.Root;

            return true == (ParametersMap?.Values.Any(parameter => parameter.Name == SubscriptionId || parameter.Name == ApiVersion));
        }
    }
}