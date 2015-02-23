// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Net;
using System.Xml.Linq;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest
{
    /// <summary>
    /// Represents the base return type of all ServiceClient REST operations.
    /// </summary>
    public class HttpOperationResponse : IDeserializationModel
    {
        /// <summary>
        /// Exposes the HTTP status code.
        /// </summary>
        public HttpStatusCode StatusCode { get; set; }

        /// <summary>
        /// In an extending class, deserialize the instance with data from the given Xml Container
        /// </summary>
        /// <param name="inputObject">The Xml Container containing the serialized data for this instance</param>
        public virtual void DeserializeXml(XContainer inputObject)
        {
            
        }

        /// <summary>
        /// In an extending class, deserialize the instance with data from the given Json Token
        /// </summary>
        /// <param name="inputObject">The Json Token that contains serialized data for this instance</param>
        public virtual void DeserializeJson(JToken inputObject)
        {
            
        }
    }
}