// Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The information about security rules applied to the specified VM.
    /// </summary>
    public partial class SecurityGroupViewResult
    {
        /// <summary>
        /// Initializes a new instance of the SecurityGroupViewResult class.
        /// </summary>
        public SecurityGroupViewResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SecurityGroupViewResult class.
        /// </summary>
        /// <param name="networkInterfaces">List of network interfaces on the
        /// specified VM.</param>
        public SecurityGroupViewResult(IList<SecurityGroupNetworkInterface> networkInterfaces = default(IList<SecurityGroupNetworkInterface>))
        {
            NetworkInterfaces = networkInterfaces;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets list of network interfaces on the specified VM.
        /// </summary>
        [JsonProperty(PropertyName = "networkInterfaces")]
        public IList<SecurityGroupNetworkInterface> NetworkInterfaces { get; set; }

    }
}
