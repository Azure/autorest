// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using System;

namespace AutoRest.Swagger.Validation
{
    public class DeleteOperationNameValidation : OperationNameValidation
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M1009";

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.DeleteOperationNameNotValid;

        /// <summary>
        /// Validates whether operation name confirms to the DELETE rule naming convension.
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns><c>true</c> if DELETE operation name confirms to DELETE rule, otherwise <c>false</c>.</returns>
        public override bool IsValid(string entity, RuleContext context)
        {
            string httpVerb = context?.Parent?.Key;

            if (!String.IsNullOrWhiteSpace(httpVerb) && httpVerb.EqualsIgnoreCase("DELETE"))
            {
                return IsDeleteValid(entity);
            }

            return true;
        }
    }
}
