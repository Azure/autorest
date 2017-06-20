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
    internal static class AccountStatusEnumExtension
    {
        internal static string ToSerializedValue(this AccountStatus? value )  =>
            value == null ? null : (( AccountStatus )value).ToSerializedValue();

        internal static string ToSerializedValue(this AccountStatus value )
        {
            switch( value )
            {
                case AccountStatus.Available:
                    return "Available";
                case AccountStatus.Unavailable:
                    return "Unavailable";
            }
            return null;
        }

        internal static AccountStatus? ParseAccountStatus( this string value )
        {
            switch( value )
            {
                case "Available":
                    return AccountStatus.Available;
                case "Unavailable":
                    return AccountStatus.Unavailable;            }
            return null;
        }
    }
}
