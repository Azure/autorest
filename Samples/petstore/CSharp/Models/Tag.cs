
namespace Petstore.Models
{
    using System.Linq;

    public partial class Tag
    {
        /// <summary>
        /// Initializes a new instance of the Tag class.
        /// </summary>
        public Tag() { }

        /// <summary>
        /// Initializes a new instance of the Tag class.
        /// </summary>
        public Tag(long? id = default(long?), string name = default(string))
        {
            Id = id;
            Name = name;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public long? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

    }
}
