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
    public class UniqueResourcePaths : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        // Ignore everything within /es except when we find microsoft.* and capture that group
        private readonly Regex apiRegExp = new Regex(@"(?:/[^/]+)+/(?i)microsoft(?-i).([^/]+)(?:/[^/]+)+");

        /// <summary>
        /// This rule passes if the paths contain reference to exactly one of the namespace resources
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths) 
            => paths.Keys.Select(path => 
                    { return apiRegExp.Match(path).Success ? apiRegExp.Match(path).Groups?[0]?.Value.ToString().ToLowerInvariant() : null; })
                                      .Where(p=>p!=null).Distinct().Count() <= 1;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.UniqueResourcePathsWarning;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
