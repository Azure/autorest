// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Properties;
using System;
using System.Net.Http;

namespace Microsoft.Rest
{
    /// <summary>
    /// Exception thrown for an invalid response with custom error information.
    /// </summary>
    public class HttpOperationException<T> : HttpOperationException where T : new()
    {
        /// <summary>
        /// Custom error information parsed from error response 
        /// </summary>
        public T Model { get; set; }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        protected HttpOperationException(string message)
            : this(message, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">Inner exception.</param>
        protected HttpOperationException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        /// <summary>
        /// Create a HttpOperationException from a failed response.
        /// </summary>
        /// <param name="request">The HTTP request.</param>
        /// <param name="requestContent">The HTTP request content.</param>
        /// <param name="response">The HTTP response.</param>
        /// <param name="responseContent">The HTTP response content.</param>
        /// <param name="errorModel">The deserialized body of the error response.</param>
        /// <returns>A HttpOperationException representing the failure.</returns>
        public static HttpOperationException<T> Create(
            HttpRequestMessage request,
            string requestContent,
            HttpResponseMessage response,
            string responseContent,
            T errorModel)
        {
            return Create(request, requestContent, response, responseContent, errorModel, null);
        }

        /// <summary>
        /// Create a HttpOperationException from a failed response.
        /// </summary>
        /// <param name="request">The HTTP request.</param>
        /// <param name="requestContent">The HTTP request content.</param>
        /// <param name="response">The HTTP response.</param>
        /// <param name="responseContent">The HTTP response content.</param>
        /// <param name="errorModel">The deserialized body of the error response.</param>
        /// <param name="innerException">Optional inner exception.</param>
        /// <returns>A HttpOperationException representing the failure.</returns>
        public static HttpOperationException<T> Create(
            HttpRequestMessage request,
            string requestContent,
            HttpResponseMessage response,
            string responseContent,
            T errorModel,
            Exception innerException)
        {
            // Get the most descriptive message that we can
            string exceptionMessage;

            if (!string.IsNullOrEmpty(responseContent))
            {
                exceptionMessage = responseContent;
            }
            else if (response != null && response.ReasonPhrase != null)
            {
                exceptionMessage = response.ReasonPhrase;
            }
            else if (response != null)
            {
                exceptionMessage = string.Format(Resources.DefaultHttpOperationExceptionMessage,
                    response.StatusCode);
            }
            else
            {
                exceptionMessage = new InvalidOperationException().Message;
            }

            // Create the exception
            var exception = new HttpOperationException<T>(exceptionMessage, innerException);


            if (request != null)
            {
                exception.Request = HttpRequestErrorInfo.Create(request, requestContent);
            }

            if (response != null)
            {
                exception.Response = HttpResponseErrorInfo.Create(response, responseContent);
            }

            exception.Model = errorModel;
            return exception;
        }
    }

    public class HttpOperationException : Exception
    {
        /// <summary>
        /// Gets information about the associated HTTP request.
        /// </summary>
        public HttpRequestErrorInfo Request { get; protected set; }

        /// <summary>
        /// Gets information about the associated HTTP response.
        /// </summary>
        public HttpResponseErrorInfo Response { get; protected set; }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        protected HttpOperationException(string message)
            : this(message, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the HttpOperationException class.
        /// </summary>
        /// <param name="message">The exception message.</param>
        /// <param name="innerException">Inner exception.</param>
        protected HttpOperationException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}