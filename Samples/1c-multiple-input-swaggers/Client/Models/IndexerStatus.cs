// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Searchservice.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for IndexerStatus.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum IndexerStatus
    {
        [EnumMember(Value = "unknown")]
        Unknown,
        [EnumMember(Value = "error")]
        Error,
        [EnumMember(Value = "running")]
        Running
    }
    internal static class IndexerStatusEnumExtension
    {
        internal static string ToSerializedValue(this IndexerStatus? value)  =>
            value == null ? null : ((IndexerStatus)value).ToSerializedValue();

        internal static string ToSerializedValue(this IndexerStatus value)
        {
            switch( value )
            {
                case IndexerStatus.Unknown:
                    return "unknown";
                case IndexerStatus.Error:
                    return "error";
                case IndexerStatus.Running:
                    return "running";
            }
            return null;
        }

        internal static IndexerStatus? ParseIndexerStatus(this string value)
        {
            switch( value )
            {
                case "unknown":
                    return IndexerStatus.Unknown;
                case "error":
                    return IndexerStatus.Error;
                case "running":
                    return IndexerStatus.Running;
            }
            return null;
        }
    }
}
