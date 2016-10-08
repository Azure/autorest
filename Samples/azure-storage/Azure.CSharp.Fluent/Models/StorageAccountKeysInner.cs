
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The access keys for the storage account.
    /// </summary>
    public partial class StorageAccountKeysInner
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccountKeysInner class.
        /// </summary>
        public StorageAccountKeysInner() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccountKeysInner class.
        /// </summary>
        /// <param name="key1">Gets the value of key 1.</param>
        /// <param name="key2">Gets the value of key 2.</param>
        public StorageAccountKeysInner(string key1 = default(string), string key2 = default(string))
        {
            Key1 = key1;
            Key2 = key2;
        }

        /// <summary>
        /// Gets the value of key 1.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "key1")]
        public string Key1 { get; set; }

        /// <summary>
        /// Gets the value of key 2.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "key2")]
        public string Key2 { get; set; }

    }
}
