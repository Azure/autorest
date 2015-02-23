// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json.Linq;
using System.Xml.Linq;

namespace Microsoft.Rest
{
    /// <summary>
    /// Instnace which can be deserialized from Json or Xml
    /// </summary>
    public interface IDeserializationModel
    {
        /// <summary>
        /// In an implementing class, deserialize the instance with data from the given Xml Container.
        /// </summary>
        /// <param name="inputObject">The Xml Container containing the serialized data.</param>
        void DeserializeXml(XContainer inputObject);

        /// <summary>
        /// In an impementing class, deserialize the instance with data from the given Json Token.
        /// </summary>
        /// <param name="inputObject">The Json Token that contains serialized data.</param>
        void DeserializeJson(JToken inputObject);
    }
}
