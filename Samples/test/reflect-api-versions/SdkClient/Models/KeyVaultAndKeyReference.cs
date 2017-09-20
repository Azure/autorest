// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Key Vault Key Url and vault id of KeK, KeK is optional and when
    /// provided is used to unwrap the encryptionKey
    /// </summary>
    public partial class KeyVaultAndKeyReference
    {
        /// <summary>
        /// Initializes a new instance of the KeyVaultAndKeyReference class.
        /// </summary>
        public KeyVaultAndKeyReference()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the KeyVaultAndKeyReference class.
        /// </summary>
        /// <param name="sourceVault">Resource id of the KeyVault containing
        /// the key or secret</param>
        /// <param name="keyUrl">Url pointing to a key or secret in
        /// KeyVault</param>
        public KeyVaultAndKeyReference(SourceVault sourceVault, string keyUrl)
        {
            SourceVault = sourceVault;
            KeyUrl = keyUrl;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets resource id of the KeyVault containing the key or
        /// secret
        /// </summary>
        [JsonProperty(PropertyName = "sourceVault")]
        public SourceVault SourceVault { get; set; }

        /// <summary>
        /// Gets or sets url pointing to a key or secret in KeyVault
        /// </summary>
        [JsonProperty(PropertyName = "keyUrl")]
        public string KeyUrl { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (SourceVault == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "SourceVault");
            }
            if (KeyUrl == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "KeyUrl");
            }
        }
    }
}
