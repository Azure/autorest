
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// A pet
    /// </summary>
    /// <remarks>
    /// A group of properties representing a pet.
    /// </remarks>
    public partial class Pet
    {
        /// <summary>
        /// Initializes a new instance of the Pet class.
        /// </summary>
        public Pet() { }

        /// <summary>
        /// Initializes a new instance of the Pet class.
        /// </summary>
        /// <param name="id">The id of the pet.</param>
        /// <param name="status">pet status in the store. Possible values
        /// include: 'available', 'pending', 'sold'</param>
        public Pet(string name, System.Collections.Generic.IList<string> photoUrls, long? id = default(long?), Category category = default(Category), System.Collections.Generic.IList<Tag> tags = default(System.Collections.Generic.IList<Tag>), string status = default(string))
        {
            Id = id;
            Category = category;
            Name = name;
            PhotoUrls = photoUrls;
            Tags = tags;
            Status = status;
        }

        /// <summary>
        /// Gets or sets the id of the pet.
        /// </summary>
        /// <remarks>
        /// A more detailed description of the id of the pet.
        /// </remarks>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public long? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "category")]
        public Category Category { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "photoUrls")]
        public System.Collections.Generic.IList<string> PhotoUrls { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "tags")]
        public System.Collections.Generic.IList<Tag> Tags { get; set; }

        /// <summary>
        /// Gets or sets pet status in the store. Possible values include:
        /// 'available', 'pending', 'sold'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Name");
            }
            if (PhotoUrls == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "PhotoUrls");
            }
        }
    }
}
