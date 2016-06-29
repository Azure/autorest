// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Globalization;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Microsoft.Rest.Modeler.Swagger.Validators;

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

        [Rule(typeof(AnonymousTypes))]
        public Schema Schema { get; set; }

        public Dictionary<string, Header> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorResponse = priorVersion as OperationResponse;

            if (priorResponse == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.AddingRequiredHeader1, header.Key));
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
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovingRequiredHeader1, header.Key));
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