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
        protected bool Disposed = false;
        
        /// <summary>
        /// Reference to the outermost HTTP handler (which is the end of HTTP
        /// pipeline).
        /// </summary>
        protected HttpMessageHandler OuterHandler = null;

        /// <summary>
        /// Reference to the innermost HTTP handler (which is the start of HTTP
        /// pipeline).
        /// </summary>
        protected HttpMessageHandler InnerHandler = null;
       
        /// <summary>
        /// Initializes a new instance of the ServiceClient class.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            "Microsoft.Reliability", 
            "CA2000:Dispose objects before losing scope",
            Justification="The created objects should be disposed on caller's side")]
        protected ServiceClient()
            : this(CreateRootHandler())
        {
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            "Microsoft.Reliability", 
            "CA2000:Dispose objects before losing scope", 
            Justification="The created objects should be disposed on caller's side")]
        protected ServiceClient(params DelegatingHandler[] handlers) 
            : this(CreateRootHandler(), handlers)
        {
        }

        protected ServiceClient(HttpClientHandler rootHandler, params DelegatingHandler[] handlers)
        {
            InitializeHttpClient(rootHandler, handlers);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            "Microsoft.Reliability", 
            "CA2000:Dispose objects before losing scope", 
            Justification="The created objects should be disposed on caller's side")]
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
        /// Get the HTTP pipelines for the given service client.
        /// </summary>
        /// <returns>The client's HTTP pipeline.</returns>
        public virtual IEnumerable<HttpMessageHandler> HttpMessageHandlers
        {
            get
            {
                var handler = OuterHandler;

                while (handler != null)
                {
                    yield return handler;

                    DelegatingHandler delegating = handler as DelegatingHandler;
                    handler = delegating != null ? delegating.InnerHandler : null;
                }
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

            RetryDelegatingHandler delegatingHandler = this.HttpMessageHandlers.OfType<RetryDelegatingHandler>().FirstOrDefault();
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
        /// Dispose the ServiceClient.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!Disposed)
            {
                Disposed = true;

                // Dispose the client
                HttpClient.Dispose();
                HttpClient = null;
                OuterHandler = null;
                InnerHandler = null;
            }
        }           
        
        /// <summary>
        /// Initializes HttpClient using HttpClientHandler.
        /// </summary>
        /// <param name="httpMessageHandler">Base HttpClientHandler.</param>
        /// <param name="handlers">List of handlers from top to bottom (outer handler is the first in the list)</param>
        [System.Diagnostics.CodeAnalysis.SuppressMessage(
            "Microsoft.Reliability", 
            "CA2000:Dispose objects before losing scope", 
            Justification="We let HttpClient instance dispose")]
        protected void InitializeHttpClient(HttpClientHandler httpMessageHandler, params DelegatingHandler[] handlers)
        {
            InnerHandler = httpMessageHandler;
            DelegatingHandler currentHandler = new RetryDelegatingHandler();
            currentHandler.InnerHandler = InnerHandler;

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
            OuterHandler = currentHandler;
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
                .First(c => c.StartsWith("Version=", StringComparison.OrdinalIgnoreCase))
                .Substring("Version=".Length);
            return version;
        }
    }
}
