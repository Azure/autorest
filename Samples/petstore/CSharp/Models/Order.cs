
namespace Petstore.Models
{
    using System.Linq;

    public partial class Order
    {
        /// <summary>
        /// Initializes a new instance of the Order class.
        /// </summary>
        public Order()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Order class.
        /// </summary>
        /// <param name="status">Order Status. Possible values include:
        /// 'placed', 'approved', 'delivered'</param>
        public Order(long? id = default(long?), long? petId = default(long?), int? quantity = default(int?), System.DateTime? shipDate = default(System.DateTime?), string status = default(string), bool? complete = default(bool?))
        {
            this.Id = id;
            this.PetId = petId;
            this.Quantity = quantity;
            this.ShipDate = shipDate;
            this.Status = status;
            this.Complete = complete;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public long? Id { get; private set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "petId")]
        public long? PetId { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "quantity")]
        public int? Quantity { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "shipDate")]
        public System.DateTime? ShipDate { get; set; }

        /// <summary>
        /// Gets or sets order Status. Possible values include: 'placed',
        /// 'approved', 'delivered'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "status")]
        public string Status { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "complete")]
        public bool? Complete { get; set; }

        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal System.Xml.Linq.XElement XmlSerialize(System.Xml.Linq.XElement result)
        {
            if( null != Id )
            {
                result.Add(new System.Xml.Linq.XElement("id", Id) );
            }
            if( null != PetId )
            {
                result.Add(new System.Xml.Linq.XElement("petId", PetId) );
            }
            if( null != Quantity )
            {
                result.Add(new System.Xml.Linq.XElement("quantity", Quantity) );
            }
            if( null != ShipDate )
            {
                result.Add(new System.Xml.Linq.XElement("shipDate", ShipDate) );
            }
            if( null != Status )
            {
                result.Add(new System.Xml.Linq.XElement("status", Status) );
            }
            if( null != Complete )
            {
                result.Add(new System.Xml.Linq.XElement("complete", Complete) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of Order
        /// </summary>
        internal static Order XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( System.Xml.Linq.XElement.Parse( payload ) );
        }
        internal static Order XmlDeserialize(System.Xml.Linq.XElement payload)
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
