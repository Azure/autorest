// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class GuidValidation : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.GuidUsageNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// An <paramref name="definitions"/> fails this rule if it does not have all valid properties.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Schema> definitions)
        {
            if(definitions != null)
            {
                foreach (KeyValuePair<string, Schema> definition in definitions)
                {
                    if (!this.HandleSchema((Schema)definition.Value, definitions))
                    {
                        return false;
                    }
                }
            }
            
            return true;
        }

        private bool HandleSchema(Schema definition, Dictionary<string, Schema> definitions)
        {
            // Note: This could be a reference to another definition. But, that definition could
            // be handled seperately.
            if(definition.Type == DataType.String && definition.Format != null && definition.Format.Equals("uuid", System.StringComparison.InvariantCultureIgnoreCase))
            {
                return false;
            }            

            if (definition.RepresentsCompositeType())
            {
                foreach (KeyValuePair<string, Schema> property in definition.Properties)
                {
                    if (!this.HandleSchema((Schema)property.Value, definitions))
                    {
                        return false;
                    }
                }
            }

            return true;
        }
    }
}
