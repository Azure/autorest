// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ListByOperationsValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex ListByRegex = new Regex(@".+_listby.+$", RegexOptions.IgnoreCase);
        private readonly Regex UrlRegex = new Regex(@"(\/[^\/]+)+$", RegexOptions.IgnoreCase);
        private readonly Regex RgRegex = new Regex(@"(\/[^\/]+)*\/ResourceGroups\/\{[^\/]+}(\/[^\/]+)*$", RegexOptions.IgnoreCase);
        private readonly Regex SubscriptionRegex = new Regex(@"(\/[^\/]+)*\/Subscriptions\/\{[^\/]+}(\/[^\/]+)*$", RegexOptions.IgnoreCase);
        private readonly Regex ParentRegex = new Regex(@"[^\/]+\/providers(\/[^\/]+)+$", RegexOptions.IgnoreCase);
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
                var listOpIds = pathObj.Value.Select(pair => {
                    // if the operation is not a get or a post, skip
                    if (!(pair.Key.Equals("get") || pair.Key.Equals("post")))
                    { return null; }
                    // if the operation id is not of the form *_list(by), skip
                    if (!(ListByRegex.IsMatch(pair.Value.OperationId) || pair.Value.OperationId.ToLower().EndsWith("_list")))
                    { return null; }
                    // if the operation does not return an array type or is not an xms pageable type, skip
                    if (!(AutoRest.Swagger.Model.Utilities.ValidationUtilities.IsXmsPageableOrArrayResponseOperation(pair.Value, serviceDefinition)))
                    { return null; }
                    // if all conditions pass, return the operation id
                    return pair.Value.OperationId;
                }).Where(opId=> opId!=null);

                // if there are no operations matching our conditions, skip
                if (IsNullOrEmpty(listOpIds))
                { continue;  }

                // populate valid list operation names for given path
                var opNames = GetValidListOpNames(pathObj.Key);
                
                // if url does not match any of the predefined regexes, skip
                if (IsNullOrEmpty(opNames))
                { continue; }

                // find if there are any operations that violate the rule
                var errOpIds = listOpIds.Where(opId => !opNames.Contains(opId.ToLower()));
                // no violations found, skip
                if (IsNullOrEmpty(errOpIds))
                { continue; }

                foreach (var errOpId in errOpIds)
                {
                    yield return new ValidationMessage(context.Path, this, errOpId);
                }
            }
        }

        private IEnumerable<string> GetValidListOpNames(string path)
        {
            var opList = new List<string>();
            var methodGrp = GetMethodGroup(path);
            if (methodGrp == string.Empty)
            { return opList; }

            // construct _listbyparent
            var match = ParentRegex.Match(path.Substring(0, path.IndexOf(methodGrp)-1));
            if (match.Success)
            {
                var caps = match.Groups[1].Captures;
                int index = caps.Count - 1;
                while (index >= 0 && PathParameterRegex.IsMatch(caps[index].Value))
                {
                    index--;
                }
                // if due to some reason the parent we find is of the form "foo.bar", let's recommend the
                // operation id be named as "_listbyfoobar"
                if (index > -1)
                { opList.Add(string.Format(ListByTemplate, methodGrp, caps[index].Value.Substring(1)).Replace(".", string.Empty).ToLower()); }
            }

            // construct _listbyresourcegroup
            if (RgRegex.IsMatch(path))
            { opList.Add(string.Format(ListByTemplate, methodGrp, ResourceGroup).ToLower()); }

            // construct _listbysubscriptionid
            if (SubscriptionRegex.IsMatch(path))
            {
                opList.Add(string.Format(ListByTemplate, methodGrp, SubscriptionId).ToLower());
                opList.Add(string.Format(ListTemplate, methodGrp).ToLower());
            }
            
            return opList;
        }

        private string GetMethodGroup(string path)
        {
            var match = UrlRegex.Match(path);
            var caps = match.Groups[1].Captures;
            int index = caps.Count - 1;
            while (index >= 0 && PathParameterRegex.IsMatch(caps[index].Value))
            {
                index--;
            }
            return (index > -1) ? caps[index].Value.Substring(1) : string.Empty;
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
        public override string MessageTemplate => "Operation {0} must be named as MethodGroup_ListByResourceGroup, MethodGroup_ListByParent or MethodGroup_List(BySubscriptionId)";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;
    }
}




