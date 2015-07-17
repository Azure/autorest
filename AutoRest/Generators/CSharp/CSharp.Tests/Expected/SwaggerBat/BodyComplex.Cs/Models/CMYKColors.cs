namespace Fixtures.SwaggerBatBodyComplex.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for CMYKColors.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum CMYKColors
    {
        [EnumMember(Value = "cyan")]
        Cyan,
        [EnumMember(Value = "Magenta")]
        Magenta,
        [EnumMember(Value = "YELLOW")]
        YELLOW,
        [EnumMember(Value = "blacK")]
        BlacK
    }
}
