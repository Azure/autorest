// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.Fluent.AcceptanceTestsAzureCompositeModelClient.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.Fluent;
    using Fixtures.Azure.Fluent.AcceptanceTestsAzureCompositeModelClient;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class CatalogDictionaryInner
    {
        /// <summary>
        /// Initializes a new instance of the CatalogDictionaryInner class.
        /// </summary>
        public CatalogDictionaryInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the CatalogDictionaryInner class.
        /// </summary>
        /// <param name="productDictionary">Dictionary of products</param>
        public CatalogDictionaryInner(IDictionary<string, ProductInner> productDictionary = default(IDictionary<string, ProductInner>))
        {
            ProductDictionary = productDictionary;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets dictionary of products
        /// </summary>
        [JsonProperty(PropertyName = "productDictionary")]
        public IDictionary<string, ProductInner> ProductDictionary { get; set; }

    }
}
