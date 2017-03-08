// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsLro;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class SubResource : IResource
    {
        /// <summary>
        /// Initializes a new instance of the SubResource class.
        /// </summary>
        public SubResource()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SubResource class.
        /// </summary>
        /// <param name="id">Sub Resource Id</param>
        public SubResource(string id = default(string))
        {
            Id = id;
            CustomInit();
        }

        /// <summary>
        /// an initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets sub Resource Id
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public string Id { get; private set; }

    }
}
