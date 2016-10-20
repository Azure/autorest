// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;
using System;
using System.Collections.Generic;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single response from an API Operation.
    /// </summary>
    [Serializable]
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
        public Schema Schema { get; set; }

        public Dictionary<string, Header> Headers { get; set; }

        public Dictionary<string, object> Examples { get; set; }

        /// <summary>
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public override IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            var priorResponse = previous as OperationResponse;

            if (priorResponse == null)
            {
                throw new ArgumentNullException("previous");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            context.Direction = DataDirection.Response;

            base.Compare(context, previous);

            var headers = Headers != null ? Headers : new Dictionary<string, Header>();
            var priorHeaders = priorResponse.Headers != null ? priorResponse.Headers : new Dictionary<string, Header>();

            foreach (var header in headers)
            {
                context.Push(header.Key);

                Header oldHeader = null;
                if (!priorHeaders.TryGetValue(header.Key, out oldHeader))
                {
                    context.LogInfo(ComparisonMessages.AddingHeader, header.Key);
                }
                else
                {
                    header.Value.Compare(context, oldHeader);
                }

                context.Pop();
            }

            foreach (var header in priorHeaders)
            {
                context.Push(header.Key);

                Header newHeader = null;
                if (!headers.TryGetValue(header.Key, out newHeader))
                {
                    context.LogBreakingChange(ComparisonMessages.RemovingHeader, header.Key);
                }

                context.Pop();
            }

            if (Schema != null && priorResponse.Schema != null)
            {
                Schema.Compare(context, priorResponse.Schema);
            }

            context.Direction = DataDirection.None;

            return context.Messages;
        }
    }
}