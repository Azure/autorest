// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHeader.Models
{
    using Newtonsoft.Json;		
    using Newtonsoft.Json.Converters;		
    using System.Runtime.Serialization;

    /// <summary>
    /// Defines values for GreyscaleColors.
    /// </summary>
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum GreyscaleColors
    {
        [System.Runtime.Serialization.EnumMember(Value = "White")]
        White,
        [System.Runtime.Serialization.EnumMember(Value = "black")]
        Black,
        [System.Runtime.Serialization.EnumMember(Value = "GREY")]
        GREY
    }
}
