// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using System;

namespace AutoRest.Swagger.Validation
{
    public class PutOperationNameValidation : OperationNameValidation
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M1006";

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.PutOperationNameNotValid;

        /// <summary>
        /// Validates whether operation name confirms to the GET rule naming convension.
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns><c>true</c> if PUT operation name confirms to PUT rule, otherwise <c>false</c>.</returns>
        public override bool IsValid(string entity, RuleContext context)
        {
            string httpVerb = context?.Parent?.Key;

            if (!String.IsNullOrWhiteSpace(httpVerb) && httpVerb.EqualsIgnoreCase("PUT"))
            {
                return IsPutValid(entity);
            }

            return true;
        }
    }
}
