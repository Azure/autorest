
namespace Petstore.Models
{

    /// <summary>
    /// Defines values for UsageUnit.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum UsageUnit
    {
        [System.Runtime.Serialization.EnumMember(Value = "Count")]
        Count,
        [System.Runtime.Serialization.EnumMember(Value = "Bytes")]
        Bytes,
        [System.Runtime.Serialization.EnumMember(Value = "Seconds")]
        Seconds,
        [System.Runtime.Serialization.EnumMember(Value = "Percent")]
        Percent,
        [System.Runtime.Serialization.EnumMember(Value = "CountsPerSecond")]
        CountsPerSecond,
        [System.Runtime.Serialization.EnumMember(Value = "BytesPerSecond")]
        BytesPerSecond
    }
}
