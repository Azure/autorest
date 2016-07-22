// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// The object provides metadata about the API. 
    /// The metadata can be used by the clients if needed, and can be presented 
    /// in the Swagger-UI for convenience.
    /// </summary>
    [Serializable]
    public class Info : SpecObject
    {
        private string _description;
        public string Title { get; set; }

        public string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); ; }
        }

        public string TermsOfService { get; set; }

        public Contact Contact { get; set; }

        public License License { get; set; }

        public string Version { get; set; }

        [JsonProperty("x-ms-code-generation-settings")]
        public CodeGenerationSettings CodeGenerationSettings { get; set; }
    }
}