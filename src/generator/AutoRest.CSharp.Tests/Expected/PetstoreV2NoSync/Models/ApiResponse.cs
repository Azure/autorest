// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.PetstoreV2NoSync.Models
{
    using PetstoreV2NoSync;
    using Newtonsoft.Json;
    using System.Linq;
    using System.Xml;
    using System.Xml.Linq;

    public partial class ApiResponse
    {
        /// <summary>
        /// Initializes a new instance of the ApiResponse class.
        /// </summary>
        public ApiResponse() { }

        /// <summary>
        /// Initializes a new instance of the ApiResponse class.
        /// </summary>
        public ApiResponse(int? code = default(int?), string type = default(string), string message = default(string))
        {
            Code = code;
            Type = type;
            Message = message;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "code")]
        public int? Code { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "type")]
        public string Type { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }

        /// <summary>
        /// Serializes the object to an XML node
        /// </summary>
        internal XElement XmlSerialize(XElement result)
        {
            if( null != Code )
            {
                result.Add(new XElement("code", Code) );
            }
            if( null != Type )
            {
                result.Add(new XElement("type", Type) );
            }
            if( null != Message )
            {
                result.Add(new XElement("message", Message) );
            }
            return result;
        }
        /// <summary>
        /// Deserializes an XML node to an instance of ApiResponse
        /// </summary>
        internal static ApiResponse XmlDeserialize(string payload)
        {
            // deserialize to xml and use the overload to do the work
            return XmlDeserialize( XElement.Parse( payload ) );
        }
        internal static ApiResponse XmlDeserialize(XElement payload)
        {
            var result = new ApiResponse();
            var deserializeCode = XmlSerialization.ToDeserializer(e => (int?)e);
            int? resultCode;
            if (deserializeCode(payload, "code", out resultCode))
            {
                result.Code = resultCode;
            }
            var deserializeType = XmlSerialization.ToDeserializer(e => (string)e);
            string resultType;
            if (deserializeType(payload, "type", out resultType))
            {
                result.Type = resultType;
            }
            var deserializeMessage = XmlSerialization.ToDeserializer(e => (string)e);
            string resultMessage;
            if (deserializeMessage(payload, "message", out resultMessage))
            {
                result.Message = resultMessage;
            }
            return result;
        }
    }
}
