// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyArray.Models
{
    using Fixtures.AcceptanceTestsBodyArray;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Product
    {
        /// <summary>
        /// Initializes a new instance of the Product class.
        /// </summary>
        public Product()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Product class.
        /// </summary>
        public Product(int? integer = default(int?), string stringProperty = default(string))
        {
            Integer = integer;
            StringProperty = stringProperty;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "integer")]
        public int? Integer { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "string")]
        public string StringProperty { get; set; }

    }
}
