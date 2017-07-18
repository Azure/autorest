// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsLro;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    [JsonTransformation]
    public partial class ProductInner : Microsoft.Rest.Azure.Resource
    {
        /// <summary>
        /// Initializes a new instance of the ProductInner class.
        /// </summary>
        public ProductInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ProductInner class.
        /// </summary>
        /// <param name="provisioningStateValues">Possible values include:
        /// 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating',
        /// 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted',
        /// 'OK'</param>
        public ProductInner(string location = default(string), string id = default(string), string name = default(string), string type = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>), string provisioningState = default(string), string provisioningStateValues = default(string))
            : base(location, id, name, type, tags)
        {
            ProvisioningState = provisioningState;
            ProvisioningStateValues = provisioningStateValues;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; set; }

        /// <summary>
        /// Gets possible values include: 'Succeeded', 'Failed', 'canceled',
        /// 'Accepted', 'Creating', 'Created', 'Updating', 'Updated',
        /// 'Deleting', 'Deleted', 'OK'
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningStateValues")]
        public string ProvisioningStateValues { get; private set; }

    }
}
