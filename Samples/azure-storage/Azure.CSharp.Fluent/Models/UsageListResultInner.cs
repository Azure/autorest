
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The List Usages operation response.
    /// </summary>
    public partial class UsageListResultInner
    {
        /// <summary>
        /// Initializes a new instance of the UsageListResultInner class.
        /// </summary>
        public UsageListResultInner() { }

        /// <summary>
        /// Initializes a new instance of the UsageListResultInner class.
        /// </summary>
        /// <param name="value">Gets or sets the list Storage Resource
        /// Usages.</param>
        public UsageListResultInner(System.Collections.Generic.IList<Usage> value = default(System.Collections.Generic.IList<Usage>))
        {
            Value = value;
        }

        /// <summary>
        /// Gets or sets the list Storage Resource Usages.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public System.Collections.Generic.IList<Usage> Value { get; set; }

    }
}
