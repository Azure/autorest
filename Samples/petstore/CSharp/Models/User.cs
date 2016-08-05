
namespace Petstore.Models
{
    using System.Linq;

    public partial class User
    {
        /// <summary>
        /// Initializes a new instance of the User class.
        /// </summary>
        public User() { }

        /// <summary>
        /// Initializes a new instance of the User class.
        /// </summary>
        /// <param name="userStatus">User Status</param>
        public User(System.Int64? id = default(System.Int64?), System.String username = default(System.String), System.String firstName = default(System.String), System.String lastName = default(System.String), System.String email = default(System.String), System.String password = default(System.String), System.String phone = default(System.String), System.Int32? userStatus = default(System.Int32?))
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            Password = password;
            Phone = phone;
            UserStatus = userStatus;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public System.Int64? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "username")]
        public System.String Username { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "firstName")]
        public System.String FirstName { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "lastName")]
        public System.String LastName { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "email")]
        public System.String Email { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "password")]
        public System.String Password { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "phone")]
        public System.String Phone { get; set; }

        /// <summary>
        /// Gets or sets user Status
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "userStatus")]
        public System.Int32? UserStatus { get; set; }

    }
}
