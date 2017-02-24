// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Flags properties of boolean type as they are not recommended, unless it's the only option.
    /// </summary>
    public class BooleanPropertyNotRecommended : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3018";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.BooleanPropertyNotRecommended;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validates whether properties of type boolean exist.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns>true if there are no propeties of type boolean, false otherwise.</returns>
        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context, out object[] formatParameters)
        {
            formatParameters = null;
            List<string> booleanProperties = new List<string>();
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (definition.Value?.Properties != null)
                {
                    foreach (KeyValuePair<string, Schema> property in definition.Value.Properties)
                    {
                        if (property.Value.Type.ToString().ToLower().Equals("boolean"))
                        {
                            booleanProperties.Add(definition.Key + "/" + property.Key);
                        }
                    }
                }
            }
            formatParameters = new[] { string.Join(", ", booleanProperties.ToArray()) };
            return (booleanProperties.Count == 0);
        }
    }
}