// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class ParameterizeProperties : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex ProviderRegex = new Regex(@"Subscriptions\/\{.+\}\/ResourceGroups\/\{.+\}\/providers\/([^\/]+)(?<typenamesandvalues>[^?]+)([\?]?.+)?$", RegexOptions.IgnoreCase);
        
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2061";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.DataPlane;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            var serviceDefinition = (ServiceDefinition)context.Root;

            foreach (var pathObj in entity)
            {
                var path = pathObj.Key.Trim('/');
                var match = ProviderRegex.Match(path);
                
                // if url is not of the providers pattern, skip
                if (!match.Success)
                {
                    continue;
                }

                var typeValueTokens = match.Groups["typenamesandvalues"].Value.Trim('/').Split('/').Where((item, index) => index % 2 != 0);
                typeValueTokens = typeValueTokens.Where(token => !(token.Contains("{") && token.Contains("}")));
                if (typeValueTokens.Any())
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(pathObj.Key)), this, string.Join(", ", typeValueTokens));
                }
            }
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Type values \"{0}\" have default value(s), please consider parameterizing them";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;
    }
}





