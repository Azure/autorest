// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System;
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

            foreach(KeyValuePair<string, SecurityDefinition> sd in securityDefinitions)
            {
                SecurityDefinition securityDefinition = sd.Value;
                if(!sd.Key.Equals("azure_auth", StringComparison.CurrentCultureIgnoreCase) || !IsSecurityDefinitionModelValid(securityDefinition))
                {
                    return false;
                }
            }

            return true;
        }

        private bool IsSecurityDefinitionModelValid(SecurityDefinition securityDefinition)
        {
            if(
                securityDefinition.SecuritySchemeType == SecuritySchemeType.OAuth2 && 
                securityDefinition.AuthorizationUrl.Equals("https://login.microsoftonline.com/common/oauth2/authorize", StringComparison.CurrentCultureIgnoreCase) &&
                securityDefinition.Flow == OAuthFlow.Implicit &&
                !String.IsNullOrEmpty(securityDefinition.Description) &&
                IsSecurityDefinitionScopesValid(securityDefinition.Scopes)
              )
            {
                return true;
            }

            return false;
        }

        private bool IsSecurityDefinitionScopesValid(Dictionary<string, string> scopes)
        {
            if(scopes == null || scopes.Count != 1)
            {
                return false;
            }

            foreach(KeyValuePair<string, string> scope in scopes)
            {
                if(!scope.Key.Equals("user_impersonation", StringComparison.CurrentCultureIgnoreCase) || String.IsNullOrEmpty(scope.Value))
                {
                    return false;
                }
            }

            return true;
        }
    }
}