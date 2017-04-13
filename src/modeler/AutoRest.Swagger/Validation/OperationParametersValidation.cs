// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class OperationParametersValidation : TypedRule<SwaggerParameter>
    {
        private const string SubscriptionId = "subscriptionid";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2014";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;


        /// <summary>
        /// This rule passes if the parameters are not subscriptionId or api-version
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerParameter Parameter) => 
           (!string.IsNullOrEmpty(Parameter.Reference) || Parameter.Schema != null || Parameter.Name?.ToLower().Equals(SubscriptionId) == false);
        
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.OperationParametersNotAllowedMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

    }
}
