// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    internal static class SwaggerObjectExtensions
    {
        internal static bool DefinesInlineProperties(this SwaggerObject entity)
        {
            return entity.Description != null
                || entity.Items != null
                || entity.Type != null;
        }
    }

    public class RefNoSiblings : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// This rule passes if the entity does not have both a reference and define properties inline
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerObject entity)
            => entity == null || string.IsNullOrEmpty(entity.Reference) || !entity.DefinesInlineProperties();

        public override ValidationExceptionName Exception => ValidationExceptionName.RefsMustNotHaveSiblings;
    }
}
