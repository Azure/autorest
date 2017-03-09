
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;

    public partial class Order
    {

        /// <summary>
        /// Initializes a new instance of the Order class.
        /// </summary>
        /// <param name="status">Order Status. Possible values include:
        /// 'placed', 'approved', 'delivered'</param>
        public Order(long? id = default(long?), long? petId = default(long?), int? quantity = default(int?), System.DateTime? shipDate = default(System.DateTime?), string status = default(string), bool? complete = default(bool?))
        {
            Id = id;
            PetId = petId;
            Quantity = quantity;
            ShipDate = shipDate;
            Status = status;
            Complete = complete;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "id")]
        public long? Id { get; private set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "petId")]
        public long? PetId { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "quantity")]
        public int? Quantity { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "shipDate")]
        public System.DateTime? ShipDate { get; set; }

        /// <summary>
        /// Gets or sets order Status. Possible values include: 'placed',
        /// 'approved', 'delivered'
        /// </summary>
        [JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "complete")]
        public bool? Complete { get; set; }

        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal XElement XmlSerialize(XElement result)
        {
            if( null != Id )
            {
                result.Add(new XElement("id", Id) );
            }
            if( null != PetId )
            {
                result.Add(new XElement("petId", PetId) );
            }
            if( null != Quantity )
            {
                result.Add(new XElement("quantity", Quantity) );
            }
            if( null != ShipDate )
            {
                result.Add(new XElement("shipDate", ShipDate) );
            }
            if( null != Status )
            {
                result.Add(new XElement("status", Status) );
            }
            if( null != Complete )
            {
                result.Add(new XElement("complete", Complete) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of Order
        /// </summary>
        internal static Order XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( XElement.Parse( payload ) );
        }
        internal static Order XmlDeserialize(XElement payload)
        {
            var result = new Order();
            var deserializeId = XmlSerialization.ToDeserializer(e => (long?)e);
            long? resultId;
            if (deserializeId(payload, "id", out resultId))
            {
                result.Id = resultId;
            }
            var deserializePetId = XmlSerialization.ToDeserializer(e => (long?)e);
            long? resultPetId;
            if (deserializePetId(payload, "petId", out resultPetId))
            {
                result.PetId = resultPetId;
            }
            var deserializeQuantity = XmlSerialization.ToDeserializer(e => (int?)e);
            int? resultQuantity;
            if (deserializeQuantity(payload, "quantity", out resultQuantity))
            {
                result.Quantity = resultQuantity;
            }
            var deserializeShipDate = XmlSerialization.ToDeserializer(e => (System.DateTime?)e);
            System.DateTime? resultShipDate;
            if (deserializeShipDate(payload, "shipDate", out resultShipDate))
            {
                result.ShipDate = resultShipDate;
            }
            var deserializeStatus = XmlSerialization.ToDeserializer(e => (string)e);
            string resultStatus;
            if (deserializeStatus(payload, "status", out resultStatus))
            {
                result.Status = resultStatus;
            }
            var deserializeComplete = XmlSerialization.ToDeserializer(e => (bool?)e);
            bool? resultComplete;
            if (deserializeComplete(payload, "complete", out resultComplete))
            {
                result.Complete = resultComplete;
            }
            return result;
        }
    }
}
