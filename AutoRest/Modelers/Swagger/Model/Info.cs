// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Newtonsoft.Json;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// The object provides metadata about the API. 
    /// The metadata can be used by the clients if needed, and can be presented 
    /// in the Swagger-UI for convenience.
    /// </summary>
    [Serializable]
    public class Info : SpecObject
    {
        public string Title { get; set; }

        public string Description { get; set; }

        public string TermsOfService { get; set; }

        public Contact Contact { get; set; }

        public License License { get; set; }

        public string Version { get; set; }

        [JsonProperty("x-ms-code-generation-settings")]
        public CodeGenerationSettings CodeGenerationSettings { get; set; }
    }
}