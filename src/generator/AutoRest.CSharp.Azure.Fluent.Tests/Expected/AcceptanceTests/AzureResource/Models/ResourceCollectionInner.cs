// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureResource.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsAzureResource;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class ResourceCollectionInner
    {
        /// <summary>
        /// Initializes a new instance of the ResourceCollectionInner class.
        /// </summary>
        public ResourceCollectionInner() { }

        /// <summary>
        /// Initializes a new instance of the ResourceCollectionInner class.
        /// </summary>
        public ResourceCollectionInner(FlattenedProductInner productresource = default(FlattenedProductInner), IList<FlattenedProductInner> arrayofresources = default(IList<FlattenedProductInner>), IDictionary<string, FlattenedProductInner> dictionaryofresources = default(IDictionary<string, FlattenedProductInner>))
        {
            Productresource = productresource;
            Arrayofresources = arrayofresources;
            Dictionaryofresources = dictionaryofresources;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "productresource")]
        public FlattenedProductInner Productresource { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "arrayofresources")]
        public IList<FlattenedProductInner> Arrayofresources { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "dictionaryofresources")]
        public IDictionary<string, FlattenedProductInner> Dictionaryofresources { get; set; }

    }
}

