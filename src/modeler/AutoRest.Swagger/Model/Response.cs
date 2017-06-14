// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Swagger.Validation;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single response from an API Operation.
    /// </summary>
    public class OperationResponse : SwaggerBase
    {
        private string _description;

        [Rule(typeof(AvoidMsdnReferences))]
        public string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); }
        }

        [Rule(typeof(AvoidAnonymousTypes))]
        [Rule(typeof(EnumInsteadOfBoolean))]
        [Rule(typeof(RequiredReadOnlyProperties))]
        public Schema Schema { get; set; }

        public Dictionary<string, Header> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }
    }
}