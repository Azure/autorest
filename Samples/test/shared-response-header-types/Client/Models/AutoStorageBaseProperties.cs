// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace SharedHeaders.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The properties related to the auto-storage account.
    /// </summary>
    public partial class AutoStorageBaseProperties
    {
        /// <summary>
        /// Initializes a new instance of the AutoStorageBaseProperties class.
        /// </summary>
        public AutoStorageBaseProperties()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the AutoStorageBaseProperties class.
        /// </summary>
        /// <param name="storageAccountId">The resource ID of the storage
        /// account to be used for auto-storage account.</param>
        public AutoStorageBaseProperties(string storageAccountId)
        {
            StorageAccountId = storageAccountId;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the resource ID of the storage account to be used for
        /// auto-storage account.
        /// </summary>
        [JsonProperty(PropertyName = "storageAccountId")]
        public string StorageAccountId { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (StorageAccountId == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "StorageAccountId");
            }
        }
    }
}
