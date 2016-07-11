// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AnonymousTypes : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// An <paramref name="entity"/> fails this rule if it doesn't have a reference (meaning it's defined inline)
        /// </summary>
        /// <param name="entity">The entity to validate</param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity) => entity == null || !string.IsNullOrEmpty(entity.Reference);

        public override ValidationExceptionName Exception => ValidationExceptionName.AnonymousTypesDiscouraged;
    }
}
