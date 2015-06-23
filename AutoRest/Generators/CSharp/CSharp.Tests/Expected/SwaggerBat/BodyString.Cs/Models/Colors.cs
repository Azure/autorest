namespace Fixtures.SwaggerBatBodyString.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for Colors
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum Colors
    {
        [EnumMember(Value = "red color")]
        Redcolor,
        [EnumMember(Value = "green-color")]
        GreenColor,
        [EnumMember(Value = "blue_color")]
        BlueColor
    }
}
