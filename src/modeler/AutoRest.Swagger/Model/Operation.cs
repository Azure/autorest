// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
using System;
using System.Linq;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;
using System.Collections.Generic;
using AutoRest.Core.Utilities;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single API operation on a path.
    /// </summary>
    [Rule(typeof(OperationDescriptionRequired))]
    public class Operation : SwaggerBase
    {
        private string _description;
        private string _summary;

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
        [Rule(typeof(OneUnderscoreInOperationId))]
        [Rule(typeof(OperationIdNounInVerb))]
        public string OperationId { get; set; }

        public string Summary
        {
            get { return _summary; }
            set { _summary = value.StripControlCharacters(); }
        }

        [Rule(typeof(AvoidMsdnReferences))]
        public string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Additional external documentation for this operation.
        /// </summary>
        public ExternalDoc ExternalDocs { get; set; }

        /// <summary>
        /// A list of MIME types the operation can consume.
        /// </summary>
        [CollectionRule(typeof(NonAppJsonTypeWarning))]
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the operation can produce. 
        /// </summary>
        [CollectionRule(typeof(NonAppJsonTypeWarning))]
        public IList<string> Produces { get; set; }

        /// <summary>
        /// A list of parameters that are applicable for this operation. 
        /// If a parameter is already defined at the Path Item, the 
        /// new definition will override it, but can never remove it.
        /// </summary>
        [CollectionRule(typeof(OperationParametersValidation))]
        [CollectionRule(typeof(AnonymousParameterTypes))]
        public IList<SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// The list of possible responses as they are returned from executing this operation.
        /// </summary>
        [Rule(typeof(ResponseRequired))]
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// The transfer protocol for the operation. 
        /// </summary>
        [CollectionRule(typeof(SupportedSchemesWarning))]
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

        /// <summary>
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public override IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            var priorOperation = previous as Operation;

            var currentRoot = (context.CurrentRoot as ServiceDefinition);
            var previousRoot = (context.PreviousRoot as ServiceDefinition);

            if (priorOperation == null)
            {
                throw new ArgumentException("previous");
            }

            base.Compare(context, previous);

            if (!OperationId.Equals(priorOperation.OperationId))
            {
                context.LogBreakingChange(ComparisonMessages.ModifiedOperationId);
            }

            CheckParameters(context, priorOperation);

            if (Responses != null && priorOperation.Responses != null)
            {
                foreach (var response in Responses)
                {
                    var oldResponse = priorOperation.FindResponse(response.Key, priorOperation.Responses);

                    context.Push(response.Key);

                    if (oldResponse == null)
                    {
                        context.LogBreakingChange(ComparisonMessages.AddingResponseCode, response.Key);
                    }
                    else
                    {
                        response.Value.Compare(context, oldResponse);
                    }

                    context.Pop();
                }

                foreach (var response in priorOperation.Responses)
                {
                    var newResponse = this.FindResponse(response.Key, this.Responses);

                    if (newResponse == null)
                    {
                        context.Push(response.Key);
                        context.LogBreakingChange(ComparisonMessages.RemovedResponseCode, response.Key);
                        context.Pop();
                    }
                }
            }

            return context.Messages;
        }

        private void CheckParameters(ComparisonContext context, Operation priorOperation)
        {
            // Check that no parameters were removed or reordered, and compare them if it's not the case.

            var currentRoot = (context.CurrentRoot as ServiceDefinition);
            var previousRoot = (context.PreviousRoot as ServiceDefinition);

            foreach (var oldParam in priorOperation.Parameters
                .Select(p => string.IsNullOrEmpty(p.Reference) ? p : FindReferencedParameter(p.Reference, previousRoot.Parameters)))
            {
                SwaggerParameter newParam = FindParameter(oldParam.Name, Parameters, currentRoot.Parameters);

                context.Push(oldParam.Name);

                if (newParam != null)
                {
                    newParam.Compare(context, oldParam);
                }
                else if (oldParam.IsRequired)
                {
                    context.LogBreakingChange(ComparisonMessages.RemovedRequiredParameter, oldParam.Name);
                }

                context.Pop();
            }

            // Check that no required parameters were added.

            foreach (var newParam in Parameters
                .Select(p => string.IsNullOrEmpty(p.Reference) ? p : FindReferencedParameter(p.Reference, currentRoot.Parameters))
                .Where(p => p != null && p.IsRequired))
            {
                if (newParam == null) continue;

                SwaggerParameter oldParam = FindParameter(newParam.Name, priorOperation.Parameters, previousRoot.Parameters);

                if (oldParam == null)
                {
                    context.Push(newParam.Name);
                    context.LogBreakingChange(ComparisonMessages.AddingRequiredParameter, newParam.Name);
                    context.Pop();
                }
            }
        }

        private SwaggerParameter FindParameter(string name, IEnumerable<SwaggerParameter> operationParameters, IDictionary<string, SwaggerParameter> clientParameters)
        {
            if (Parameters != null)
            {
                foreach (var param in operationParameters)
                {
                    if (name.Equals(param.Name))
                        return param;

                    var pRef = FindReferencedParameter(param.Reference, clientParameters);

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
            this.Responses.TryGetValue(name, out response);
            return response;
        }


        private static SwaggerParameter FindReferencedParameter(string reference, IDictionary<string, SwaggerParameter> parameters)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
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
    }
}