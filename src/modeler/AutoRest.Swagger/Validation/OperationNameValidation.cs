// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class OperationNameValidation : TypedRule<Dictionary<string, Operation>>
    {
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.OperationNameNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// An <paramref name="operationDefinition"/> fails this rule if it does not have the correct HTTP Verb.
        /// </summary>
        /// <param name="operationDefinition">Operation Definition to validate</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Operation> operationDefinition)
        {
            bool areAllOperationNameValid = true;
            foreach (KeyValuePair<string, Operation> entry in operationDefinition)
            {
                bool isOperationNameValid = true;
                string httpVerb = entry.Key;
                string operationId = entry.Value.OperationId;

                if (httpVerb.Equals("GET", StringComparison.InvariantCultureIgnoreCase))
                {
                    isOperationNameValid = operationId.EndsWith("_Get") || operationId.Contains("_List");
                }
                else if (httpVerb.Equals("PUT", StringComparison.InvariantCultureIgnoreCase))
                {
                    isOperationNameValid = operationId.EndsWith("_Create");
                }
                else if (httpVerb.Equals("PATCH", StringComparison.InvariantCultureIgnoreCase))
                {
                    isOperationNameValid = operationId.EndsWith("_Update");
                }
                else if (httpVerb.Equals("DELETE", StringComparison.InvariantCultureIgnoreCase))
                {
                    isOperationNameValid = operationId.EndsWith("_Delete");
                }
                else
                {
                    continue;
                }

                // If any of the operation name under the path is invalid, then areAllOperationNameValid is false
                if (!isOperationNameValid && areAllOperationNameValid)
                {
                    areAllOperationNameValid = isOperationNameValid;
                }
            }

            return areAllOperationNameValid;
        }
    }
}
