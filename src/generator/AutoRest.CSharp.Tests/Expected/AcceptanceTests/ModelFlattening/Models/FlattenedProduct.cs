// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsModelFlattening.Models
{
    using Fixtures.AcceptanceTestsModelFlattening;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Flattened product.
    /// <see href="http://tempuri.org" />
    /// </summary>
    [JsonTransformation]
    public partial class FlattenedProduct : Resource
    {
        /// <summary>
        /// Initializes a new instance of the FlattenedProduct class.
        /// </summary>
        public FlattenedProduct()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the FlattenedProduct class.
        /// </summary>
        /// <param name="id">Resource Id</param>
        /// <param name="type">Resource Type</param>
        /// <param name="location">Resource Location</param>
        /// <param name="name">Resource Name</param>
        /// <param name="provisioningStateValues">Possible values include:
        /// 'Succeeded', 'Failed', 'canceled', 'Accepted', 'Creating',
        /// 'Created', 'Updating', 'Updated', 'Deleting', 'Deleted',
        /// 'OK'</param>
        public FlattenedProduct(string id = default(string), string type = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>), string location = default(string), string name = default(string), string pname = default(string), string flattenedProductType = default(string), string provisioningStateValues = default(string), string provisioningState = default(string))
            : base(id, type, tags, location, name)
        {
            Pname = pname;
            FlattenedProductType = flattenedProductType;
            ProvisioningStateValues = provisioningStateValues;
            ProvisioningState = provisioningState;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.p\\.name")]
        public string Pname { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.type")]
        public string FlattenedProductType { get; set; }

        /// <summary>
        /// Gets possible values include: 'Succeeded', 'Failed', 'canceled',
        /// 'Accepted', 'Creating', 'Created', 'Updating', 'Updated',
        /// 'Deleting', 'Deleted', 'OK'
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningStateValues")]
        public string ProvisioningStateValues { get; private set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; set; }

    }
}
