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
    public class SecurityDefinitionsStructureValidation : TypedRule<Dictionary<string, SecurityDefinition>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2054";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of breaking change implementing this rule can cause.
        /// </summary>
        public virtual ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceBreakingChanges;

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
        /// Checks for the presence and existence of the security definiton
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, SecurityDefinition> securityDefinitions)        
        {
            if (securityDefinitions.Count != 1)
            {
                return false;
            }

            return securityDefinitions.Where(sdPair =>
                sdPair.Key.Equals("azure_auth", StringComparison.CurrentCultureIgnoreCase)
            &&  IsSecurityDefinitionModelValid(sdPair.Value)).Any();
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