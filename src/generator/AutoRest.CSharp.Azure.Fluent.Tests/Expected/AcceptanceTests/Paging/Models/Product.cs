// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsPaging.Models
{
    using Azure;
    using AcceptanceTestsPaging;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Product
    {
        /// <summary>
        /// Initializes a new instance of the Product class.
        /// </summary>
        public Product() { }

        /// <summary>
        /// Initializes a new instance of the Product class.
        /// </summary>
        public Product(ProductProperties properties = default(ProductProperties))
        {
            Properties = properties;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties")]
        public ProductProperties Properties { get; set; }

    }
}
