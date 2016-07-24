
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The access keys for the storage account.
    /// </summary>
    public partial class StorageAccountKeys
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountKeys class.
        /// </summary>
        public StorageAccountKeys() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountKeys class.
        /// </summary>
        /// <param name="key1">Gets the value of key 1.</param>
        /// <param name="key2">Gets the value of key 2.</param>
        public StorageAccountKeys(System.String key1 = default(System.String), System.String key2 = default(System.String))
        {
            Key1 = key1;
            Key2 = key2;
        }

        /// <summary>
        /// Gets the value of key 1.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "key1")]
        public System.String Key1 { get; set; }

        /// <summary>
        /// Gets the value of key 2.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "key2")]
        public System.String Key2 { get; set; }

    }
}
