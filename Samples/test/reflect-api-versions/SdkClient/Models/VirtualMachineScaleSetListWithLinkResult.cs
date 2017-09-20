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
    /// The List Virtual Machine operation response.
    /// </summary>
    public partial class VirtualMachineScaleSetListWithLinkResult
    {
        /// <summary>
        /// Initializes a new instance of the
        /// VirtualMachineScaleSetListWithLinkResult class.
        /// </summary>
        public VirtualMachineScaleSetListWithLinkResult()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// VirtualMachineScaleSetListWithLinkResult class.
        /// </summary>
        /// <param name="value">The list of virtual machine scale sets.</param>
        /// <param name="nextLink">The uri to fetch the next page of Virtual
        /// Machine Scale Sets. Call ListNext() with this to fetch the next
        /// page of Virtual Machine Scale Sets.</param>
        public VirtualMachineScaleSetListWithLinkResult(IList<VirtualMachineScaleSet> value, string nextLink = default(string))
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
        /// Gets or sets the list of virtual machine scale sets.
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<VirtualMachineScaleSet> Value { get; set; }

        /// <summary>
        /// Gets or sets the uri to fetch the next page of Virtual Machine
        /// Scale Sets. Call ListNext() with this to fetch the next page of
        /// Virtual Machine Scale Sets.
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
            if (Value != null)
            {
                foreach (var element in Value)
                {
                    if (element != null)
                    {
                        element.Validate();
                    }
                }
            }
        }
    }
}
