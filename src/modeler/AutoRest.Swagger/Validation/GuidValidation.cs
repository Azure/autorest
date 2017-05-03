// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if GUID is used in any of the properties.
    /// GUID usage is not recommended in general.
    /// </summary>
    public class GuidValidation : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3017";

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
        public override string MessageTemplate => Resources.GuidUsageNotRecommended;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                object[] formatParameters;
                if (!this.HandleSchema((Schema)definition.Value, definitions, out formatParameters, definition.Key))
                {
                    formatParameters[1] = definition.Key;
                    yield return new ValidationMessage(new FileObjectPath(context.File,
                                context.Path.AppendProperty(definition.Key).AppendProperty("properties").AppendProperty((string)formatParameters[0])), this, formatParameters);
                }
            }
        }

        private bool HandleSchema(Schema definition, Dictionary<string, Schema> definitions, out object[] formatParameters, string name)
        {
            // This could be a reference to another definition. But, that definition could be handled seperately.
            if(definition.Type == DataType.String && definition.Format?.EqualsIgnoreCase("uuid") == true)
            {
                formatParameters = new object[2];
                formatParameters[0] = name;
                return false;
            }            

            if (definition.RepresentsCompositeType())
            {
                foreach (KeyValuePair<string, Schema> property in definition.Properties)
                {
                    if (!this.HandleSchema((Schema)property.Value, definitions, out formatParameters, property.Key))
                    {
                        return false;
                    }
                }
            }
            formatParameters = new object[0];
            return true;
        }
    }
}
