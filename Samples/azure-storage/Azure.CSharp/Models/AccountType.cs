
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for AccountType.
    /// </summary>
    [JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
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

