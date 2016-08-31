// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using AutoRest.Core.Utilities;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines a method for the client model.
    /// </summary>
    public class Method : ICloneable
    {
        private string _description;
        private string _summary;

        /// <summary>
        /// Initializes a new instance of the Method class.
        /// </summary>
        public Method()
        {
            Extensions = new Dictionary<string, object>();
            Parameters = new List<Parameter>();
            RequestHeaders = new Dictionary<string, string>();
            Responses = new Dictionary<HttpStatusCode, Response>();
            InputParameterTransformation = new List<ParameterTransformation>();
            Scope = new ScopeProvider();
        }

        /// <summary>
        /// Gets or sets the method name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the name defined in the spec (OperationId).
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Gets or sets the group name.
        /// </summary>
        public string Group { get; set; }

        /// <summary>
        /// Gets or sets the HTTP url.
        /// </summary>
        [SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings",
            Justification= "Url might be used as a template, thus making it invalid url in certain scenarios.")]
        public string Url { get; set; }

        /// <summary>
        /// Indicates whether the HTTP url is absolute.
        /// </summary>
        public bool IsAbsoluteUrl { get; set; }

        /// <summary>
        /// Gets or sets the HTTPMethod.
        /// </summary>
        public HttpMethod HttpMethod { get; set; }

        /// <summary>
        /// Gets or sets the method parameters.
        /// </summary>
        public List<Parameter> Parameters { get; private set; }

        /// <summary>
        /// Gets or sets the logical parameter.
        /// </summary>
        public IEnumerable<Parameter> LogicalParameters
        {
            get
            {
                return Parameters.Where(gp => gp.Location != ParameterLocation.None)
                    .Union(InputParameterTransformation.Select(m => m.OutputParameter));
            }
        }

        /// <summary>
        /// Gets or sets the body parameter.
        /// </summary>
        public Parameter Body
        {
            get
            {
                return LogicalParameters.FirstOrDefault(p => p.Location == ParameterLocation.Body);
            }
        }

        /// <summary>
        /// Gets the list of input Parameter transformations
        /// </summary>
        public List<ParameterTransformation> InputParameterTransformation { get; private set; }

        /// <summary>
        /// Gets or sets request headers.
        /// </summary>
        public Dictionary<string, string> RequestHeaders { get; private set; }

        /// <summary>
        /// Gets or sets the request format.
        /// </summary>
        public SerializationFormat RequestSerializationFormat { get; set; }

        /// <summary>
        /// Gets or sets the response format.
        /// </summary>
        public SerializationFormat ResponseSerializationFormat { get; set; }

        /// <summary>
        /// Gets or sets response bodies by HttpStatusCode.
        /// and headers.
        /// </summary>
        public Dictionary<HttpStatusCode, Response> Responses { get; private set; }

        /// <summary>
        /// Gets or sets the default response.
        /// </summary>
        public Response DefaultResponse { get; set; }

        /// <summary>
        /// Gets or sets the method return type. The tuple contains a body
        /// and headers.
        /// </summary>
        public Response ReturnType { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        public string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Gets or sets the summary.
        /// </summary>
        public string Summary
        {
            get { return _summary; }
            set { _summary = value.StripControlCharacters(); }
        }

        /// <summary>
        /// Gets or sets a URL pointing to related external documentation.
        /// </summary>
        [SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings",
            Justification = "May not parse as a valid URI.")]
        public string ExternalDocsUrl { get; set; }

        /// <summary>
        /// Gets or sets the content type.
        /// </summary>
        public string RequestContentType { get; set; }

        /// <summary>
        /// Gets vendor extensions dictionary.
        /// </summary>
        public Dictionary<string, object> Extensions { get; private set; }

        /// <summary>
        /// Indicates if the method is deprecated.
        /// </summary>
        public bool Deprecated { get; set; }

        /// <summary>
        /// Gets 
        /// </summary>
        public IScopeProvider Scope { get; private set; }

        /// <summary>
        /// Returns a string representation of the Method object.
        /// </summary>
        /// <returns>
        /// A string representation of the Method object.
        /// </returns>
        public override string ToString()
        {
            return string.Format(CultureInfo.InvariantCulture, "{0} {1} ({2})", ReturnType, Name,
                string.Join(",", Parameters.Select(p => p.ToString())));
        }

        /// <summary>
        /// Performs a deep clone of a method.
        /// </summary>
        /// <returns></returns>
        public object Clone()
        {
            Method newMethod = new Method();
            newMethod.LoadFrom(this);
            newMethod.Extensions = new Dictionary<string, object>();
            newMethod.Parameters = new List<Parameter>();
            newMethod.RequestHeaders = new Dictionary<string, string>();
            newMethod.Responses = new Dictionary<HttpStatusCode, Response>();
            newMethod.InputParameterTransformation = new List<ParameterTransformation>();
            newMethod.Scope = new ScopeProvider();
            this.Extensions.ForEach(e => newMethod.Extensions[e.Key] = e.Value);
            this.Parameters.ForEach(p => newMethod.Parameters.Add((Parameter)p.Clone()));
            this.InputParameterTransformation.ForEach(m => newMethod.InputParameterTransformation.Add((ParameterTransformation)m.Clone()));
            this.RequestHeaders.ForEach(r => newMethod.RequestHeaders[r.Key] = r.Value);
            this.Responses.ForEach(r => newMethod.Responses[r.Key] = r.Value);
            return newMethod;
        }
    }
}
