// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// The Virtual Machine Scale Set List Skus operation response.
    /// </summary>
    public partial class VirtualMachineScaleSetListSkusResult
    {
        /// <summary>
        /// Initializes a new instance of the
        /// VirtualMachineScaleSetListSkusResult class.
        /// </summary>
        public VirtualMachineScaleSetListSkusResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// VirtualMachineScaleSetListSkusResult class.
        /// </summary>
        /// <param name="value">The list of skus available for the virtual
        /// machine scale set.</param>
        /// <param name="nextLink">The uri to fetch the next page of Virtual
        /// Machine Scale Set Skus. Call ListNext() with this to fetch the next
        /// page of VMSS Skus.</param>
        public VirtualMachineScaleSetListSkusResult(IList<VirtualMachineScaleSetSku> value, string nextLink = default(string))
        {
            Value = value;
            NextLink = nextLink;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the list of skus available for the virtual machine
        /// scale set.
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<VirtualMachineScaleSetSku> Value { get; set; }

        /// <summary>
        /// Gets or sets the uri to fetch the next page of Virtual Machine
        /// Scale Set Skus. Call ListNext() with this to fetch the next page of
        /// VMSS Skus.
        /// </summary>
        [JsonProperty(PropertyName = "nextLink")]
        public string NextLink { get; set; }

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
