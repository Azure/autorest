// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using AutoRest.Swagger.Validation;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Model
{
    public abstract class SwaggerBase
    {
        public SwaggerBase()
        {
            Extensions = new Dictionary<string, object>();
        }

        /// <summary>
        /// Vendor extensions.
        /// </summary>
        [JsonExtensionData]
        [CollectionRule(typeof(NonEmptyClientName))]
        [CollectionRule(typeof(NextLinkPropertyMustExist))]
        [CollectionRule(typeof(PageableRequires200Response))]
        [CollectionRule(typeof(LongRunningResponseStatusCode))]
        [CollectionRule(typeof(MutabilityWithReadOnly))]
        public Dictionary<string, object> Extensions { get; set; }
    }
}