
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// The storage account.
    /// </summary>
    public partial class StorageAccount : Resource
    {
        /// <summary>
        /// Initializes a new instance of the StorageAccount class.
        /// </summary>
        public StorageAccount() { }

        /// <summary>
        /// Initializes a new instance of the StorageAccount class.
        /// </summary>
        /// <param name="id">Resource Id</param>
        /// <param name="name">Resource name</param>
        /// <param name="type">Resource type</param>
        /// <param name="location">Resource location</param>
        /// <param name="tags">Resource tags</param>
        public StorageAccount(System.String id = default(System.String), System.String name = default(System.String), System.String type = default(System.String), System.String location = default(System.String), System.Collections.Generic.IDictionary<System.String, System.String> tags = default(System.Collections.Generic.IDictionary<System.String, System.String>), StorageAccountProperties properties = default(StorageAccountProperties))
            : base(id, name, type, location, tags)
        {
            Properties = properties;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "properties")]
        public StorageAccountProperties Properties { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (this.Properties != null)
            {
                this.Properties.Validate();
            }
        }
    }
}
