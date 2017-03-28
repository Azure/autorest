
namespace Petstore.Models
{
    using System.Linq;

    public partial class Category
    {
        /// <summary>
        /// Initializes a new instance of the Category class.
        /// </summary>
        public Category()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Category class.
        /// </summary>
        public Category(long? id = default(long?), string name = default(string))
        {
            this.Id = id;
            this.Name = name;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public long? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal System.Xml.Linq.XElement XmlSerialize(System.Xml.Linq.XElement result)
        {
            if( null != Id )
            {
                result.Add(new System.Xml.Linq.XElement("id", Id) );
            }
            if( null != Name )
            {
                result.Add(new System.Xml.Linq.XElement("name", Name) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of Category
        /// </summary>
        internal static Category XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( System.Xml.Linq.XElement.Parse( payload ) );
        }
        internal static Category XmlDeserialize(System.Xml.Linq.XElement payload)
        {
            var result = new Category();
            var deserializeId = XmlSerialization.ToDeserializer(e => (long?)e);
            long? resultId;
            if (deserializeId(payload, "id", out resultId))
            {
                result.Id = resultId;
            }
            var deserializeName = XmlSerialization.ToDeserializer(e => (string)e);
            string resultName;
            if (deserializeName(payload, "name", out resultName))
            {
                result.Name = resultName;
            }
            return result;
        }
    }
}
