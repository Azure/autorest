// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.AcceptanceTestsValidation.Models
{
    using Fixtures.AcceptanceTestsValidation;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The product documentation.
    /// </summary>
    public partial class ConstantProduct
    {
        /// <summary>
        /// Initializes a new instance of the ConstantProduct class.
        /// </summary>
        public ConstantProduct()
        {
          CustomInit();
        }

        /// <summary>
        /// Static constructor for ConstantProduct class.
        /// </summary>
        static ConstantProduct()
        {
            ConstProperty = "constant";
            ConstProperty2 = "constant2";
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Constant string
        /// </summary>
        [JsonProperty(PropertyName = "constProperty")]
        public static string ConstProperty { get; private set; }

        /// <summary>
        /// Constant string2
        /// </summary>
        [JsonProperty(PropertyName = "constProperty2")]
        public static string ConstProperty2 { get; private set; }

    }
}
