// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System;
using System.Linq;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class SecurityDefinitionsStructure : TypedRule<Dictionary<string, SecurityDefinition>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2054";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.SecurityDefinitionsStructureValidation;

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
        /// Checks for the presence and existence of the security definiton
        /// </summary>
        /// <param name="securityDefinitions"></param>
        /// <param name="context">The rule context</param>
        /// <returns>List of ValidationMessages</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, SecurityDefinition> securityDefinitions, RuleContext context)
        {
            if (securityDefinitions.Count != 1)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Parent.Path), this);
            }
            else if (!securityDefinitions.Any(sdPair =>
                 sdPair.Key.Equals("azure_auth", StringComparison.CurrentCultureIgnoreCase)
                 && IsSecurityDefinitionModelValid(sdPair.Value)))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this);
            }
        }

        private bool IsSecurityDefinitionModelValid(SecurityDefinition securityDefinition)
        {
            return (
                securityDefinition.SecuritySchemeType == SecuritySchemeType.OAuth2 &&
                securityDefinition.AuthorizationUrl.Equals("https://login.microsoftonline.com/common/oauth2/authorize", StringComparison.CurrentCultureIgnoreCase) &&
                securityDefinition.Flow == OAuthFlow.Implicit &&
                !String.IsNullOrEmpty(securityDefinition.Description) &&
                IsSecurityDefinitionScopesValid(securityDefinition.Scopes)
              );
        }

        private bool IsSecurityDefinitionScopesValid(Dictionary<string, string> scopes)
        {
            if(scopes?.Count != 1)
            {
                return false;
            }

            return scopes.Where(scope =>
                    scope.Key.Equals("user_impersonation", StringComparison.CurrentCultureIgnoreCase)
                &&  !String.IsNullOrEmpty(scope.Value)
            ).Any();
        }
    }
}