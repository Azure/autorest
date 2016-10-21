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

    public partial class BooleanWrapper
    {
        /// <summary>
        /// Initializes a new instance of the BooleanWrapper class.
        /// </summary>
        public BooleanWrapper() { }

        /// <summary>
        /// Initializes a new instance of the BooleanWrapper class.
        /// </summary>
        public BooleanWrapper(bool? fieldTrue = default(bool?), bool? fieldFalse = default(bool?))
        {
            FieldTrue = fieldTrue;
            FieldFalse = fieldFalse;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "field_true")]
        public bool? FieldTrue { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "field_false")]
        public bool? FieldFalse { get; set; }

    }
}
