// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsBodyComplex.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		

    public partial class DatetimeWrapper
    {
        /// <summary>
        /// Initializes a new instance of the DatetimeWrapper class.
        /// </summary>
        public DatetimeWrapper() { }

        /// <summary>
        /// Initializes a new instance of the DatetimeWrapper class.
        /// </summary>
        public DatetimeWrapper(System.DateTime? field = default(System.DateTime?), System.DateTime? now = default(System.DateTime?))
        {
            Field = field;
            Now = now;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "field")]
        public System.DateTime? Field { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "now")]
        public System.DateTime? Now { get; set; }

    }
}
