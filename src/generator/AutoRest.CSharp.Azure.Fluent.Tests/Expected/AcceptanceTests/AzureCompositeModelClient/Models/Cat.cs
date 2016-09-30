// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using System.Linq;

    public partial class Cat : Pet
    {
        /// <summary>
        /// Initializes a new instance of the Cat class.
        /// </summary>
        public Cat() { }

        /// <summary>
        /// Initializes a new instance of the Cat class.
        /// </summary>
        public Cat(int? id = default(int?), string name = default(string), string color = default(string), System.Collections.Generic.IList<Dog> hates = default(System.Collections.Generic.IList<Dog>))
            : base(id, name)
        {
            Color = color;
            Hates = hates;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "color")]
        public string Color { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "hates")]
        public System.Collections.Generic.IList<Dog> Hates { get; set; }

    }
}
