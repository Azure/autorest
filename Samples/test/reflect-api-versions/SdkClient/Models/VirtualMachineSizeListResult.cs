// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The List Virtual Machine operation response.
    /// </summary>
    public partial class VirtualMachineSizeListResult
    {
        /// <summary>
        /// Initializes a new instance of the VirtualMachineSizeListResult
        /// class.
        /// </summary>
        public VirtualMachineSizeListResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the VirtualMachineSizeListResult
        /// class.
        /// </summary>
        /// <param name="value">The list of virtual machine sizes.</param>
        public VirtualMachineSizeListResult(IList<VirtualMachineSize> value = default(IList<VirtualMachineSize>))
        {
            Value = value;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the list of virtual machine sizes.
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<VirtualMachineSize> Value { get; set; }

    }
}
