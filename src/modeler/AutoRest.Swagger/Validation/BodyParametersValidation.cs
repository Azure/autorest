// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swagger.Validation.Core;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Core.Logging;
using System;

namespace AutoRest.Swagger.Validation
{
    public class BodyParametersValidation : TypedRule<SwaggerParameter>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2063";

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
        public override string MessageTemplate => Resources.BodyParametersNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validates if the 'body' parameter is named 'parameters'.
        /// </summary>
        /// <param name="swaggerParameter"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerParameter swaggerParameter) =>
            (swaggerParameter.In != ParameterLocation.Body) || (swaggerParameter.Name.Equals("parameters", StringComparison.CurrentCultureIgnoreCase));
    }
}
