// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Contains bgp community information offered in Service Community
    /// resources.
    /// </summary>
    public partial class BGPCommunity
    {
        /// <summary>
        /// Initializes a new instance of the BGPCommunity class.
        /// </summary>
        public BGPCommunity()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the BGPCommunity class.
        /// </summary>
        /// <param name="serviceSupportedRegion">The region which the service
        /// support. e.g. For O365, region is Global.</param>
        /// <param name="communityName">The name of the bgp community. e.g.
        /// Skype.</param>
        /// <param name="communityValue">The value of the bgp community. For
        /// more information:
        /// https://docs.microsoft.com/en-us/azure/expressroute/expressroute-routing.</param>
        /// <param name="communityPrefixes">The prefixes that the bgp community
        /// contains.</param>
        public BGPCommunity(string serviceSupportedRegion = default(string), string communityName = default(string), string communityValue = default(string), IList<string> communityPrefixes = default(IList<string>))
        {
            ServiceSupportedRegion = serviceSupportedRegion;
            CommunityName = communityName;
            CommunityValue = communityValue;
            CommunityPrefixes = communityPrefixes;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the region which the service support. e.g. For O365,
        /// region is Global.
        /// </summary>
        [JsonProperty(PropertyName = "serviceSupportedRegion")]
        public string ServiceSupportedRegion { get; set; }

        /// <summary>
        /// Gets or sets the name of the bgp community. e.g. Skype.
        /// </summary>
        [JsonProperty(PropertyName = "communityName")]
        public string CommunityName { get; set; }

        /// <summary>
        /// Gets or sets the value of the bgp community. For more information:
        /// https://docs.microsoft.com/en-us/azure/expressroute/expressroute-routing.
        /// </summary>
        [JsonProperty(PropertyName = "communityValue")]
        public string CommunityValue { get; set; }

        /// <summary>
        /// Gets or sets the prefixes that the bgp community contains.
        /// </summary>
        [JsonProperty(PropertyName = "communityPrefixes")]
        public IList<string> CommunityPrefixes { get; set; }

    }
}
