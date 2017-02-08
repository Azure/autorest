// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.AcceptanceTestsAzureCompositeModelClient.Models
{
    using Fixtures.AcceptanceTestsAzureCompositeModelClient;
    using Newtonsoft.Json;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public partial class DictionaryWrapperInner
    {
        /// <summary>
        /// Initializes a new instance of the DictionaryWrapperInner class.
        /// </summary>
        public DictionaryWrapperInner() { }

        /// <summary>
        /// Initializes a new instance of the DictionaryWrapperInner class.
        /// </summary>
        public DictionaryWrapperInner(IDictionary<string, string> defaultProgram = default(IDictionary<string, string>))
        {
            DefaultProgram = defaultProgram;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "defaultProgram")]
        public IDictionary<string, string> DefaultProgram { get; set; }

    }
}

