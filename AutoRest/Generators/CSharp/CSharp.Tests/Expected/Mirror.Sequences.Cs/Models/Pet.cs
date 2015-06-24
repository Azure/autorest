namespace Fixtures.MirrorSequences.Models
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
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "styles")]
        public IList<PetStyle> Styles { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "tag")]
        public string Tag { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (Id == null)
            {
                throw new ArgumentNullException("Id");
            }
            if (Name == null)
            {
                throw new ArgumentNullException("Name");
            }
            if (this.Styles != null)
            {
                foreach ( var element in this.Styles)
            {
                if (element != null)
            {
                element.Validate();
            }
            }
            }
        }
    }
}
