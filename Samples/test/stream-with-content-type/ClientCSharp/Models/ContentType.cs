// Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace StreamWithContentType.Models
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using System.Runtime;
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for ContentType.
    /// </summary>
    [JsonConverter(typeof(StringEnumConverter))]
    public enum ContentType
    {
        [EnumMember(Value = "image/gif")]
        ImageGif,
        [EnumMember(Value = "image/jpeg")]
        ImageJpeg,
        [EnumMember(Value = "image/png")]
        ImagePng,
        [EnumMember(Value = "image/bmp")]
        ImageBmp,
        [EnumMember(Value = "image/tiff")]
        ImageTiff
    }
    internal static class ContentTypeEnumExtension
    {
        internal static string ToSerializedValue(this ContentType? value)  =>
            value == null ? null : ((ContentType)value).ToSerializedValue();

        internal static string ToSerializedValue(this ContentType value)
        {
            switch( value )
            {
                case ContentType.ImageGif:
                    return "image/gif";
                case ContentType.ImageJpeg:
                    return "image/jpeg";
                case ContentType.ImagePng:
                    return "image/png";
                case ContentType.ImageBmp:
                    return "image/bmp";
                case ContentType.ImageTiff:
                    return "image/tiff";
            }
            return null;
        }

        internal static ContentType? ParseContentType(this string value)
        {
            switch( value )
            {
                case "image/gif":
                    return ContentType.ImageGif;
                case "image/jpeg":
                    return ContentType.ImageJpeg;
                case "image/png":
                    return ContentType.ImagePng;
                case "image/bmp":
                    return ContentType.ImageBmp;
                case "image/tiff":
                    return ContentType.ImageTiff;
            }
            return null;
        }
    }
}
