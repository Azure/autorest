// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace AutoRest.Core.Utilities
{
    /// <summary>
    /// Used by Newtonsoft.Json.JsonSerializer to resolve a 
    /// Newtonsoft.Json.Serialization.JsonContract for a given type.
    /// </summary>
    public class CamelCaseContractResolver : DefaultContractResolver
    {
        /// <summary>
        /// Creates properties for the given JsonContract.
        /// </summary>
        /// <param name="type">The type to create properties for.</param>
        /// <param name="memberSerialization">The MemberSerialization mode for the type.</param>
        /// <returns></returns>
        protected override IList<JsonProperty> CreateProperties(Type type, MemberSerialization memberSerialization)
        {
            var properties = base.CreateProperties(type, memberSerialization);

            foreach (var property in properties)
            {
                property.PropertyName = char.ToLower(property.PropertyName[0], CultureInfo.InvariantCulture) +
                                        property.PropertyName.Substring(1);
            }

            return properties;
        }
    }
}