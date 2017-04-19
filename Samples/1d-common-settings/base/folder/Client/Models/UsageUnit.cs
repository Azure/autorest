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
    /// Defines values for UsageUnit.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum UsageUnit
    {
        [EnumMember(Value = "Count")]
        Count,
        [EnumMember(Value = "Bytes")]
        Bytes,
        [EnumMember(Value = "Seconds")]
        Seconds,
        [EnumMember(Value = "Percent")]
        Percent,
        [EnumMember(Value = "CountsPerSecond")]
        CountsPerSecond,
        [EnumMember(Value = "BytesPerSecond")]
        BytesPerSecond
    }
}
