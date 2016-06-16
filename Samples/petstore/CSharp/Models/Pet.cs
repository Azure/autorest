
namespace Petstore.Models
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

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
        public Pet(string name, IList<string> photoUrls, long? id = default(long?), Category category = default(Category), IList<Tag> tags = default(IList<Tag>), string status = default(string))
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
        [JsonProperty(PropertyName = "id")]
        public long? Id { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "category")]
        public Category Category { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "photoUrls")]
        public IList<string> PhotoUrls { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "tags")]
        public IList<Tag> Tags { get; set; }

        /// <summary>
        /// Gets or sets pet status in the store. Possible values include:
        /// 'available', 'pending', 'sold'
        /// </summary>
        [JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Name");
            }
            if (PhotoUrls == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "PhotoUrls");
            }
        }
    }
}
