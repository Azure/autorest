// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class EnumContainsDefault : TypedRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            if (entity != null && !string.IsNullOrEmpty(entity.Default) && entity.Enum != null)
            {
                // There's a default, and there's an list of valid values. Make sure the default is one 
                // of them.
                if (!entity.Enum.Contains(entity.Default))
                {
                    valid = false;
                }
            }
            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DefaultMustBeInEnum;
            }
        }
    }
}
