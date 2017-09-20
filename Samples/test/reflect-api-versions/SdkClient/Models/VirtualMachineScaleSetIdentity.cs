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
    /// Identity for the virtual machine scale set.
    /// </summary>
    public partial class VirtualMachineScaleSetIdentity
    {
        /// <summary>
        /// Initializes a new instance of the VirtualMachineScaleSetIdentity
        /// class.
        /// </summary>
        public VirtualMachineScaleSetIdentity()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the VirtualMachineScaleSetIdentity
        /// class.
        /// </summary>
        /// <param name="principalId">The principal id of virtual machine scale
        /// set identity.</param>
        /// <param name="tenantId">The tenant id associated with the virtual
        /// machine scale set.</param>
        /// <param name="type">The type of identity used for the virtual
        /// machine. Currently, the only supported type is 'SystemAssigned',
        /// which implicitly creates an identity. Possible values include:
        /// 'SystemAssigned'</param>
        public VirtualMachineScaleSetIdentity(string principalId = default(string), string tenantId = default(string), ResourceIdentityType? type = default(ResourceIdentityType?))
        {
            PrincipalId = principalId;
            TenantId = tenantId;
            Type = type;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets the principal id of virtual machine scale set identity.
        /// </summary>
        [JsonProperty(PropertyName = "principalId")]
        public string PrincipalId { get; private set; }

        /// <summary>
        /// Gets the tenant id associated with the virtual machine scale set.
        /// </summary>
        [JsonProperty(PropertyName = "tenantId")]
        public string TenantId { get; private set; }

        /// <summary>
        /// Gets or sets the type of identity used for the virtual machine.
        /// Currently, the only supported type is 'SystemAssigned', which
        /// implicitly creates an identity. Possible values include:
        /// 'SystemAssigned'
        /// </summary>
        [JsonProperty(PropertyName = "type")]
        public ResourceIdentityType? Type { get; set; }

    }
}
