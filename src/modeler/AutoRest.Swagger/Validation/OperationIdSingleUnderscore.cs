// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdSingleUnderscore : TypedRule<string>
    {
        public override bool IsValid(string entity)
        {
            return entity != null && entity.Count(c => c == '_') <= 1;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.OneUnderscoreInOperationId;
            }
        }
    }
}
