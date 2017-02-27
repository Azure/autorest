// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class ProvidersPathValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex FullRegex = new Regex(@"\/Subscriptions\/\{.+\}\/ResourceGroups\/\{.+\}\/providers\/[^\/]+(\/[^\/]+\/\{[^\}]+\})*(\/[^\/]+)?([\?]?[^\/]+)*$", RegexOptions.IgnoreCase);
        private readonly Regex ProviderRegex = new Regex(@"Subscriptions\/\{.+\}\/ResourceGroups\/\{.+\}\/providers\/.+$", RegexOptions.IgnoreCase);
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            var serviceDefinition = (ServiceDefinition)context.Root;

            foreach (var pathObj in entity)
            {
                // if url is not of the providers pattern or if it ends with /operations, skip
                if (!ProviderRegex.IsMatch(pathObj.Key))
                {
                    continue;
                }

                if (!FullRegex.IsMatch(pathObj.Key.TrimEnd('/')))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, pathObj.Key);
                }
            }
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Path {0} must follow the pattern Subscriptions/{{subscriptionId}}/ResourceGroups/{{resourceGroupName}}/providers/namespace/typename1/{{typename1type}}/typename2/{{typename2type}}/operations";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;
    }
}





