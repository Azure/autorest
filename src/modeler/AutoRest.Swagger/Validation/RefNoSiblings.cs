// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class RefNoSiblings : TypedRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (entity != null && !string.IsNullOrEmpty(entity.Reference) &&
                (
                entity.Description != null ||
                entity.Items != null ||
                entity.Type != null
                ))
            {
                valid = false;
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.RefsMustNotHaveSiblings;
            }
        }
    }
}
