// Code generated by Microsoft (R) AutoRest Code Generator 1.0.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace searchservice.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Represents an item- or document-level indexing error.
    /// </summary>
    public partial class ItemError
    {
        /// <summary>
        /// Initializes a new instance of the ItemError class.
        /// </summary>
        public ItemError()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ItemError class.
        /// </summary>
        /// <param name="key">Gets the key of the item for which indexing
        /// failed.</param>
        /// <param name="errorMessage">Gets the message describing the error
        /// that occurred while attempting to index the item.</param>
        public ItemError(string key = default(string), string errorMessage = default(string))
        {
            Key = key;
            ErrorMessage = errorMessage;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets the key of the item for which indexing failed.
        /// </summary>
        [JsonProperty(PropertyName = "key")]
        public string Key { get; private set; }

        /// <summary>
        /// Gets the message describing the error that occurred while
        /// attempting to index the item.
        /// </summary>
        [JsonProperty(PropertyName = "errorMessage")]
        public string ErrorMessage { get; private set; }

    }
}
