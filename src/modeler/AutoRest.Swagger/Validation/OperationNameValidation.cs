// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class OperationNameValidation : TypedRule<string>
    {
        private static readonly Regex GET_NOUN_VERB_PATTERN = new Regex(@"^(\w+)_(Get|List)", RegexOptions.IgnoreCase);
        private static readonly Regex GET_VERB_PATTERN = new Regex(@"^(Get|List)", RegexOptions.IgnoreCase);
        private static readonly Regex PUT_NOUN_VERB_PATTERN = new Regex(@"^(\w+)_(Create)", RegexOptions.IgnoreCase);
        private static readonly Regex PUT_VERB_PATTERN = new Regex(@"^(Create)", RegexOptions.IgnoreCase);
        private static readonly Regex PATCH_NOUN_VERB_PATTERN = new Regex(@"^(\w+)_(Update)", RegexOptions.IgnoreCase);
        private static readonly Regex PATCH_VERB_PATTERN = new Regex(@"^(Update)", RegexOptions.IgnoreCase);
        private static readonly Regex DELETE_NOUN_VERB_PATTERN = new Regex(@"^(\w+)_(Delete)", RegexOptions.IgnoreCase);
        private static readonly Regex DELETE_VERB_PATTERN = new Regex(@"^(Delete)", RegexOptions.IgnoreCase);

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
                isOperationNameValid = GET_NOUN_VERB_PATTERN.IsMatch(entity) || GET_VERB_PATTERN.IsMatch(entity);
            }
            else if (httpVerb.Equals("PUT", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = PUT_NOUN_VERB_PATTERN.IsMatch(entity) || PUT_VERB_PATTERN.IsMatch(entity);
            }
            else if (httpVerb.Equals("PATCH", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = PATCH_NOUN_VERB_PATTERN.IsMatch(entity) || PATCH_VERB_PATTERN.IsMatch(entity);
            }
            else if (httpVerb.Equals("DELETE", StringComparison.InvariantCultureIgnoreCase))
            {
                isOperationNameValid = DELETE_NOUN_VERB_PATTERN.IsMatch(entity) || DELETE_VERB_PATTERN.IsMatch(entity);
            }

            return isOperationNameValid;
        }
    }
}
