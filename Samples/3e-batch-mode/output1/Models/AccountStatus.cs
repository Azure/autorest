// Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Storage.Models
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
        internal static string ToSerializedValue(this AccountStatus? value)  =>
            value == null ? null : ((AccountStatus)value).ToSerializedValue();

        internal static string ToSerializedValue(this AccountStatus value)
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

        internal static AccountStatus? ParseAccountStatus(this string value)
        {
            switch( value )
            {
                case "Available":
                    return AccountStatus.Available;
                case "Unavailable":
                    return AccountStatus.Unavailable;
            }
            return null;
        }
    }
}
