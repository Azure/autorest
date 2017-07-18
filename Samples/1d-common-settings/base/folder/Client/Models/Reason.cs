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
    /// Defines values for Reason.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum Reason
    {
        [EnumMember(Value = "AccountNameInvalid")]
        AccountNameInvalid,
        [EnumMember(Value = "AlreadyExists")]
        AlreadyExists
    }
    internal static class ReasonEnumExtension
    {
        internal static string ToSerializedValue(this Reason? value)  =>
            value == null ? null : ((Reason)value).ToSerializedValue();

        internal static string ToSerializedValue(this Reason value)
        {
            switch( value )
            {
                case Reason.AccountNameInvalid:
                    return "AccountNameInvalid";
                case Reason.AlreadyExists:
                    return "AlreadyExists";
            }
            return null;
        }

        internal static Reason? ParseReason(this string value)
        {
            switch( value )
            {
                case "AccountNameInvalid":
                    return Reason.AccountNameInvalid;
                case "AlreadyExists":
                    return Reason.AlreadyExists;
            }
            return null;
        }
    }
}
