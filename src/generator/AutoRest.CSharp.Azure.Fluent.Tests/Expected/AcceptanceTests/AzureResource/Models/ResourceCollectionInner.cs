// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureResource.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

    public partial class ResourceCollectionInner
    {
        /// <summary>
        /// Initializes a new instance of the ResourceCollectionInner class.
        /// </summary>
        public ResourceCollectionInner() { }

        /// <summary>
        /// Initializes a new instance of the ResourceCollectionInner class.
        /// </summary>
        public ResourceCollectionInner(FlattenedProductInner productresource = default(FlattenedProductInner), System.Collections.Generic.IList<FlattenedProductInner> arrayofresources = default(System.Collections.Generic.IList<FlattenedProductInner>), System.Collections.Generic.IDictionary<string, FlattenedProductInner> dictionaryofresources = default(System.Collections.Generic.IDictionary<string, FlattenedProductInner>))
        {
            Productresource = productresource;
            Arrayofresources = arrayofresources;
            Dictionaryofresources = dictionaryofresources;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "productresource")]
        public FlattenedProductInner Productresource { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "arrayofresources")]
        public System.Collections.Generic.IList<FlattenedProductInner> Arrayofresources { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "dictionaryofresources")]
        public System.Collections.Generic.IDictionary<string, FlattenedProductInner> Dictionaryofresources { get; set; }

    }
}
