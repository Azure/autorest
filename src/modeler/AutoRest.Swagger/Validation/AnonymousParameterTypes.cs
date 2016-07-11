// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AnonymousParameterTypes : TypedRule<SwaggerParameter>
    {
        private static AnonymousTypes AnonymousTypesRule = new AnonymousTypes();

        /// <summary>
        /// An entity fails this rule if it has a schema, and that schema is an anonymous type
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerParameter entity) =>
            entity == null || entity.Schema == null || AnonymousTypesRule.IsValid(entity.Schema);

        public override ValidationExceptionName Exception => ValidationExceptionName.AnonymousTypesDiscouraged;
    }
}
