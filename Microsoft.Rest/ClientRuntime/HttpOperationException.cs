// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Net.Http;
using System.Runtime.CompilerServices;
using System.Xml.Linq;
using Microsoft.Rest.Properties;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest
{
    /// <summary>
    /// Exception thrown for an invalid response with custom error information.
    /// </summary>
    public class HttpOperationException<T> : HttpOperationException where T : IDeserializationModel, new()
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
        /// <param name="innerException">Optional inner exception.</param>
        /// <returns>A HttpOperationException representing the failure.</returns>
        public static new HttpOperationException<T> Create(
            HttpRequestMessage request,
            string requestContent,
            HttpResponseMessage response,
            string responseContent,
            Exception innerException = null)
        {
            T errorModel = default(T);
            if (responseContent != null)
            {
                TryParseErrorModel(responseContent, out errorModel);

            }

            return Create(request, requestContent, response, responseContent, 
                errorModel, innerException);
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
       public static HttpOperationException<T> Create(HttpRequestMessage request,
            string requestContent,
            HttpResponseMessage response,
            string responseContent,
            T errorModel,
            Exception innerException = null)
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

        /// <summary>
        /// Try to parse an error response body as Json or Xml.
        /// </summary>
        /// <param name="responseContent">The response body.</param>
        /// <param name="errorModel">The model, if parsing is successful.</param>
        /// <returns>True if the model was successfully parsed, otherwise false</returns>
        public static bool TryParseErrorModel(string responseContent, out T errorModel)
        {
            return TryParseJsonModel(responseContent, out errorModel)
                || TryParseXmlModel(responseContent, out errorModel);
        }

        /// <summary>
        /// Try to parse an error response body as Json.
        /// </summary>
        /// <param name="responseContent">The response body.</param>
        /// <param name="errorModel">The model, if parsing was successful.</param>
        /// <returns>True if the content was successfully parsed, otherwise false.</returns>
        public static bool TryParseJsonModel(string responseContent, out T errorModel)
        {
            try
            {
                var jsonToken = JToken.Parse(responseContent);
                errorModel = new T();
                errorModel.DeserializeJson(jsonToken);
                return true;
            }
            catch(Exception)
            {
            }

           errorModel = default(T);
           return false;
        }

        /// <summary>
        /// Try to parse an error response body as Xml.
        /// </summary>
        /// <param name="responseContent">The response body.</param>
        /// <param name="errorModel">The model, if parsing was successful.</param>
        /// <returns>True if the content was successfully parsed, otherwise false.</returns>
        public static bool TryParseXmlModel(string responseContent, out T errorModel)
        {
            try
            {
                var xmlDocument = System.Xml.Linq.XDocument.Parse(responseContent);
                errorModel = new T();
                errorModel.DeserializeXml(xmlDocument);
                return true;
            }
            catch(Exception)
            {
            }

            errorModel = default(T);
            return false;
        }


    }

    public class HttpOperationException : Exception
    {
        private class NullErrorModel : IDeserializationModel
        {

            public void DeserializeXml(XContainer inputObject)
            {
            }

            public void DeserializeJson(JToken inputObject)
            {
            }
        }
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

        /// <summary>
        /// Create a HttpOperationException from a failed response.
        /// </summary>
        /// <param name="request">The HTTP request.</param>
        /// <param name="requestContent">The HTTP request content.</param>
        /// <param name="response">The HTTP response.</param>
        /// <param name="responseContent">The HTTP response content.</param>
        /// <param name="innerException">Optional inner exception.</param>
        /// <returns>A HttpOperationException representing the failure.</returns>
        public static HttpOperationException Create(
            HttpRequestMessage request,
            string requestContent,
            HttpResponseMessage response,
            string responseContent,
            Exception innerException = null)
        {
            return HttpOperationException<NullErrorModel>.Create(request, requestContent, response, responseContent,
                innerException);
        }

        /// <summary>
        /// Create a HttpOperationException from a response string.
        /// </summary>
        /// <param name="responseContent">The HTTP response content.</param>
        /// <param name="innerException">Optional inner exception.</param>
        /// <returns>A HttpOperationException representing the failure.</returns>
        public static HttpOperationException Create(
            string responseContent,
            Exception innerException = null)
        {
            return HttpOperationException<NullErrorModel>.Create(null, null, null, responseContent, innerException);
        }

    }
}