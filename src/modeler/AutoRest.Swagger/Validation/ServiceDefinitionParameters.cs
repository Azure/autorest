// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ServiceDefinitionParameters : TypedRule<Dictionary<string, SwaggerParameter>>
    {
        private const string SubscriptionId = "subscriptionId";
        private const string ApiVersion = "api-version";
        /// <summary>
        /// This rule passes if the parameters section contains both subscriptionId and api-version parameters
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, SwaggerParameter> ParametersMap) =>        
             true == (ParametersMap?.Values.Any(parameter => parameter.Name == SubscriptionId || parameter.Name == ApiVersion));
        
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
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}