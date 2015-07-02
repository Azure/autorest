namespace Fixtures.PetstoreV2.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;

    /// <summary>
    /// </summary>
    public partial class Pet
    {
        /// <summary>
        /// </summary>
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
        /// </summary>
        [JsonProperty(PropertyName = "sByte")]
        public byte[] SByteProperty { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "birthday")]
        public DateTime? Birthday { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "dictionary")]
        public IDictionary<string, Category> Dictionary { get; set; }

        /// <summary>
        /// pet status in the store. Possible values for this property
        /// include: 'available', 'pending', 'sold'
        /// </summary>
        [JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
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
            if (this.Category != null)
            {
                this.Category.Validate();
            }
            if (this.Tags != null)
            {
                foreach ( var element1 in this.Tags)
            {
                if (element1 != null)
            {
                element1.Validate();
            }
            }
            }
            if (this.Dictionary != null)
            {
                if ( this.Dictionary != null)
            {
                foreach ( var valueElement in this.Dictionary.Values)
                {
                    if (valueElement != null)
            {
                valueElement.Validate();
            }
                }
            }
            }
        }
    }
}
