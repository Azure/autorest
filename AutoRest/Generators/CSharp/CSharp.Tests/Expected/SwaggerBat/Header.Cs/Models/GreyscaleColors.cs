namespace Fixtures.SwaggerBatHeader.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for GreyscaleColors.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum GreyscaleColors
    {
        [EnumMember(Value = "White")]
        White,
        [EnumMember(Value = "black")]
        Black,
        [EnumMember(Value = "GREY")]
        GREY
    }
}
