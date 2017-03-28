
namespace Petstore.Models
{

    /// <summary>
    /// Defines values for AccountStatus.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum AccountStatus
    {
        [System.Runtime.Serialization.EnumMember(Value = "Available")]
        Available,
        [System.Runtime.Serialization.EnumMember(Value = "Unavailable")]
        Unavailable
    }
}
