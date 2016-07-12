// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class DescriptionRequired : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// This rule fails if the description is null and the reference is null (since the reference could have a description)
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity)
            => entity == null || entity.Description != null || !string.IsNullOrEmpty(entity.Reference);

        public override ValidationExceptionName Exception => ValidationExceptionName.DescriptionRequired;
    }
}
