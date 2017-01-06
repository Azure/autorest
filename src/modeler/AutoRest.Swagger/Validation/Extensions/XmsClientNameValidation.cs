// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class XmsClientNameValidation : TypedRule<Dictionary<string, Schema>>
    {
        private static readonly string extensionToCheck = "x-ms-client-name";

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.XmsClientNameInValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// An <paramref name="definitions"/> fails this rule if it does not have all valid properties.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Schema> definitions)
        {
            foreach (string key in definitions.Keys)
            {
                Schema schema = definitions.GetValueOrNull(key);
                if(schema != null)
                {
                    if(schema.Extensions != null && schema.Extensions.Count !=0)
                    {
                        string valueToCompare = (string)schema.Extensions.GetValueOrNull(extensionToCheck);
                        if (valueToCompare != null && valueToCompare.Equals(key))
                        {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
    }
}
