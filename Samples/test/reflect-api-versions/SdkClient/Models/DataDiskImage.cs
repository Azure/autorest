// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Contains the data disk images information.
    /// </summary>
    public partial class DataDiskImage
    {
        /// <summary>
        /// Initializes a new instance of the DataDiskImage class.
        /// </summary>
        public DataDiskImage()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the DataDiskImage class.
        /// </summary>
        /// <param name="lun">Specifies the logical unit number of the data
        /// disk. This value is used to identify data disks within the VM and
        /// therefore must be unique for each data disk attached to a
        /// VM.</param>
        public DataDiskImage(int? lun = default(int?))
        {
            Lun = lun;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets specifies the logical unit number of the data disk. This value
        /// is used to identify data disks within the VM and therefore must be
        /// unique for each data disk attached to a VM.
        /// </summary>
        [JsonProperty(PropertyName = "lun")]
        public int? Lun { get; private set; }

    }
}
