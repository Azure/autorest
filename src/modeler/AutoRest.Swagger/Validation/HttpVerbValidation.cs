// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class HttpVerbValidation : TypedRule<Dictionary<string, Operation>>
    {
        private readonly Regex opRegExp = new Regex(@"^(DELETE|GET|PUT|PATCH|HEAD|OPTIONS|POST)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.HttpVerbIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// An <paramref name="operationDefinition"/> fails this rule if it does not have the correct HTTP Verb.
        /// </summary>
        /// <param name="operationDefinition">Operation Definition to validate</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Operation> operationDefinition)
        {
            foreach(string httpVerb in operationDefinition.Keys)
            {
                if (!opRegExp.IsMatch(httpVerb))
                {
                    return false;
                }
            }

            return true;
        }
    }
}
