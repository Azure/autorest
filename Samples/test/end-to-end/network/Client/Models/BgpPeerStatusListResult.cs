// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Response for list BGP peer status API service call
    /// </summary>
    public partial class BgpPeerStatusListResult
    {
        /// <summary>
        /// Initializes a new instance of the BgpPeerStatusListResult class.
        /// </summary>
        public BgpPeerStatusListResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the BgpPeerStatusListResult class.
        /// </summary>
        /// <param name="value">List of BGP peers</param>
        public BgpPeerStatusListResult(IList<BgpPeerStatus> value = default(IList<BgpPeerStatus>))
        {
            Value = value;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets list of BGP peers
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<BgpPeerStatus> Value { get; set; }

    }
}
