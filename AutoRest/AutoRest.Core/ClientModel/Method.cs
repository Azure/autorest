// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.Utilities;
using System;

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines a method for the client model.
    /// </summary>
    public class Method : ICloneable
    {
        /// <summary>
        /// Initializes a new instance of the Method class.
        /// </summary>
        public Method()
        {
            Extensions = new Dictionary<string, object>();
            Parameters = new List<Parameter>();
            RequestHeaders = new Dictionary<string, string>();
            Responses = new Dictionary<HttpStatusCode, IType>();
        }

        /// <summary>
        /// Gets or sets the method name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the group name.
        /// </summary>
        public string Group { get; set; }

        /// <summary>
        /// Gets or sets the HTTP url.
        /// </summary>
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
        public List<Parameter> Parameters { get; set; }

        /// <summary>
        /// Gets or sets request headers.
        /// </summary>
        public Dictionary<string, string> RequestHeaders { get; set; }

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
        /// </summary>
        public Dictionary<HttpStatusCode, IType> Responses { get; set; }

        /// <summary>
        /// Gets or sets the default response.
        /// </summary>
        public IType DefaultResponse { get; set; }

        /// <summary>
        /// Gets or sets the method return type.
        /// </summary>
        public IType ReturnType { get; set; }

        /// <summary>
        /// Gets or sets the documentation.
        /// </summary>
        public string Documentation { get; set; }

        /// <summary>
        /// Gets vendor extensions dictionary.
        /// </summary>
        public Dictionary<string, object> Extensions { get; private set; }

        /// <summary>
        /// Returns a string representation of the Method object.
        /// </summary>
        /// <returns>
        /// A string representation of the Method object.
        /// </returns>
        public override string ToString()
        {
            return string.Format("{0} {1} ({2})", ReturnType, Name,
                string.Join(",", Parameters.Select(p => p.ToString())));
        }

        /// <summary>
        /// Performs a deep clone of a method.
        /// </summary>
        /// <returns></returns>
        public object Clone()
        {
            Method newMethod = (Method)this.MemberwiseClone();
            newMethod.Extensions = new Dictionary<string, object>();
            newMethod.Parameters = new List<Parameter>();
            newMethod.RequestHeaders = new Dictionary<string, string>();
            newMethod.Responses = new Dictionary<HttpStatusCode, IType>();
            this.Extensions.ForEach(e => newMethod.Extensions[e.Key] = e.Value);
            this.Parameters.ForEach(p => newMethod.Parameters.Add(p));
            this.RequestHeaders.ForEach(r => newMethod.RequestHeaders[r.Key] = r.Value);
            this.Responses.ForEach(r => newMethod.Responses[r.Key] = r.Value);
            return newMethod;
        }
    }
}