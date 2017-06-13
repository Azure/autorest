// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class SubscriptionIdParameterInOperations : TypedRule<SwaggerParameter>
    {
        private const string SubscriptionId = "subscriptionid";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2014";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;


        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

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


        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.SDKImpactingChanges;

    }
}
