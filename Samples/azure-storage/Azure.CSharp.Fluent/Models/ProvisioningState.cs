
namespace Petstore.Models
{

    /// <summary>
    /// Defines values for ProvisioningState.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum ProvisioningState
    {
        [System.Runtime.Serialization.EnumMember(Value = "Creating")]
        Creating,
        [System.Runtime.Serialization.EnumMember(Value = "ResolvingDNS")]
        ResolvingDNS,
        [System.Runtime.Serialization.EnumMember(Value = "Succeeded")]
        Succeeded
    }
}
