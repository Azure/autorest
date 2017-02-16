// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ListByOperationsValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex ListByRegex = new Regex(@".+_listby.+$", RegexOptions.IgnoreCase);
        private readonly Regex UrlRegex = new Regex(@"(?<urltoken>\/[^\/]+)+$", RegexOptions.IgnoreCase);
        private readonly Regex RgRegex = new Regex(@"(\/[^\/]+)*\/ResourceGroups\/\{[^\/]+}(\/[^\/]+)*$", RegexOptions.IgnoreCase);
        private readonly Regex SubscriptionRegex = new Regex(@"(\/[^\/]+)*\/Subscriptions\/\{[^\/]+}(\/[^\/]+)*$", RegexOptions.IgnoreCase);
        private readonly Regex ParentRegex = new Regex(@"[^\/]+\/providers(?<parent>\/[^\/]+)+$", RegexOptions.IgnoreCase);
        private readonly Regex PathParameterRegex = new Regex(@"\/\{\w+\}$", RegexOptions.IgnoreCase);
        private readonly string ListByTemplate = "{0}_ListBy{1}";
        private readonly string ListTemplate = "{0}_List";
        private readonly string ResourceGroup = "ResourceGroup";
        private readonly string SubscriptionId = "SubscriptionId";

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string,Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            var serviceDefinition = (ServiceDefinition)context.Root;
            
            foreach (var pathObj in entity)
            {
                var listOpIds = pathObj.Value
                                        // operation should be a get or post
                                        .Where(pair => (pair.Key.ToLower().Equals("get") || pair.Key.ToLower().Equals("post")))
                                        // operation id should be of the form *_list(by)
                                        .Where(pair => (ListByRegex.IsMatch(pair.Value.OperationId) || pair.Value.OperationId.ToLower().EndsWith("_list")))
                                        // operation is xmspageable or returns an array
                                        .Where(pair => (ValidationUtilities.IsXmsPageableOrArrayResponseOperation(pair.Value, serviceDefinition)))
                                        // select the operation id
                                        .Select(pair => pair.Value.OperationId);

                // if there are no operations matching our conditions, skip
                if (IsNullOrEmpty(listOpIds))
                {
                    continue;
                }

                // populate valid list operation names for given path
                List<string> opNames = GetValidListOpNames(pathObj.Key);
                
                // if url does not match any of the predefined regexes, skip
                if (opNames == null || opNames.Count==0)
                {
                    continue;
                }

                // find if there are any operations that violate the rule
                var errOpIds = listOpIds.Where(opId => !opNames.Contains(opId.ToLower()));
                
                // no violations found, skip
                if (IsNullOrEmpty(errOpIds))
                {
                    continue;
                }
                // aggregate suggested op names in a single readable string for the formatter
                var suggestedNames = string.Join(", ", opNames);
                foreach (var errOpId in errOpIds)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, errOpId, suggestedNames);
                }
            }
        }

        private List<string> GetValidListOpNames(string path)
        {
            var opList = new List<string>();
            var methodGrp = GetMethodGroup(path);
            if (methodGrp == null || !SubscriptionRegex.IsMatch(path))
            {
                return opList;
            }

            // construct _listbysubscriptionid
            opList.Add(string.Format(ListByTemplate, methodGrp, SubscriptionId).ToLower());
            opList.Add(string.Format(ListTemplate, methodGrp).ToLower());

            // construct _listbyresourcegroup
            if ((RgRegex.IsMatch(path)))
            {
                opList.Add(string.Format(ListByTemplate, methodGrp, ResourceGroup).ToLower());
            }
            else
            {
                return opList;
            }
            
            // construct _listbyparent
            var match = ParentRegex.Match(path.Substring(0, path.IndexOf(methodGrp)-1));
            if (match.Success)
            {
                var caps = match.Groups["parent"].Captures.OfType<Capture>().Reverse();
                var capture = caps.FirstOrDefault(cap => !PathParameterRegex.IsMatch(cap.Value));
                // if due to some reason the parent we find is of the form "foo.bar", let's recommend the
                // operation id be named as "_listbyfoobar"
                if (capture != null)
                {
                    opList.Add(string.Format(ListByTemplate, methodGrp, capture.Value.Substring(1)).Replace(".", string.Empty).ToLower());
                }
            }
            
            return opList;
        }

        private string GetMethodGroup(string path)
        {
            var match = UrlRegex.Match(path);
            var caps = match.Groups["urltoken"].Captures.OfType<Capture>().Reverse();
            var capture = caps.FirstOrDefault(cap => !PathParameterRegex.IsMatch(cap.Value));
            return capture?.Value?.Substring(1);
        }

        private bool IsNullOrEmpty(IEnumerable<object> enumerable)
        {
            return enumerable == null || !enumerable.Any();
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Operation {0} must be one of: {1}";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;
    }
}
