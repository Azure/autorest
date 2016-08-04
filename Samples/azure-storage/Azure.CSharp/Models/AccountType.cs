
namespace Petstore.Models
{

    /// <summary>
    /// Defines values for AccountType.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum AccountType
    {
        [System.Runtime.Serialization.EnumMember(Value = "Standard_LRS")]
        StandardLRS,
        [System.Runtime.Serialization.EnumMember(Value = "Standard_ZRS")]
        StandardZRS,
        [System.Runtime.Serialization.EnumMember(Value = "Standard_GRS")]
        StandardGRS,
        [System.Runtime.Serialization.EnumMember(Value = "Standard_RAGRS")]
        StandardRAGRS,
        [System.Runtime.Serialization.EnumMember(Value = "Premium_LRS")]
        PremiumLRS
    }
}
