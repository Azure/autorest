// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single response from an API Operation.
    /// </summary>
    [Serializable]
    public class OperationResponse : SwaggerBase
    {
        public string Description { get; set; }

        public Schema Schema { get; set; }

        public Dictionary<string, Header> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }

        /// <summary>
        /// Validate the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <param name="validationErrors">A list of error messages, filled in during processing.</param>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(List<LogEntry> validationErrors)
        {
            var errorCount = validationErrors.Count;
            base.Validate(validationErrors);
            if (Headers != null)
            {
                foreach (var header in Headers.Values)
                {
                    header.Validate(validationErrors);
                }
            }
            if (Schema != null)
                Schema.Validate(validationErrors);
            return validationErrors.Count == errorCount;
        }
    }
}