// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Microsoft.Rest.Modeler.Swagger.Validators;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single API operation on a path.
    /// </summary>
    public class Operation : SwaggerBase
    {
        public Operation()
        {
            Consumes = new List<string>();
            Produces = new List<string>();
        }

        /// <summary>
        /// A list of tags for API documentation control.
        /// </summary>
        public IList<string> Tags { get; set; }

        /// <summary>
        /// A friendly serviceTypeName for the operation. The id MUST be unique among all 
        /// operations described in the API. Tools and libraries MAY use the 
        /// operation id to uniquely identify an operation.
        /// </summary>
        [Rule(typeof(OperationIdSingleUnderscore))]
        [Rule(typeof(OperationIdNounInVerb))]
        public string OperationId { get; set; }

        public string Summary { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// Additional external documentation for this operation.
        /// </summary>
        public ExternalDoc ExternalDocs { get; set; }

        /// <summary>
        /// A list of MIME types the operation can consume.
        /// </summary>
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the operation can produce. 
        /// </summary>
        public IList<string> Produces { get; set; }

        /// <summary>
        /// A list of parameters that are applicable for this operation. 
        /// If a parameter is already defined at the Path Item, the 
        /// new definition will override it, but can never remove it.
        /// </summary>
        [CollectionRule(typeof(AnonymousParameterTypes))]
        public IList<SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// The list of possible responses as they are returned from executing this operation.
        /// </summary>
        [Rule(typeof(DefaultResponseRequired))]
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// The transfer protocol for the operation. 
        /// </summary>
        public IList<TransferProtocolScheme> Schemes { get; set; }

        public bool Deprecated { get; set; }

        /// <summary>
        /// A declaration of which security schemes are applied for this operation. 
        /// The list of values describes alternative security schemes that can be used 
        /// (that is, there is a logical OR between the security requirements). 
        /// This definition overrides any declared top-level security. To remove a 
        /// top-level security declaration, an empty array can be used.
        /// </summary>
        public IList<Dictionary<string, List<string>>> Security { get; set; }

        private SwaggerParameter FindParameter(string name, IDictionary<string, SwaggerParameter> parameters)
        {
            if (Parameters != null)
            {
                foreach (var param in Parameters)
                {
                    if (name.Equals(param.Name))
                        return param;

                    var pRef = FindReferencedParameter(param.Reference, parameters);

                    if (pRef != null && name.Equals(pRef.Name))
                    {
                        return pRef;
                    }
                }
            }
            return null;
        }

        private OperationResponse FindResponse(string name, IDictionary<string, OperationResponse> responses)
        {
            OperationResponse response = null;

            if (this.Responses.TryGetValue(name, out response))
            {
                if (!string.IsNullOrEmpty(response.Reference))
                {
                    response = FindReferencedResponse(response.Reference, responses);
                }
            }
           
            return response;
        }

        private static SwaggerParameter FindReferencedParameter(string reference, IDictionary<string, SwaggerParameter> parameters)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts =reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("parameters"))
                {
                    SwaggerParameter p = null;
                    if (parameters.TryGetValue(parts[2], out p))
                    {
                        return p;
                    }
                }
            }

            return null;
        }

        private static OperationResponse FindReferencedResponse(string reference, IDictionary<string, OperationResponse> responses)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("parameters"))
                {
                    OperationResponse r = null;
                    if (responses.TryGetValue(parts[2], out r))
                    {
                        return r;
                    }
                }
            }

            return null;
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorOperation = priorVersion as Operation;

            if (priorOperation == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Compare(priorVersion, context);


            if (string.IsNullOrEmpty(OperationId))
            {
                context.LogError(Resources.EmptyOperationId);
            }
            else
            {
                if (!OperationId.Equals(priorOperation.OperationId))
                {
                    context.LogBreakingChange(Resources.ModifiedOperationId);
                }
            }

            CheckParameters(context, priorOperation);

            if (Responses != null && priorOperation.Responses != null)
            {
                foreach (var response in Responses)
                {
                    var oldResponse = priorOperation.FindResponse(response.Key, context.PriorResponses);

                    if (oldResponse == null)
                    {
                        context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.AddingResponseCode1, response.Key));
                    }
                    else
                    {
                        context.PushTitle(context.Title + "/" + response.Key);
                        response.Value.Compare(oldResponse, context);
                        context.PopTitle();
                    }
                }

                foreach (var response in priorOperation.Responses)
                {
                    var newResponse = priorOperation.FindResponse(response.Key, context.Responses);

                    if (newResponse == null)
                    {
                        context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedResponseCode1, response.Key));
                    }
                }
            }

            return context.ValidationErrors.Count == errorCount;
        }

        private void CheckParameters(ValidationContext context, Operation priorOperation)
        {
            // Check that no parameters were removed or reordered, and compare them if it's not the case.

            foreach (var oldParam in priorOperation.Parameters
                .Select(p => string.IsNullOrEmpty(p.Reference) ? p : FindReferencedParameter(p.Reference, context.PriorParameters)))
            {
                SwaggerParameter newParam = FindParameter(oldParam.Name, context.Parameters);

                if (newParam != null)
                {
                    context.PushTitle(context.Title + "/" + oldParam.Name);
                    newParam.Compare(oldParam, context);
                    context.PopTitle();
                }
                else if (oldParam.IsRequired)
                {
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedRequiredParameter1, oldParam.Name));
                }
            }

            // Check that no required parameters were added.

            foreach (var newParam in Parameters
                .Select(p => string.IsNullOrEmpty(p.Reference) ? p : FindReferencedParameter(p.Reference, context.Parameters))
                .Where(p => p != null && p.IsRequired))
            {
                if (newParam == null) continue;

                SwaggerParameter oldParam = FindParameter(newParam.Name, context.PriorParameters);

                if (oldParam == null)
                {
                    context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.AddingRequiredParameter1, newParam.Name));
                }
            }
        }
    }
}