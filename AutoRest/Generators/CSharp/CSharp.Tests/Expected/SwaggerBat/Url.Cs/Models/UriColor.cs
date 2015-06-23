namespace Fixtures.SwaggerBatUrl.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for UriColor
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum UriColor
    {
        [EnumMember(Value = "red color")]
        Redcolor,
        [EnumMember(Value = "green color")]
        Greencolor,
        [EnumMember(Value = "blue color")]
        Bluecolor
    }
}
