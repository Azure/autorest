// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class RequiredPropertiesMustExist : TypedRule<string>
    {
        /// <summary>
        /// A <paramref name="propertyName" /> passes this rule if the <paramref name="propertyName"/> appears in the list of properties
        /// </summary>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public override bool IsValid(string propertyName, RuleContext context, out object[] formatParameters)
        {
            var properties = (context.Parent?.Parent?.Value as Schema)?.Properties;
            if (properties == null || !properties.ContainsKey(propertyName))
            {
                formatParameters = new string[] { propertyName };
                return false;
            }
            formatParameters = new object[0];
            return true;
        }

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Required property '{0}' does not appear in the list of properties";

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
    }
}