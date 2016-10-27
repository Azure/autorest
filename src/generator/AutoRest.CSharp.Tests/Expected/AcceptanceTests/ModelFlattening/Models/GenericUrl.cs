// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsModelFlattening.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		

    /// <summary>
    /// The Generic URL.
    /// </summary>
    public partial class GenericUrl
    {
        /// <summary>
        /// Initializes a new instance of the GenericUrl class.
        /// </summary>
        public GenericUrl() { }

        /// <summary>
        /// Initializes a new instance of the GenericUrl class.
        /// </summary>
        /// <param name="genericValue">Generic URL value.</param>
        public GenericUrl(string genericValue = default(string))
        {
            GenericValue = genericValue;
        }

        /// <summary>
        /// Gets or sets generic URL value.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "generic_value")]
        public string GenericValue { get; set; }

    }
}
