// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// Disk resource.
    /// </summary>
    [JsonTransformation]
    public partial class Disk : Resource
    {
        /// <summary>
        /// Initializes a new instance of the Disk class.
        /// </summary>
        public Disk()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Disk class.
        /// </summary>
        /// <param name="location">Resource location</param>
        /// <param name="creationData">Disk source information. CreationData
        /// information cannot be changed after the disk has been
        /// created.</param>
        /// <param name="id">Resource Id</param>
        /// <param name="name">Resource name</param>
        /// <param name="type">Resource type</param>
        /// <param name="tags">Resource tags</param>
        /// <param name="managedBy">A relative URI containing the ID of the VM
        /// that has the disk attached.</param>
        /// <param name="timeCreated">The time when the disk was
        /// created.</param>
        /// <param name="osType">The Operating System type. Possible values
        /// include: 'Windows', 'Linux'</param>
        /// <param name="diskSizeGB">If creationData.createOption is Empty,
        /// this field is mandatory and it indicates the size of the VHD to
        /// create. If this field is present for updates or creation with other
        /// options, it indicates a resize. Resizes are only allowed if the
        /// disk is not attached to a running VM, and can only increase the
        /// disk's size.</param>
        /// <param name="encryptionSettings">Encryption settings for disk or
        /// snapshot</param>
        /// <param name="provisioningState">The disk provisioning
        /// state.</param>
        public Disk(string location, CreationData creationData, string id = default(string), string name = default(string), string type = default(string), IDictionary<string, string> tags = default(IDictionary<string, string>), string managedBy = default(string), DiskSku sku = default(DiskSku), System.DateTime? timeCreated = default(System.DateTime?), OperatingSystemTypes? osType = default(OperatingSystemTypes?), int? diskSizeGB = default(int?), EncryptionSettings encryptionSettings = default(EncryptionSettings), string provisioningState = default(string))
            : base(location, id, name, type, tags)
        {
            ManagedBy = managedBy;
            Sku = sku;
            TimeCreated = timeCreated;
            OsType = osType;
            CreationData = creationData;
            DiskSizeGB = diskSizeGB;
            EncryptionSettings = encryptionSettings;
            ProvisioningState = provisioningState;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets a relative URI containing the ID of the VM that has the disk
        /// attached.
        /// </summary>
        [JsonProperty(PropertyName = "managedBy")]
        public string ManagedBy { get; private set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "sku")]
        public DiskSku Sku { get; set; }

        /// <summary>
        /// Gets the time when the disk was created.
        /// </summary>
        [JsonProperty(PropertyName = "properties.timeCreated")]
        public System.DateTime? TimeCreated { get; private set; }

        /// <summary>
        /// Gets or sets the Operating System type. Possible values include:
        /// 'Windows', 'Linux'
        /// </summary>
        [JsonProperty(PropertyName = "properties.osType")]
        public OperatingSystemTypes? OsType { get; set; }

        /// <summary>
        /// Gets or sets disk source information. CreationData information
        /// cannot be changed after the disk has been created.
        /// </summary>
        [JsonProperty(PropertyName = "properties.creationData")]
        public CreationData CreationData { get; set; }

        /// <summary>
        /// Gets or sets if creationData.createOption is Empty, this field is
        /// mandatory and it indicates the size of the VHD to create. If this
        /// field is present for updates or creation with other options, it
        /// indicates a resize. Resizes are only allowed if the disk is not
        /// attached to a running VM, and can only increase the disk's size.
        /// </summary>
        [JsonProperty(PropertyName = "properties.diskSizeGB")]
        public int? DiskSizeGB { get; set; }

        /// <summary>
        /// Gets or sets encryption settings for disk or snapshot
        /// </summary>
        [JsonProperty(PropertyName = "properties.encryptionSettings")]
        public EncryptionSettings EncryptionSettings { get; set; }

        /// <summary>
        /// Gets the disk provisioning state.
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; private set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public override void Validate()
        {
            base.Validate();
            if (CreationData == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "CreationData");
            }
            if (CreationData != null)
            {
                CreationData.Validate();
            }
            if (EncryptionSettings != null)
            {
                EncryptionSettings.Validate();
            }
        }
    }
}
