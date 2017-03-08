
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    public partial class StorageAccountPropertiesCreateParameters
    {
        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesCreateParameters class.
        /// </summary>
        public StorageAccountPropertiesCreateParameters()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// StorageAccountPropertiesCreateParameters class.
        /// </summary>
        /// <param name="accountType">Gets or sets the account type. Possible
        /// values include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
        /// 'Standard_RAGRS', 'Premium_LRS'</param>
        public StorageAccountPropertiesCreateParameters(AccountType accountType)
        {
            AccountType = accountType;
            CustomInit();
        }

        /// <summary>
        /// an initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the account type. Possible values include:
        /// 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
        /// 'Premium_LRS'
        /// </summary>
        [JsonProperty(PropertyName = "accountType")]
        public AccountType AccountType { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
        }
    }
}
