namespace Fixtures.Azure.SwaggerBatResourceFlattening.Models
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Microsoft.Azure;

    /// <summary>
    /// </summary>
    public partial class ResourceCollection
    {
        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "productresource")]
        public FlattenedProduct Productresource { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "arrayofresources")]
        public IList<FlattenedProduct> Arrayofresources { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "dictionaryofresources")]
        public IDictionary<string, FlattenedProduct> Dictionaryofresources { get; set; }

        /// <summary>
        /// Validate the object. Throws ArgumentException or ArgumentNullException if validation fails.
        /// </summary>
        public virtual void Validate()
        {
            if (this.Productresource != null)
            {
                this.Productresource.Validate();
            }
            if (this.Arrayofresources != null)
            {
                foreach ( var element in this.Arrayofresources)
            {
                if (element != null)
            {
                element.Validate();
            }
            }
            }
            if (this.Dictionaryofresources != null)
            {
                if ( this.Dictionaryofresources != null)
            {
                foreach ( var valueElement in this.Dictionaryofresources.Values)
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
