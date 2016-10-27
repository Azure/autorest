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

    [Microsoft.Rest.Serialization.JsonTransformation]
    public partial class FlattenedProductInner : Microsoft.Rest.Azure.Resource
    {
        /// <summary>
        /// Initializes a new instance of the FlattenedProductInner class.
        /// </summary>
        public FlattenedProductInner() { }

        /// <summary>
        /// Initializes a new instance of the FlattenedProductInner class.
        /// </summary>
        public FlattenedProductInner(string location = default(string), string id = default(string), string name = default(string), string type = default(string), System.Collections.Generic.IDictionary<string, string> tags = default(System.Collections.Generic.IDictionary<string, string>), string pname = default(string), int? lsize = default(int?), string provisioningState = default(string))
            : base(location, id, name, type, tags)
        {
            Pname = pname;
            Lsize = lsize;
            ProvisioningState = provisioningState;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties.pname")]
        public string Pname { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties.lsize")]
        public int? Lsize { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; set; }

    }
}
