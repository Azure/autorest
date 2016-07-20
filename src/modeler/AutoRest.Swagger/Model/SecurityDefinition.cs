// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using System;
using System.Collections.Generic;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Security Scheme Object - https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#security-scheme-object-
    /// </summary>
    [Serializable]
    public class SecurityDefinition
    {
        private string _description;
        public SecuritySchemeType SecuritySchemeType { get; set; }

        public string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); }
        }

        public string Name { get; set; }

        public ApiKeyLocation In { get; set; }

        public OAuthFlow Flow { get; set; }

        public string AuthorizationUrl { get; set; }

        public string TokenUrl { get; set; }

        /// <summary>
        /// Lists the available scopes for an OAuth2 security scheme. 
        /// Key is scope serviceTypeName and the value is short description
        /// </summary>
        public Dictionary<string, string> Scopes { get; set; }
    }
}