// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single response from an API Operation.
    /// </summary>
    [Serializable]
    public class Response
    {
        public string Description { get; set; }

        public Schema Schema { get; set; }

        public Dictionary<string, Schema> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }
    }
}