// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;

namespace AutoRest.Swagger.Model
{
    [Serializable]
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
        public Dictionary<string, object> Extensions { get; set; }
    }
}