// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Xms")]
    public class XmsPathsMustOverloadPaths : TypedRule<Dictionary<string, Operation>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2058";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.XMSPathBaseNotInPaths;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        public override bool IsValid(Dictionary<string, Operation> xmsPath, RuleContext context)
        {
            return context?.GetServiceDefinition()?.Paths?.ContainsKey(GetBasePath(context.Key)) ?? false;
        }

        private static string GetBasePath(string customPath)
        {
            var index = customPath.IndexOf('?');
            if (index == -1)
            {
                return customPath;
            }
            return customPath.Substring(0, index);
        }
    }
}