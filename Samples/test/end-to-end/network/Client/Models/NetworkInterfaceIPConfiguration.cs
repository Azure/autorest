// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// IPConfiguration in a network interface.
    /// </summary>
    [JsonTransformation]
    public partial class NetworkInterfaceIPConfiguration : SubResource
    {
        /// <summary>
        /// Initializes a new instance of the NetworkInterfaceIPConfiguration
        /// class.
        /// </summary>
        public NetworkInterfaceIPConfiguration()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the NetworkInterfaceIPConfiguration
        /// class.
        /// </summary>
        /// <param name="id">Resource ID.</param>
        /// <param name="applicationGatewayBackendAddressPools">The reference
        /// of ApplicationGatewayBackendAddressPool resource.</param>
        /// <param name="loadBalancerBackendAddressPools">The reference of
        /// LoadBalancerBackendAddressPool resource.</param>
        /// <param name="loadBalancerInboundNatRules">A list of references of
        /// LoadBalancerInboundNatRules.</param>
        /// <param name="privateIPAllocationMethod">Defines how a private IP
        /// address is assigned. Possible values are: 'Static' and 'Dynamic'.
        /// Possible values include: 'Static', 'Dynamic'</param>
        /// <param name="privateIPAddressVersion">Available from Api-Version
        /// 2016-03-30 onwards, it represents whether the specific
        /// ipconfiguration is IPv4 or IPv6. Default is taken as IPv4.
        /// Possible values are: 'IPv4' and 'IPv6'. Possible values include:
        /// 'IPv4', 'IPv6'</param>
        /// <param name="primary">Gets whether this is a primary customer
        /// address on the network interface.</param>
        /// <param name="name">The name of the resource that is unique within a
        /// resource group. This name can be used to access the
        /// resource.</param>
        /// <param name="etag">A unique read-only string that changes whenever
        /// the resource is updated.</param>
        public NetworkInterfaceIPConfiguration(string id = default(string), IList<ApplicationGatewayBackendAddressPool> applicationGatewayBackendAddressPools = default(IList<ApplicationGatewayBackendAddressPool>), IList<BackendAddressPool> loadBalancerBackendAddressPools = default(IList<BackendAddressPool>), IList<InboundNatRule> loadBalancerInboundNatRules = default(IList<InboundNatRule>), string privateIPAddress = default(string), string privateIPAllocationMethod = default(string), string privateIPAddressVersion = default(string), Subnet subnet = default(Subnet), bool? primary = default(bool?), PublicIPAddress publicIPAddress = default(PublicIPAddress), string provisioningState = default(string), string name = default(string), string etag = default(string))
            : base(id)
        {
            ApplicationGatewayBackendAddressPools = applicationGatewayBackendAddressPools;
            LoadBalancerBackendAddressPools = loadBalancerBackendAddressPools;
            LoadBalancerInboundNatRules = loadBalancerInboundNatRules;
            PrivateIPAddress = privateIPAddress;
            PrivateIPAllocationMethod = privateIPAllocationMethod;
            PrivateIPAddressVersion = privateIPAddressVersion;
            Subnet = subnet;
            Primary = primary;
            PublicIPAddress = publicIPAddress;
            ProvisioningState = provisioningState;
            Name = name;
            Etag = etag;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the reference of ApplicationGatewayBackendAddressPool
        /// resource.
        /// </summary>
        [JsonProperty(PropertyName = "properties.applicationGatewayBackendAddressPools")]
        public IList<ApplicationGatewayBackendAddressPool> ApplicationGatewayBackendAddressPools { get; set; }

        /// <summary>
        /// Gets or sets the reference of LoadBalancerBackendAddressPool
        /// resource.
        /// </summary>
        [JsonProperty(PropertyName = "properties.loadBalancerBackendAddressPools")]
        public IList<BackendAddressPool> LoadBalancerBackendAddressPools { get; set; }

        /// <summary>
        /// Gets or sets a list of references of LoadBalancerInboundNatRules.
        /// </summary>
        [JsonProperty(PropertyName = "properties.loadBalancerInboundNatRules")]
        public IList<InboundNatRule> LoadBalancerInboundNatRules { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.privateIPAddress")]
        public string PrivateIPAddress { get; set; }

        /// <summary>
        /// Gets or sets defines how a private IP address is assigned. Possible
        /// values are: 'Static' and 'Dynamic'. Possible values include:
        /// 'Static', 'Dynamic'
        /// </summary>
        [JsonProperty(PropertyName = "properties.privateIPAllocationMethod")]
        public string PrivateIPAllocationMethod { get; set; }

        /// <summary>
        /// Gets or sets available from Api-Version 2016-03-30 onwards, it
        /// represents whether the specific ipconfiguration is IPv4 or IPv6.
        /// Default is taken as IPv4.  Possible values are: 'IPv4' and 'IPv6'.
        /// Possible values include: 'IPv4', 'IPv6'
        /// </summary>
        [JsonProperty(PropertyName = "properties.privateIPAddressVersion")]
        public string PrivateIPAddressVersion { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.subnet")]
        public Subnet Subnet { get; set; }

        /// <summary>
        /// Gets whether this is a primary customer address on the network
        /// interface.
        /// </summary>
        [JsonProperty(PropertyName = "properties.primary")]
        public bool? Primary { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.publicIPAddress")]
        public PublicIPAddress PublicIPAddress { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "properties.provisioningState")]
        public string ProvisioningState { get; set; }

        /// <summary>
        /// Gets or sets the name of the resource that is unique within a
        /// resource group. This name can be used to access the resource.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets a unique read-only string that changes whenever the
        /// resource is updated.
        /// </summary>
        [JsonProperty(PropertyName = "etag")]
        public string Etag { get; set; }

    }
}
