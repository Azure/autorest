// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsModelFlattening.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// The product documentation.
    /// </summary>
    [JsonTransformation]
    public partial class SimpleProduct : BaseProduct
    {
        /// <summary>
        /// Initializes a new instance of the SimpleProduct class.
        /// </summary>
        public SimpleProduct() { }

        /// <summary>
        /// Initializes a new instance of the SimpleProduct class.
        /// </summary>
        public SimpleProduct(string productId, string maxProductDisplayName, string description = default(string), string genericValue = default(string), string odatavalue = default(string))
            : base(productId, description)
        {
            MaxProductDisplayName = maxProductDisplayName;
            GenericValue = genericValue;
            Odatavalue = odatavalue;
        }
        /// <summary>
        /// Static constructor for SimpleProduct class.
        /// </summary>
        static SimpleProduct()
        {
            Capacity = "Large";
        }

        /// <summary>
        /// Gets or sets display name of product.
        /// </summary>
        [JsonProperty(PropertyName = "details.max_product_display_name")]
        public string MaxProductDisplayName { get; set; }

        /// <summary>
        /// Gets or sets generic URL value.
        /// </summary>
        [JsonProperty(PropertyName = "details.max_product_image.generic_value")]
        public string GenericValue { get; set; }

        /// <summary>
        /// Gets or sets URL value.
        /// </summary>
        [JsonProperty(PropertyName = "details.max_product_image.@odata\\.value")]
        public string Odatavalue { get; set; }

        /// <summary>
        /// Capacity of product. For example, 4 people.
        /// </summary>
        [JsonProperty(PropertyName = "details.max_product_capacity")]
        public static string Capacity { get; private set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public override void Validate()
        {
            base.Validate();
            if (MaxProductDisplayName == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "MaxProductDisplayName");
            }
        }
    }
}
