// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Compute.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for InstanceViewTypes.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum InstanceViewTypes
    {
        [EnumMember(Value = "instanceView")]
        InstanceView
    }
    internal static class InstanceViewTypesEnumExtension
    {
        internal static string ToSerializedValue(this InstanceViewTypes? value)
        {
            return value == null ? null : ((InstanceViewTypes)value).ToSerializedValue();
        }

        internal static string ToSerializedValue(this InstanceViewTypes value)
        {
            switch( value )
            {
                case InstanceViewTypes.InstanceView:
                    return "instanceView";
            }
            return null;
        }

        internal static InstanceViewTypes? ParseInstanceViewTypes(this string value)
        {
            switch( value )
            {
                case "instanceView":
                    return InstanceViewTypes.InstanceView;
            }
            return null;
        }
    }
}
