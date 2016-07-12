// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class DefaultResponseRequired : TypedRule<IDictionary<string, OperationResponse>>
    {
        /// <summary>
        /// This rule fails if the <paramref name="entity"/> lacks responses or lacks a default response
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(IDictionary<string, OperationResponse> entity)
            => entity != null && entity.ContainsKey("default");

        public override ValidationExceptionName Exception => ValidationExceptionName.DefaultResponseRequired;
    }
}
