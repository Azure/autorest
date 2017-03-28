
namespace Petstore.Models
{
    using System.Linq;

    public partial class User
    {
        /// <summary>
        /// Initializes a new instance of the User class.
        /// </summary>
        public User()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the User class.
        /// </summary>
        /// <param name="userStatus">User Status</param>
        public User(long? id = default(long?), string username = default(string), string firstName = default(string), string lastName = default(string), string email = default(string), string password = default(string), string phone = default(string), int? userStatus = default(int?))
        {
            this.Id = id;
            this.Username = username;
            this.FirstName = firstName;
            this.LastName = lastName;
            this.Email = email;
            this.Password = password;
            this.Phone = phone;
            this.UserStatus = userStatus;
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
        [Newtonsoft.Json.JsonProperty(PropertyName = "username")]
        public string Username { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "firstName")]
        public string FirstName { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "lastName")]
        public string LastName { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "email")]
        public string Email { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "password")]
        public string Password { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "phone")]
        public string Phone { get; set; }

        /// <summary>
        /// Gets or sets user Status
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "userStatus")]
        public int? UserStatus { get; set; }

        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal System.Xml.Linq.XElement XmlSerialize(System.Xml.Linq.XElement result)
        {
            if( null != Id )
            {
                result.Add(new System.Xml.Linq.XElement("id", Id) );
            }
            if( null != Username )
            {
                result.Add(new System.Xml.Linq.XElement("username", Username) );
            }
            if( null != FirstName )
            {
                result.Add(new System.Xml.Linq.XElement("firstName", FirstName) );
            }
            if( null != LastName )
            {
                result.Add(new System.Xml.Linq.XElement("lastName", LastName) );
            }
            if( null != Email )
            {
                result.Add(new System.Xml.Linq.XElement("email", Email) );
            }
            if( null != Password )
            {
                result.Add(new System.Xml.Linq.XElement("password", Password) );
            }
            if( null != Phone )
            {
                result.Add(new System.Xml.Linq.XElement("phone", Phone) );
            }
            if( null != UserStatus )
            {
                result.Add(new System.Xml.Linq.XElement("userStatus", UserStatus) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of User
        /// </summary>
        internal static User XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( System.Xml.Linq.XElement.Parse( payload ) );
        }
        internal static User XmlDeserialize(System.Xml.Linq.XElement payload)
        {
            var result = new User();
            var deserializeId = XmlSerialization.ToDeserializer(e => (long?)e);
            long? resultId;
            if (deserializeId(payload, "id", out resultId))
            {
                result.Id = resultId;
            }
            var deserializeUsername = XmlSerialization.ToDeserializer(e => (string)e);
            string resultUsername;
            if (deserializeUsername(payload, "username", out resultUsername))
            {
                result.Username = resultUsername;
            }
            var deserializeFirstName = XmlSerialization.ToDeserializer(e => (string)e);
            string resultFirstName;
            if (deserializeFirstName(payload, "firstName", out resultFirstName))
            {
                result.FirstName = resultFirstName;
            }
            var deserializeLastName = XmlSerialization.ToDeserializer(e => (string)e);
            string resultLastName;
            if (deserializeLastName(payload, "lastName", out resultLastName))
            {
                result.LastName = resultLastName;
            }
            var deserializeEmail = XmlSerialization.ToDeserializer(e => (string)e);
            string resultEmail;
            if (deserializeEmail(payload, "email", out resultEmail))
            {
                result.Email = resultEmail;
            }
            var deserializePassword = XmlSerialization.ToDeserializer(e => (string)e);
            string resultPassword;
            if (deserializePassword(payload, "password", out resultPassword))
            {
                result.Password = resultPassword;
            }
            var deserializePhone = XmlSerialization.ToDeserializer(e => (string)e);
            string resultPhone;
            if (deserializePhone(payload, "phone", out resultPhone))
            {
                result.Phone = resultPhone;
            }
            var deserializeUserStatus = XmlSerialization.ToDeserializer(e => (int?)e);
            int? resultUserStatus;
            if (deserializeUserStatus(payload, "userStatus", out resultUserStatus))
            {
                result.UserStatus = resultUserStatus;
            }
            return result;
        }
    }
}
