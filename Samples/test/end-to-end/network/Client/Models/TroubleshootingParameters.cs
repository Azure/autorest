// Code generated by Microsoft (R) AutoRest Code Generator 1.1.0.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Parameters that define the resource to troubleshoot.
    /// </summary>
    [JsonTransformation]
    public partial class TroubleshootingParameters
    {
        /// <summary>
        /// Initializes a new instance of the TroubleshootingParameters class.
        /// </summary>
        public TroubleshootingParameters()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the TroubleshootingParameters class.
        /// </summary>
        /// <param name="targetResourceId">The target resource to
        /// troubleshoot.</param>
        /// <param name="storageId">The ID for the storage account to save the
        /// troubleshoot result.</param>
        /// <param name="storagePath">The path to the blob to save the
        /// troubleshoot result in.</param>
        public TroubleshootingParameters(string targetResourceId, string storageId, string storagePath)
        {
            TargetResourceId = targetResourceId;
            StorageId = storageId;
            StoragePath = storagePath;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the target resource to troubleshoot.
        /// </summary>
        [JsonProperty(PropertyName = "targetResourceId")]
        public string TargetResourceId { get; set; }

        /// <summary>
        /// Gets or sets the ID for the storage account to save the
        /// troubleshoot result.
        /// </summary>
        [JsonProperty(PropertyName = "properties.storageId")]
        public string StorageId { get; set; }

        /// <summary>
        /// Gets or sets the path to the blob to save the troubleshoot result
        /// in.
        /// </summary>
        [JsonProperty(PropertyName = "properties.storagePath")]
        public string StoragePath { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (TargetResourceId == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "TargetResourceId");
            }
            if (StorageId == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "StorageId");
            }
            if (StoragePath == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "StoragePath");
            }
        }
    }
}
