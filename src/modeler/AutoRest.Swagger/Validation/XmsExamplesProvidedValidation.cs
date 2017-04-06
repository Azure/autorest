// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class XmsExamplesProvidedValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2022";

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Please provide x-ms-examples describing minimum/maximum property set for response/request payloads for operation '{0}' ";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;


        /// <summary>
        /// Validates whether operation has corresponding x-ms-examples
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns>ValidationMessage</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            var violatingOps = paths.Select(pathObj=>pathObj.Value.Values.Where(op=>!op.Extensions?.ContainsKey("x-ms-examples") || string.IsNullOrWhiteSpace((string)op.Extensions["x-ms-examples"]))
        }
    }
}
