// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdSingleUnderscore : TypedRule<string>
    {
        /// <summary>
        /// This rule passes if the entity contains no more than 1 underscore
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string entity)
            => entity != null && entity.Count(c => c == '_') <= 1;

        public override ValidationExceptionName Exception => ValidationExceptionName.OneUnderscoreInOperationId;
    }
}
