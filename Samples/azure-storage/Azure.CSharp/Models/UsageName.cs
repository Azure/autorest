
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The Usage Names.
    /// </summary>
    public partial class UsageName
    {
        /// <summary>
        /// Initializes a new instance of the UsageName class.
        /// </summary>
        public UsageName() { }

        /// <summary>
        /// Initializes a new instance of the UsageName class.
        /// </summary>
        /// <param name="value">Gets a string describing the resource
        /// name.</param>
        /// <param name="localizedValue">Gets a localized string describing
        /// the resource name.</param>
        public UsageName(System.String value = default(System.String), System.String localizedValue = default(System.String))
        {
            Value = value;
            LocalizedValue = localizedValue;
        }

        /// <summary>
        /// Gets a string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public System.String Value { get; set; }

        /// <summary>
        /// Gets a localized string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "localizedValue")]
        public System.String LocalizedValue { get; set; }

    }
}
