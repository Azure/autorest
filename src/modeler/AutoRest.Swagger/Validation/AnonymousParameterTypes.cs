// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class AnonymousParameterTypes : TypedRule<SwaggerParameter>
    {
        public override bool IsValid(SwaggerParameter entity)
        {
            bool valid = true;

            if (entity != null && entity.Schema != null)
            {
                var anonymousTypesRule = new AnonymousTypes();
                valid = anonymousTypesRule.IsValid(entity.Schema);
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.AnonymousTypesDiscouraged;
            }
        }
    }
}
