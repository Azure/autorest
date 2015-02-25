// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;

namespace Microsoft.Rest
{
    /// <summary>
    /// Exception thrown for an invalid response with custom error information.
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage(
        "Microsoft.Design", 
        "CA1032:ImplementStandardExceptionConstructors"), 
    System.Diagnostics.CodeAnalysis.SuppressMessage(
        "Microsoft.Usage", 
        "CA2237:MarkISerializableTypesWithSerializable", 
        Justification = "All properties of this class get serialized manually")]
    public class HttpOperationException<T> : HttpRequestException
    {
        /// <summary>
        /// Gets information about the associated HTTP request.
        /// </summary>
        public HttpRequestMessage Request { get; protected set; }

        /// <summary>
        /// Gets information about the associated HTTP response.
        /// </summary>
        public HttpResponseMessage Response { get; protected set; }

        /// <summary>
        /// Gets or sets the response object.
        /// </summary>
        public T Body { get; set; }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        public HttpOperationException() 
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public HttpOperationException(string message)
            : this(message, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">Inner exception.</param>
        public HttpOperationException(string message, Exception innerException)
            : base(message, innerException)
        {
        }       
    }
}