// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
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

        /// <summary>
        /// An <paramref name="definitions"/> fails this rule if one of the property has GUID,
        /// i.e. if the type of the definition is string and the format is uuid.
        /// </summary>
        /// <param name="definitions">Operation Definitions to validate</param>
        /// <param name="formatParameters">The noun to be put in the failure message</param>
        /// <returns>true if there is no GUID. false otherwise.</returns>
        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context, out object[] formatParameters)
        {
            if(definitions != null)
            {
                foreach (KeyValuePair<string, Schema> definition in definitions)
                {
                    if (!this.HandleSchema((Schema)definition.Value, definitions, out formatParameters, definition.Key))
                    {
                        formatParameters[1] = definition.Key;
                        return false;
                    }
                }
            }
            formatParameters = new object[0];
            return true;
        }

        private bool HandleSchema(Schema definition, Dictionary<string, Schema> definitions, out object[] formatParameters, string name)
        {
            // This could be a reference to another definition. But, that definition could be handled seperately.
            if(definition.Type == DataType.String && definition.Format != null && definition.Format.Equals("uuid", System.StringComparison.InvariantCultureIgnoreCase))
            {
                formatParameters = new object[2];
                formatParameters[0] = name ;
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
