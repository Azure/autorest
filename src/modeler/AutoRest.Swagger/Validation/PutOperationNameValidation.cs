// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using AutoRest.Core.Logging;
using System;
using System.Collections.Generic;

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
        /// Validates whether PUT operation name is named correctly
        /// </summary>
        /// <param name="entity">Operation name to be verified.</param>
        /// <param name="context">Rule context.</param>
        /// <returns>ValidationMessage</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(string operationId, RuleContext context)
        {
            if (!String.IsNullOrWhiteSpace(operationId) && operationId.EqualsIgnoreCase("PUT"))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, operationId);
            }
        }
    }
}
