// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using AcceptanceTestsAzureCompositeModelClient;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Dog : Pet
    {
        /// <summary>
        /// Initializes a new instance of the Dog class.
        /// </summary>
        public Dog() { }

        /// <summary>
        /// Initializes a new instance of the Dog class.
        /// </summary>
        public Dog(int? id = default(int?), string name = default(string), string food = default(string))
            : base(id, name)
        {
            Food = food;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "food")]
        public string Food { get; set; }

    }
}
