// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The List Availability Set operation response.
    /// </summary>
    public partial class AvailabilitySetListResult
    {
        /// <summary>
        /// Initializes a new instance of the AvailabilitySetListResult class.
        /// </summary>
        public AvailabilitySetListResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the AvailabilitySetListResult class.
        /// </summary>
        /// <param name="value">The list of availability sets</param>
        public AvailabilitySetListResult(IList<AvailabilitySet> value = default(IList<AvailabilitySet>))
        {
            Value = value;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the list of availability sets
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<AvailabilitySet> Value { get; set; }

    }
}
