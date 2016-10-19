// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class NetworkInterfacesApiWarning : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private static readonly List<string> NetworkApiNamespaces = new List<string>(new string[]{"microsoft.compute", "microsoft.network"});
        /// <summary>
        /// This rule passes if the paths contain reference to either Microsoft.Network Apis or 
        /// Microsoft.Compute Apis but not both
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            Regex apiRegExp = new Regex(@"/([^/]+)+");
        
            string firstMatch = null;

            foreach (var path in paths.Keys)
            {
                // for each path, check if it exists in our list of namespaces and 
                // ensure it's unique for the given json
                // regex finds all strings of the form /<str> from the path 
                // firstMatch ensures there is only one kind of namespace referenced
                for (Match m = apiRegExp.Match(path); m.Success; m = m.NextMatch())
                {
                    string val = m.Groups[1].Value.ToLowerInvariant();
                    if (!NetworkApiNamespaces.Contains(val))
                    {
                        continue;
                    }
                    else
                    {
                        if (firstMatch == null)
                        {
                            firstMatch = val;
                        }
                        else if (firstMatch != val)
                        {
                            return false;
                        }
                    }
                }

            }
            return true;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.NetworkInterfacesApiWarningMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
