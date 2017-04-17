// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace applicationGateway.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Response for ListArpTable associated with the Express Route Circuits
    /// API.
    /// </summary>
    public partial class ExpressRouteCircuitsArpTableListResult
    {
        /// <summary>
        /// Initializes a new instance of the
        /// ExpressRouteCircuitsArpTableListResult class.
        /// </summary>
        public ExpressRouteCircuitsArpTableListResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// ExpressRouteCircuitsArpTableListResult class.
        /// </summary>
        /// <param name="value">Gets list of the ARP table.</param>
        /// <param name="nextLink">The URL to get the next set of
        /// results.</param>
        public ExpressRouteCircuitsArpTableListResult(IList<ExpressRouteCircuitArpTable> value = default(IList<ExpressRouteCircuitArpTable>), string nextLink = default(string))
        {
            Value = value;
            NextLink = nextLink;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets list of the ARP table.
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<ExpressRouteCircuitArpTable> Value { get; set; }

        /// <summary>
        /// Gets or sets the URL to get the next set of results.
        /// </summary>
        [JsonProperty(PropertyName = "nextLink")]
        public string NextLink { get; set; }

    }
}
