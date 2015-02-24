// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.TransientFaultHandling;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;

namespace Microsoft.Rest
{
    /// <summary>
    /// ServiceClient is the abstraction for accessing REST operations and their payload data types..
    /// </summary>
    /// <typeparam name="T">Type of the ServiceClient.</typeparam>
    public abstract class ServiceClient<T> : IDisposable
        where T : ServiceClient<T>
    {
        /// <summary>
        /// Indicates whether the ServiceClient has been disposed. 
        /// </summary>
        internal bool _disposed = false;
        
        /// <summary>
        /// Reference to the outermost HTTP handler (which is the end of HTTP
        /// pipeline).
        /// </summary>
        internal HttpMessageHandler _outerHandler = null;

        /// <summary>
        /// Reference to the innermost HTTP handler (which is the start of HTTP
        /// pipeline).
        /// </summary>
        internal HttpMessageHandler _innerHandler = null;
       
        /// <summary>
        /// Initializes a new instance of the ServiceClient class.
        /// </summary>
        public ServiceClient(): this(CreateRootHandler())
        {
        }

        public ServiceClient(params DelegatingHandler[] handlers) : this(CreateRootHandler(), handlers)
        {
        }

        public ServiceClient(HttpClientHandler rootHandler, params DelegatingHandler[] handlers)
        {
            InitializeHttpClient(rootHandler, handlers);
        }

        protected static HttpClientHandler CreateRootHandler()
        {
            // Create our root handler
#if NET45
            return new WebRequestHandler();
#else
            return new HttpClientHandler
            {
                ClientCertificateOptions = ClientCertificateOption.Automatic
            };
#endif
        }

        /// <summary>
        /// Gets the HttpClient used for making HTTP requests.
        /// </summary>
        public HttpClient HttpClient { get; protected set; }
        
        /// <summary>
        /// Gets the UserAgent collection which can be augmented with custom
        /// user agent strings.
        /// </summary>
        public virtual HttpHeaderValueCollection<ProductInfoHeaderValue> UserAgent
        {
            get { return HttpClient.DefaultRequestHeaders.UserAgent; }
        }

        /// <summary>
        /// Dispose the ServiceClient.
        /// </summary>
        public virtual void Dispose()
        {
            // Only dispose once
            if (!_disposed)
            {
                _disposed = true;

                // Dispose the client
                HttpClient.Dispose();
                HttpClient = null;
                _outerHandler = null;
                _innerHandler = null;
            }
        }

        /// <summary>
        /// Get the HTTP pipeline for the given service client.
        /// </summary>
        /// <returns>The client's HTTP pipeline.</returns>
        public virtual IEnumerable<HttpMessageHandler> GetHttpPipeline()
        {
            var handler = _outerHandler;

            while (handler != null)
            {
                yield return handler;

                DelegatingHandler delegating = handler as DelegatingHandler;
                handler = delegating != null ? delegating.InnerHandler : null;
            }
        }

        /// <summary>
        /// Sets retry policy for the client.
        /// </summary>
        /// <param name="retryPolicy">Retry policy to set.</param>
        public virtual void SetRetryPolicy(RetryPolicy retryPolicy)
        {
            if (retryPolicy == null)
            {
                throw new ArgumentNullException("retryPolicy");
            }

            RetryDelegatingHandler delegatingHandler = this.GetHttpPipeline().OfType<RetryDelegatingHandler>().FirstOrDefault();
            if (delegatingHandler != null)
            {
                delegatingHandler.RetryPolicy = retryPolicy;
            }
            else
            {
                throw new InvalidOperationException(Properties.Resources.ExceptionRetryHandlerMissing);
            }
        }

        /// <summary>
        /// Initializes HttpClient using HttpClientHandler.
        /// </summary>
        /// <param name="httpMessageHandler">Base HttpClientHandler.</param>
        /// <param name="handlers">List of handlers from top to bottom (outer handler is the first in the list)</param>
        protected virtual void InitializeHttpClient(HttpClientHandler httpMessageHandler, params DelegatingHandler[] handlers)
        {
            _innerHandler = httpMessageHandler;
            DelegatingHandler currentHandler = new RetryDelegatingHandler();
            currentHandler.InnerHandler = _innerHandler;

            if (handlers != null)
            {
                for (int i = handlers.Length - 1; i >= 0; --i)
                {
                    DelegatingHandler handler = handlers[i];
                    handler.InnerHandler = currentHandler;
                    currentHandler = handler;
                }
            }

            var newClient = new HttpClient(currentHandler, true);
            _outerHandler = currentHandler;
            this.HttpClient = newClient;
            Type type = this.GetType();
            this.HttpClient.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue(type.FullName,
                GetAssemblyVersion()));
        }

        /// <summary>
        /// Get the assembly version of a service client.
        /// </summary>
        /// <returns>The assembly version of the client.</returns>
        private string GetAssemblyVersion()
        {
            Type type = this.GetType();
            string version =
                type
                .Assembly
                .FullName
                .Split(',')
                .Select(c => c.Trim())
                .Where(c => c.StartsWith("Version="))
                .FirstOrDefault()
                .Substring("Version=".Length);
            return version;
        }
    }
}
