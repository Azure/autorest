// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates the HTTP verb. Allowed values for the HTTP Verb are
    /// delete, get, put, patch, head, options, post.
    /// </summary>
    public class InvalidVerbUsed : TypedRule<Dictionary<string, Operation>>
    {
        private readonly Regex opRegExp = new Regex(@"^(DELETE|GET|PUT|PATCH|HEAD|OPTIONS|POST|TRACE)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2044";

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
        public override string MessageTemplate => Resources.HttpVerbIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// When to apply the validation rule, before or after it has been merged as a part of 
        /// its merged document as specified in the corresponding '.md' file
        /// By default consider all rules to be applied for After only
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// An <paramref name="operationDefinition"/> fails this rule if it does not have the correct HTTP Verb.
        /// </summary>
        /// <param name="operationDefinition">Operation Definition to validate</param>
        /// <returns>true if the validation succeeds. false otherwise.</returns>
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
