// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		
    using Microsoft.Rest.Azure;		

    [Microsoft.Rest.Serialization.JsonTransformation]
    public partial class SubProduct : SubResource
    {
        /// <summary>
        /// Initializes a new instance of the SubProduct class.
        /// </summary>
        public SubProduct() { }

        /// <summary>
        /// Initializes a new instance of the SubProduct class.
        /// </summary>
        /// <param name="id">Sub Resource Id</param>
        /// <param name="provisioningStateValues">Possible values include:
        /// 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating',
        /// 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted',
        /// 'OK'</param>
        public SubProduct(string id = default(string), string provisioningState = default(string), string provisioningStateValues = default(string))
            : base(id)
        {
            ProvisioningState = provisioningState;
            ProvisioningStateValues = provisioningStateValues;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; set; }

        /// <summary>
        /// Gets possible values include: 'Succeeded', 'Failed', 'canceled',
        /// 'Accepted', 'Creating', 'Created', 'Updating', 'Updated',
        /// 'Deleting', 'Deleted', 'OK'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties.provisioningStateValues")]
        public string ProvisioningStateValues { get; private set; }

    }
}
