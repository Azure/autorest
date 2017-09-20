// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Compute-specific operation properties, including output
    /// </summary>
    public partial class ComputeLongRunningOperationProperties
    {
        /// <summary>
        /// Initializes a new instance of the
        /// ComputeLongRunningOperationProperties class.
        /// </summary>
        public ComputeLongRunningOperationProperties()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// ComputeLongRunningOperationProperties class.
        /// </summary>
        /// <param name="output">Operation output data (raw JSON)</param>
        public ComputeLongRunningOperationProperties(object output = default(object))
        {
            Output = output;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets operation output data (raw JSON)
        /// </summary>
        [JsonProperty(PropertyName = "output")]
        public object Output { get; set; }

    }
}
