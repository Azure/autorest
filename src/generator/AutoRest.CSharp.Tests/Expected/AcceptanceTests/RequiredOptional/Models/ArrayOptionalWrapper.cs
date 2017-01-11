// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsRequiredOptional.Models
{
    using AcceptanceTestsRequiredOptional;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class ArrayOptionalWrapper
    {
        /// <summary>
        /// Initializes a new instance of the ArrayOptionalWrapper class.
        /// </summary>
        public ArrayOptionalWrapper() { }

        /// <summary>
        /// Initializes a new instance of the ArrayOptionalWrapper class.
        /// </summary>
        public ArrayOptionalWrapper(IList<string> value = default(IList<string>))
        {
            Value = value;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "value")]
        public IList<string> Value { get; set; }

    }
}

