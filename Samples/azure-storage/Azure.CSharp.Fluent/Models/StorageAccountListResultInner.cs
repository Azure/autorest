
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The list storage accounts operation response.
    /// </summary>
    public partial class StorageAccountListResultInner
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountListResultInner
        /// class.
        /// </summary>
        public StorageAccountListResultInner() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountListResultInner
        /// class.
        /// </summary>
        /// <param name="value">Gets the list of storage accounts and their
        /// properties.</param>
        public StorageAccountListResultInner(System.Collections.Generic.IList<StorageAccountInner> value = default(System.Collections.Generic.IList<StorageAccountInner>))
        {
            Value = value;
        }

        /// <summary>
        /// Gets the list of storage accounts and their properties.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public System.Collections.Generic.IList<StorageAccountInner> Value { get; set; }

    }
}
