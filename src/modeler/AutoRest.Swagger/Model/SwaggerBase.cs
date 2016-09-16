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
        [CollectionRule(typeof(NextLinkPropertyMustExist))]
        [CollectionRule(typeof(PageableRequires200Response))]
        public Dictionary<string, object> Extensions { get; set; }

        /// <summary>
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public virtual IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            if (previous == null)
                throw new ArgumentNullException("previous");
            if (context == null)
                throw new ArgumentNullException("context");
                
            yield break; 
        }
    }
}