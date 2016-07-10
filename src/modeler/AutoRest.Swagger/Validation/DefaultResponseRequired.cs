// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class DefaultResponseRequired : TypedRule<IDictionary<string, OperationResponse>>
    {
        public override bool IsValid(IDictionary<string, OperationResponse> entity)
        {
            return entity != null && entity.ContainsKey("default");
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DefaultResponseRequired;
            }
        }
    }
}
