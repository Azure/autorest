// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class UniqueResourcePaths : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex resPathPattern = new Regex(@"/providers/(?<resPath>[^{/]+)/");

        /// <summary>
        /// This rule passes if the paths contain reference to exactly one of the namespace resources
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context, out object[] formatParameters)
        {
            var resources = paths.Keys
                .SelectMany(path => resPathPattern.Matches(path)
                    .OfType<Match>()
                    .Select(match => match.Groups["resPath"].Value.ToString()))
                .Distinct()
                .ToArray();
            formatParameters = new [] { string.Join(", ", resources) };
            return resources.Length <= 1;
        }

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
        public override Category Severity => Category.Warning;

    }
}
