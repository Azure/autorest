
namespace Petstore.Models
{

    /// <summary>
    /// Defines values for Reason.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum Reason
    {
        [System.Runtime.Serialization.EnumMember(Value = "AccountNameInvalid")]
        AccountNameInvalid,
        [System.Runtime.Serialization.EnumMember(Value = "AlreadyExists")]
        AlreadyExists
    }
}
