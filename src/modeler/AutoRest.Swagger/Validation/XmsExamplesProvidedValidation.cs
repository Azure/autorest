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
        // the maximum number of non-xms-examples operations to allow.
        private static int magicNumber = 10;
        
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
        public override string MessageTemplate => "Please provide x-ms-examples describing minimum/maximum property set for response/request payloads for operations";

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
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            // find all operations that do not have the x-ms-examples extension or those which have x-ms-examples extension as empty
            // but ignore operations_list
            var violatingOps = paths.SelectMany(pathObj => pathObj.Value.Where(opPair 
                                                            => (opPair.Value.Extensions?.ContainsKey("x-ms-examples") != true 
                                                               || string.IsNullOrWhiteSpace((string)opPair.Value.Extensions["x-ms-examples"]))
                                                               && !opPair.Value.OperationId.ToLower().Equals("operations_list")));
            return violatingOps.Count() <= magicNumber;
        }
    }
}
