// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Inheritance.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    public partial class SecureString
    {
        /// <summary>
        /// Initializes a new instance of the SecureString class.
        /// </summary>
        public SecureString()
        {
            CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the SecureString class.
        /// </summary>
        public SecureString(string value)
        {
            Value = value;
            CustomInit();
        }
        /// <summary>
        /// Static constructor for SecureString class.
        /// </summary>
        static SecureString()
        {
            Type = "supersecret";
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public string Value { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "type")]
        public static string Type { get; private set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Value == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Value");
            }
        }
    }
}
