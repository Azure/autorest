// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsHeader.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		

    /// <summary>
    /// Defines headers for responseEnum operation.
    /// </summary>
    public partial class HeaderResponseEnumHeaders
    {
        /// <summary>
        /// Initializes a new instance of the HeaderResponseEnumHeaders class.
        /// </summary>
        public HeaderResponseEnumHeaders() { }

        /// <summary>
        /// Initializes a new instance of the HeaderResponseEnumHeaders class.
        /// </summary>
        /// <param name="value">response with header values "GREY" or
        /// null</param>
        public HeaderResponseEnumHeaders(GreyscaleColors? value = default(GreyscaleColors?))
        {
            Value = value;
        }

        /// <summary>
        /// Gets or sets response with header values "GREY" or null
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "value")]
        public GreyscaleColors? Value { get; set; }

    }
}
