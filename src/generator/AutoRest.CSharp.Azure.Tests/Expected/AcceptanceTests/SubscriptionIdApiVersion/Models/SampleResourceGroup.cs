// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsSubscriptionIdApiVersion.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsSubscriptionIdApiVersion;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class SampleResourceGroup
    {
        /// <summary>
        /// Initializes a new instance of the SampleResourceGroup class.
        /// </summary>
        public SampleResourceGroup()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SampleResourceGroup class.
        /// </summary>
        /// <param name="name">resource group name 'testgroup101'</param>
        /// <param name="location">resource group location 'West US'</param>
        public SampleResourceGroup(string name = default(string), string location = default(string))
        {
            Name = name;
            Location = location;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets resource group name 'testgroup101'
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets resource group location 'West US'
        /// </summary>
        [JsonProperty(PropertyName = "location")]
        public string Location { get; set; }

    }
}
