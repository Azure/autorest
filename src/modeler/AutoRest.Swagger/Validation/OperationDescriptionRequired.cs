// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class OperationDescriptionRequired : DescriptionRequired<Operation>
    {
        /// <summary>
        /// This rule fails if the description is null and the reference is null (since the reference could have a description)
        /// </summary>
        /// <param name="entity">Entity being validated</param>
        /// <param name="context">Rule context</param>
        /// <returns>list of ValidationMessages</returns> 
        public override IEnumerable<ValidationMessage> GetValidationMessages(Operation entity, RuleContext context)
        {
            if (string.IsNullOrWhiteSpace(entity.Description))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, entity.OperationId);
            }
            
        }
    }
}
