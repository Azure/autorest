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

        [JsonProperty(PropertyName = "$ref")]
        public string Reference { get; set; }

        public Schema Schema { get; set; }

        public Dictionary<string, Header> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }

        /// <summary>
        /// Validate the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(ValidationContext context)
        {
            var errorCount = context.ValidationErrors.Count;

            context.Direction = DataDirection.Response;

            base.Validate(context);

            if (Headers != null)
            {
                foreach (var header in Headers.Values)
                {
                    header.Validate(context);
                }
            }

            if (Reference != null)
            {
                ValidateReference(context);
            }

            if (Schema != null)
            {
                Schema.Validate(context);
            }

            context.Direction = DataDirection.None;

            return context.ValidationErrors.Count == errorCount;
        }

        private void ValidateReference(ValidationContext context)
        {
            if (Reference.StartsWith("#"))
            {
                var parts = Reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("responses"))
                {
                    OperationResponse response = null;
                    if (!context.Responses.TryGetValue(parts[2], out response))
                    {
                        context.LogError(string.Format("'{0}' was not found in the responses section of the document.", parts[2]));
                    }
                }
            }
            // TOOD: figure out how to validate non-local references, they should already be available.
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorResponse = priorVersion as OperationResponse;

            if (priorResponse == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            var errorCount = context.ValidationErrors.Count;

            context.Direction = DataDirection.Response;

            base.Compare(priorVersion, context);

            if (Schema != null && priorResponse.Schema != null)
            {
                Schema.Compare(priorResponse.Schema, context);
            }

            var headers = Headers != null ? Headers : new Dictionary<string, Header>();
            var priorHeaders = priorResponse.Headers != null ? priorResponse.Headers : new Dictionary<string, Header>();

            foreach (var header in headers)
            {
                Header oldHeader = null;
                if (!priorHeaders.TryGetValue(header.Key, out oldHeader) && header.Value.IsRequired)
                {
                    context.LogBreakingChange(string.Format("Adding a required header '{0}'.", header.Key));
                }
                else
                {
                    header.Value.Compare(oldHeader, context);
                }
            }

            foreach (var header in priorHeaders)
            {
                Header newHeader = null;
                if (!headers.TryGetValue(header.Key, out newHeader) && header.Value.IsRequired)
                {
                    context.LogBreakingChange(string.Format("Removing a required header '{0}'.", header.Key));
                }
                else
                {
                    header.Value.Compare(newHeader, context);
                }
            }

            context.Direction = DataDirection.None;

            return context.ValidationErrors.Count == errorCount;
        }
    }
}