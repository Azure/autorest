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
    public class OperationNameValidation : TypedRule<string>
    {
        private const string NOUN_VERB_PATTERN = "^(\\w+)?_(\\w+)$";

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
        /// <remarks>
        /// This rule corresponds to M1005, M1006, M1007 & M1009.
        /// </remarks>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// This rule passes if the operation id of HTTP Method confirms to M1005, M1006, M1007 & M1009.
        ///   e.g. For Get method User_Get or User_List
        ///     or For Put method User_Create
        ///     or For Patch method User_Update
        ///     or For Delete method User_Delete
        ///     are valid names.
        /// </summary>
        /// <param name="operationDefinition">Dictionary of the path and respective operations.</param>
        /// <returns><c>true</c> if operation name confimes to above rules, otherwise <c>false</c>.</returns>
        /// <remarks>
        /// Message will be shown at the path level.
        /// </remarks>
        public override bool IsValid(string entity, RuleContext context)
        {
            bool isOperationNameValid = true;
            string httpVerb = context?.Parent?.Key;

            if (httpVerb.Equals("GET", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = (entity.Contains("_") && (entity.EndsWith("_Get") || entity.Contains("_List"))) || 
                    (entity.StartsWith("get") || entity.StartsWith("list"));
            }
            else if (httpVerb.Equals("PUT", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = (entity.Contains("_") && entity.EndsWith("_Create")) || entity.StartsWith("create");
            }
            else if (httpVerb.Equals("PATCH", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = (entity.Contains("_") && entity.EndsWith("_Update")) || entity.StartsWith("update");
            }
            else if (httpVerb.Equals("DELETE", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = (entity.Contains("_") && entity.EndsWith("_Delete")) || entity.StartsWith("update");
            }

            return isOperationNameValid;
        }
    }
}
