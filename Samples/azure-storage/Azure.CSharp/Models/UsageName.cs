
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
        public UsageName()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the UsageName class.
        /// </summary>
        /// <param name="value">Gets a string describing the resource
        /// name.</param>
        /// <param name="localizedValue">Gets a localized string describing the
        /// resource name.</param>
        public UsageName(string value = default(string), string localizedValue = default(string))
        {
            this.Value = value;
            this.LocalizedValue = localizedValue;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets a string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public string Value { get; set; }

        /// <summary>
        /// Gets a localized string describing the resource name.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "localizedValue")]
        public string LocalizedValue { get; set; }

    }
}
