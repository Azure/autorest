// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Profile for the container service agent pool.
    /// </summary>
    public partial class ContainerServiceAgentPoolProfile
    {
        /// <summary>
        /// Initializes a new instance of the ContainerServiceAgentPoolProfile
        /// class.
        /// </summary>
        public ContainerServiceAgentPoolProfile()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ContainerServiceAgentPoolProfile
        /// class.
        /// </summary>
        /// <param name="name">Unique name of the agent pool profile in the
        /// context of the subscription and resource group.</param>
        /// <param name="count">Number of agents (VMs) to host docker
        /// containers. Allowed values must be in the range of 1 to 100
        /// (inclusive). The default value is 1. </param>
        /// <param name="vmSize">Size of agent VMs. Possible values include:
        /// 'Standard_A0', 'Standard_A1', 'Standard_A2', 'Standard_A3',
        /// 'Standard_A4', 'Standard_A5', 'Standard_A6', 'Standard_A7',
        /// 'Standard_A8', 'Standard_A9', 'Standard_A10', 'Standard_A11',
        /// 'Standard_D1', 'Standard_D2', 'Standard_D3', 'Standard_D4',
        /// 'Standard_D11', 'Standard_D12', 'Standard_D13', 'Standard_D14',
        /// 'Standard_D1_v2', 'Standard_D2_v2', 'Standard_D3_v2',
        /// 'Standard_D4_v2', 'Standard_D5_v2', 'Standard_D11_v2',
        /// 'Standard_D12_v2', 'Standard_D13_v2', 'Standard_D14_v2',
        /// 'Standard_G1', 'Standard_G2', 'Standard_G3', 'Standard_G4',
        /// 'Standard_G5', 'Standard_DS1', 'Standard_DS2', 'Standard_DS3',
        /// 'Standard_DS4', 'Standard_DS11', 'Standard_DS12', 'Standard_DS13',
        /// 'Standard_DS14', 'Standard_GS1', 'Standard_GS2', 'Standard_GS3',
        /// 'Standard_GS4', 'Standard_GS5'</param>
        /// <param name="dnsPrefix">DNS prefix to be used to create the FQDN
        /// for the agent pool.</param>
        /// <param name="fqdn">FDQN for the agent pool.</param>
        public ContainerServiceAgentPoolProfile(string name, int count, string vmSize, string dnsPrefix, string fqdn = default(string))
        {
            Name = name;
            Count = count;
            VmSize = vmSize;
            DnsPrefix = dnsPrefix;
            Fqdn = fqdn;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets unique name of the agent pool profile in the context
        /// of the subscription and resource group.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets number of agents (VMs) to host docker containers.
        /// Allowed values must be in the range of 1 to 100 (inclusive). The
        /// default value is 1.
        /// </summary>
        [JsonProperty(PropertyName = "count")]
        public int Count { get; set; }

        /// <summary>
        /// Gets or sets size of agent VMs. Possible values include:
        /// 'Standard_A0', 'Standard_A1', 'Standard_A2', 'Standard_A3',
        /// 'Standard_A4', 'Standard_A5', 'Standard_A6', 'Standard_A7',
        /// 'Standard_A8', 'Standard_A9', 'Standard_A10', 'Standard_A11',
        /// 'Standard_D1', 'Standard_D2', 'Standard_D3', 'Standard_D4',
        /// 'Standard_D11', 'Standard_D12', 'Standard_D13', 'Standard_D14',
        /// 'Standard_D1_v2', 'Standard_D2_v2', 'Standard_D3_v2',
        /// 'Standard_D4_v2', 'Standard_D5_v2', 'Standard_D11_v2',
        /// 'Standard_D12_v2', 'Standard_D13_v2', 'Standard_D14_v2',
        /// 'Standard_G1', 'Standard_G2', 'Standard_G3', 'Standard_G4',
        /// 'Standard_G5', 'Standard_DS1', 'Standard_DS2', 'Standard_DS3',
        /// 'Standard_DS4', 'Standard_DS11', 'Standard_DS12', 'Standard_DS13',
        /// 'Standard_DS14', 'Standard_GS1', 'Standard_GS2', 'Standard_GS3',
        /// 'Standard_GS4', 'Standard_GS5'
        /// </summary>
        [JsonProperty(PropertyName = "vmSize")]
        public string VmSize { get; set; }

        /// <summary>
        /// Gets or sets DNS prefix to be used to create the FQDN for the agent
        /// pool.
        /// </summary>
        [JsonProperty(PropertyName = "dnsPrefix")]
        public string DnsPrefix { get; set; }

        /// <summary>
        /// Gets FDQN for the agent pool.
        /// </summary>
        [JsonProperty(PropertyName = "fqdn")]
        public string Fqdn { get; private set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Name");
            }
            if (VmSize == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "VmSize");
            }
            if (DnsPrefix == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "DnsPrefix");
            }
            if (Count > 100)
            {
                throw new ValidationException(ValidationRules.InclusiveMaximum, "Count", 100);
            }
            if (Count < 1)
            {
                throw new ValidationException(ValidationRules.InclusiveMinimum, "Count", 1);
            }
        }
    }
}
