// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace CSharpNamespace.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class Pet
    {
        /// <summary>
        /// Initializes a new instance of the Pet class.
        /// </summary>
        public Pet()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Pet class.
        /// </summary>
        public Pet(long id, string name, string tag = default(string))
        {
            Id = id;
            Name = name;
            Tag = tag;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public long Id { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "tag")]
        public string Tag { get; set; }

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
        }
    }
}
