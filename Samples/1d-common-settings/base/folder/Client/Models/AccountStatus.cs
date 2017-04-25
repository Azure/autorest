// This is my custom license header. I am a nice person so please don't steal
// my code.
//
// Cheers.

namespace AwesomeNamespace.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for AccountStatus.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum AccountStatus
    {
        [EnumMember(Value = "Available")]
        Available,
        [EnumMember(Value = "Unavailable")]
        Unavailable
    }
}
