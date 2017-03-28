
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
        public Pet()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Pet class.
        /// </summary>
        /// <param name="id">The id of the pet.</param>
        /// <param name="status">pet status in the store. Possible values
        /// include: 'available', 'pending', 'sold'</param>
        public Pet(string name, System.Collections.Generic.IList<string> photoUrls, long? id = default(long?), Category category = default(Category), System.Collections.Generic.IList<Tag> tags = default(System.Collections.Generic.IList<Tag>), string status = default(string))
        {
            this.Id = id;
            this.Category = category;
            this.Name = name;
            this.PhotoUrls = photoUrls;
            this.Tags = tags;
            this.Status = status;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

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
            if (this.Name == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Name");
            }
            if (this.PhotoUrls == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "PhotoUrls");
            }
        }
        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal System.Xml.Linq.XElement XmlSerialize(System.Xml.Linq.XElement result)
        {
            if( null != Id )
            {
                result.Add(new System.Xml.Linq.XElement("id", Id) );
            }
            if( null != Category )
            {
                result.Add(Category.XmlSerialize(new System.Xml.Linq.XElement( "category" )));
            }
            if( null != Name )
            {
                result.Add(new System.Xml.Linq.XElement("name", Name) );
            }
            if( null != PhotoUrls )
            {
                var seq = new System.Xml.Linq.XElement("photoUrl");
                foreach( var value in PhotoUrls ){
                    seq.Add(new System.Xml.Linq.XElement( "photoUrl", value ) );
                }
                result.Add(seq);
            }
            if( null != Tags )
            {
                var seq = new System.Xml.Linq.XElement("tag");
                foreach( var value in Tags ){
                    seq.Add(value.XmlSerialize( new System.Xml.Linq.XElement( "tag") ) );
                }
                result.Add(seq);
            }
            if( null != Status )
            {
                result.Add(new System.Xml.Linq.XElement("status", Status) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of Pet
        /// </summary>
        internal static Pet XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( System.Xml.Linq.XElement.Parse( payload ) );
        }
        internal static Pet XmlDeserialize(System.Xml.Linq.XElement payload)
        {
            var result = new Pet();
            var deserializeId = XmlSerialization.ToDeserializer(e => (long?)e);
            long? resultId;
            if (deserializeId(payload, "id", out resultId))
            {
                result.Id = resultId;
            }
            var deserializeCategory = XmlSerialization.ToDeserializer(e => Category.XmlDeserialize(e));
            Category resultCategory;
            if (deserializeCategory(payload, "category", out resultCategory))
            {
                result.Category = resultCategory;
            }
            var deserializeName = XmlSerialization.ToDeserializer(e => (string)e);
            string resultName;
            if (deserializeName(payload, "name", out resultName))
            {
                result.Name = resultName;
            }
            var deserializePhotoUrls = XmlSerialization.CreateListXmlDeserializer(XmlSerialization.ToDeserializer(e => (string)e), "photoUrl");
            System.Collections.Generic.IList<string> resultPhotoUrls;
            if (deserializePhotoUrls(payload, "photoUrl", out resultPhotoUrls))
            {
                result.PhotoUrls = resultPhotoUrls;
            }
            var deserializeTags = XmlSerialization.CreateListXmlDeserializer(XmlSerialization.ToDeserializer(e => Tag.XmlDeserialize(e)), "tag");
            System.Collections.Generic.IList<Tag> resultTags;
            if (deserializeTags(payload, "tag", out resultTags))
            {
                result.Tags = resultTags;
            }
            var deserializeStatus = XmlSerialization.ToDeserializer(e => (string)e);
            string resultStatus;
            if (deserializeStatus(payload, "status", out resultStatus))
            {
                result.Status = resultStatus;
            }
            return result;
        }
    }
}
