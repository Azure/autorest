// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Validation.Core;
using System;

namespace AutoRest.Swagger.Validation
{
    public class GetOperationNameValidation : OperationNameValidation
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M1005";

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.GetOperationNameNotValid;

        /// <summary>
        /// Validates whether operation name confirms to the GET rule naming convension.
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns><c>true</c> if GET operation name confirms to GET rule, otherwise <c>false</c>.</returns>
        public override bool IsValid(string entity, RuleContext context)
        {
            string httpVerb = context?.Parent?.Key;

            if (!String.IsNullOrWhiteSpace(httpVerb) && httpVerb.EqualsIgnoreCase("GET"))
            {
                return IsGetValid(entity);
            }

            return true;
        }
    }
}
