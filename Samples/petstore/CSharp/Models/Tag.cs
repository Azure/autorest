
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
        public Tag(System.Int64? id = default(System.Int64?), System.String name = default(System.String))
        {
            Id = id;
            Name = name;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public System.Int64? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public System.String Name { get; set; }

    }
}
