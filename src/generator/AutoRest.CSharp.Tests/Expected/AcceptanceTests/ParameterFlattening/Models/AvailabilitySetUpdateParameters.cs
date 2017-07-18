// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.AcceptanceTestsParameterFlattening.Models
{
    using Fixtures.AcceptanceTestsParameterFlattening;
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class AvailabilitySetUpdateParameters
    {
        /// <summary>
        /// Initializes a new instance of the AvailabilitySetUpdateParameters
        /// class.
        /// </summary>
        public AvailabilitySetUpdateParameters()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the AvailabilitySetUpdateParameters
        /// class.
        /// </summary>
        /// <param name="tags">A set of tags.</param>
        public AvailabilitySetUpdateParameters(IDictionary<string, string> tags)
        {
            Tags = tags;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets a set of tags.
        /// </summary>
        /// <remarks>
        /// A description about the set of tags.
        /// </remarks>
        [JsonProperty(PropertyName = "tags")]
        public IDictionary<string, string> Tags { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Tags == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Tags");
            }
        }
    }
}
