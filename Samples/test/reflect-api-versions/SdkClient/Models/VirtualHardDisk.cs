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
    /// Describes the uri of a disk.
    /// </summary>
    public partial class VirtualHardDisk
    {
        /// <summary>
        /// Initializes a new instance of the VirtualHardDisk class.
        /// </summary>
        public VirtualHardDisk()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the VirtualHardDisk class.
        /// </summary>
        /// <param name="uri">Specifies the virtual hard disk's uri.</param>
        public VirtualHardDisk(string uri = default(string))
        {
            Uri = uri;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets specifies the virtual hard disk's uri.
        /// </summary>
        [JsonProperty(PropertyName = "uri")]
        public string Uri { get; set; }

    }
}
