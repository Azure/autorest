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
    using System.Linq;

    /// <summary>
    /// Additional parameters for the PutSimpleProductWithGrouping operation.
    /// </summary>
    [JsonTransformation]
    public partial class FlattenParameterGroup
    {
        /// <summary>
        /// Initializes a new instance of the FlattenParameterGroup class.
        /// </summary>
        public FlattenParameterGroup()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the FlattenParameterGroup class.
        /// </summary>
        /// <param name="name">Product name with value 'groupproduct'</param>
        /// <param name="productId">Unique identifier representing a specific
        /// product for a given latitude &amp; longitude. For example, uberX in
        /// San Francisco will have a different product_id than uberX in Los
        /// Angeles.</param>
        /// <param name="maxProductDisplayName">Display name of
        /// product.</param>
        /// <param name="description">Description of product.</param>
        /// <param name="genericValue">Generic URL value.</param>
        /// <param name="odatavalue">URL value.</param>
        public FlattenParameterGroup(string name, string productId, string maxProductDisplayName, string description = default(string), string genericValue = default(string), string odatavalue = default(string))
        {
            Name = name;
            ProductId = productId;
            Description = description;
            MaxProductDisplayName = maxProductDisplayName;
            GenericValue = genericValue;
            Odatavalue = odatavalue;
            CustomInit();
        }

        /// <summary>
        /// an Init method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets product name with value 'groupproduct'
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets unique identifier representing a specific product for
        /// a given latitude &amp;amp; longitude. For example, uberX in San
        /// Francisco will have a different product_id than uberX in Los
        /// Angeles.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string ProductId { get; set; }

        /// <summary>
        /// Gets or sets description of product.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets display name of product.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string MaxProductDisplayName { get; set; }

        /// <summary>
        /// Gets or sets generic URL value.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string GenericValue { get; set; }

        /// <summary>
        /// Gets or sets URL value.
        /// </summary>
        [JsonProperty(PropertyName = "")]
        public string Odatavalue { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Name");
            }
            if (ProductId == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "ProductId");
            }
            if (MaxProductDisplayName == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "MaxProductDisplayName");
            }
        }
    }
}
