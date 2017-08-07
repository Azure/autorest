// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.CSharp.Model
{
    public class PropertyCs : Property
    {
        [JsonIgnore]
        public override string ModelTypeName => ModelType.AsNullableType(this.IsNullable());

        [JsonIgnore]
        public string HeaderCollectionPrefix => Extensions.GetValue<string>(SwaggerExtensions.HeaderCollectionPrefix);
        [JsonIgnore]
        public bool IsHeaderCollection => !string.IsNullOrEmpty(HeaderCollectionPrefix);

        // not spec copmpliant
        [JsonProperty("useDefaultInConstructor")]
        public bool UseDefaultInConstructor { get; set; } = false;
    }
}