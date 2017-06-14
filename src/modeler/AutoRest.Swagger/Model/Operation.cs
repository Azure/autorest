// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
using System;
using AutoRest.Swagger.Validation;
using System.Collections.Generic;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single API operation on a path.
    /// </summary>
    [Rule(typeof(OperationDescriptionOrSummaryRequired))]
    [Rule(typeof(SummaryAndDescriptionMustNotBeSame))]
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
        [Rule(typeof(OperationIdNounVerb))]
        [Rule(typeof(GetInOperationName))]
        [Rule(typeof(PutInOperationName))]
        [Rule(typeof(PatchInOperationName))]
        [Rule(typeof(DeleteInOperationName))]
        [Rule(typeof(OperationIdNounConflictingModelNames))]
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
        [CollectionRule(typeof(NonApplicationJsonType))]
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the operation can produce. 
        /// </summary>
        [CollectionRule(typeof(NonApplicationJsonType))]
        public IList<string> Produces { get; set; }

        /// <summary>
        /// A list of parameters that are applicable for this operation. 
        /// If a parameter is already defined at the Path Item, the 
        /// new definition will override it, but can never remove it.
        /// </summary>
        [CollectionRule(typeof(SubscriptionIdParameterInOperations))]
        [CollectionRule(typeof(EnumInsteadOfBoolean))]
        [CollectionRule(typeof(AnonymousBodyParameter))]
        public IList<SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// The list of possible responses as they are returned from executing this operation.
        /// </summary>
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// The transfer protocol for the operation. 
        /// </summary>
        [CollectionRule(typeof(HttpsSupportedScheme))]
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
            this.Responses.TryGetValue(name, out OperationResponse response);
            return response;
        }


        private static SwaggerParameter FindReferencedParameter(string reference, IDictionary<string, SwaggerParameter> parameters)
        {
            if (reference != null && reference.StartsWith("#", StringComparison.Ordinal))
            {
                var parts = reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("parameters"))
                {
                    if (parameters.TryGetValue(parts[2], out SwaggerParameter p))
                    {
                        return p;
                    }
                }
            }

            return null;
        }
    }
}