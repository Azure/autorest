// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using System;
using System.Collections.Generic;

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
        /// Validates whether PUT operation name is named correctly
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns>ValidationMessage</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(string operationId, RuleContext context)
        {
            string httpVerb = context?.Parent?.Key;
            if (!String.IsNullOrWhiteSpace(httpVerb) && httpVerb.EqualsIgnoreCase("GET") && !IsGetValid(operationId))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, operationId);
            }
        }

    }
}
