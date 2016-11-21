
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for AccountStatus.
    /// </summary>
    [JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum AccountStatus
    {
        [EnumMember(Value = "Available")]
        Available,
        [EnumMember(Value = "Unavailable")]
        Unavailable
    }
}

