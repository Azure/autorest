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
    /// Defines values for AccountType.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum AccountType
    {
        [EnumMember(Value = "Standard_LRS")]
        StandardLRS,
        [EnumMember(Value = "Standard_ZRS")]
        StandardZRS,
        [EnumMember(Value = "Standard_GRS")]
        StandardGRS,
        [EnumMember(Value = "Standard_RAGRS")]
        StandardRAGRS,
        [EnumMember(Value = "Premium_LRS")]
        PremiumLRS
    }
}
