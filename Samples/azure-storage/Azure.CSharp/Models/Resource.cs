
namespace Petstore.Models
{
    using System.Linq;

    public partial class Resource : Microsoft.Rest.Azure.IResource
    {
        /// <summary>
        /// Initializes a new instance of the Resource class.
        /// </summary>
        public Resource() { }

        /// <summary>
        /// Initializes a new instance of the Resource class.
        /// </summary>
        /// <param name="id">Resource Id</param>
        /// <param name="name">Resource name</param>
        /// <param name="type">Resource type</param>
        /// <param name="location">Resource location</param>
        /// <param name="tags">Resource tags</param>
        public Resource(System.String id = default(System.String), System.String name = default(System.String), System.String type = default(System.String), System.String location = default(System.String), System.Collections.Generic.IDictionary<System.String, System.String> tags = default(System.Collections.Generic.IDictionary<System.String, System.String>))
        {
            Id = id;
            Name = name;
            Type = type;
            Location = location;
            Tags = tags;
        }

        /// <summary>
        /// Gets resource Id
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public System.String Id { get; private set; }

        /// <summary>
        /// Gets resource name
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public System.String Name { get; private set; }

        /// <summary>
        /// Gets resource type
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "type")]
        public System.String Type { get; private set; }

        /// <summary>
        /// Gets or sets resource location
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "location")]
        public System.String Location { get; set; }

        /// <summary>
        /// Gets or sets resource tags
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "tags")]
        public System.Collections.Generic.IDictionary<System.String, System.String> Tags { get; set; }

    }
}
