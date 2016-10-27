// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureSpecials
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.Rest;
    using Microsoft.Rest.Serialization;
    using Newtonsoft.Json;
    using Microsoft.Rest;
    using Microsoft.Rest.Azure;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial class AutoRestAzureSpecialParametersTestClient : Microsoft.Rest.ServiceClient<AutoRestAzureSpecialParametersTestClient>, IAutoRestAzureSpecialParametersTestClient, IAzureClient
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        public System.Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        public Newtonsoft.Json.JsonSerializerSettings SerializationSettings { get; private set; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        public Newtonsoft.Json.JsonSerializerSettings DeserializationSettings { get; private set; }

        /// <summary>
        /// Credentials needed for the client to connect to Azure.
        /// </summary>
        public Microsoft.Rest.ServiceClientCredentials Credentials { get; private set; }

        /// <summary>
        /// The subscription id, which appears in the path, always modeled in
        /// credentials. The value is always '1234-5678-9012-3456'
        /// </summary>
        public string SubscriptionId { get; set; }

        /// <summary>
        /// The api version, which appears in the query, the value is always
        /// '2015-07-01-preview'
        /// </summary>
        public string ApiVersion { get; private set; }

        /// <summary>
        /// Gets or sets the preferred language for the response.
        /// </summary>
        public string AcceptLanguage { get; set; }

        /// <summary>
        /// Gets or sets the retry timeout in seconds for Long Running Operations.
        /// Default value is 30.
        /// </summary>
        public int? LongRunningOperationRetryTimeout { get; set; }

        /// <summary>
        /// When set to true a unique x-ms-client-request-id value is generated and
        /// included in each request. Default is true.
        /// </summary>
        public bool? GenerateClientRequestId { get; set; }

        /// <summary>
        /// Gets the IXMsClientRequestIdOperations.
        /// </summary>
        public virtual IXMsClientRequestIdOperations XMsClientRequestId { get; private set; }

        /// <summary>
        /// Gets the ISubscriptionInCredentialsOperations.
        /// </summary>
        public virtual ISubscriptionInCredentialsOperations SubscriptionInCredentials { get; private set; }

        /// <summary>
        /// Gets the ISubscriptionInMethodOperations.
        /// </summary>
        public virtual ISubscriptionInMethodOperations SubscriptionInMethod { get; private set; }

        /// <summary>
        /// Gets the IApiVersionDefaultOperations.
        /// </summary>
        public virtual IApiVersionDefaultOperations ApiVersionDefault { get; private set; }

        /// <summary>
        /// Gets the IApiVersionLocalOperations.
        /// </summary>
        public virtual IApiVersionLocalOperations ApiVersionLocal { get; private set; }

        /// <summary>
        /// Gets the ISkipUrlEncodingOperations.
        /// </summary>
        public virtual ISkipUrlEncodingOperations SkipUrlEncoding { get; private set; }

        /// <summary>
        /// Gets the IOdataOperations.
        /// </summary>
        public virtual IOdataOperations Odata { get; private set; }

        /// <summary>
        /// Gets the IHeaderOperations.
        /// </summary>
        public virtual IHeaderOperations Header { get; private set; }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        protected AutoRestAzureSpecialParametersTestClient(params System.Net.Http.DelegatingHandler[] handlers) : base(handlers)
        {
            this.Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        protected AutoRestAzureSpecialParametersTestClient(System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.DelegatingHandler[] handlers) : base(rootHandler, handlers)
        {
            this.Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        protected AutoRestAzureSpecialParametersTestClient(System.Uri baseUri, params System.Net.Http.DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            this.BaseUri = baseUri;
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        protected AutoRestAzureSpecialParametersTestClient(System.Uri baseUri, System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            this.BaseUri = baseUri;
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='credentials'>
        /// Required. Credentials needed for the client to connect to Azure.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public AutoRestAzureSpecialParametersTestClient(Microsoft.Rest.ServiceClientCredentials credentials, params System.Net.Http.DelegatingHandler[] handlers) : this(handlers)
        {
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            this.Credentials = credentials;
            if (this.Credentials != null)
            {
                this.Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='credentials'>
        /// Required. Credentials needed for the client to connect to Azure.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public AutoRestAzureSpecialParametersTestClient(Microsoft.Rest.ServiceClientCredentials credentials, System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            this.Credentials = credentials;
            if (this.Credentials != null)
            {
                this.Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='credentials'>
        /// Required. Credentials needed for the client to connect to Azure.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public AutoRestAzureSpecialParametersTestClient(System.Uri baseUri, Microsoft.Rest.ServiceClientCredentials credentials, params System.Net.Http.DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            this.BaseUri = baseUri;
            this.Credentials = credentials;
            if (this.Credentials != null)
            {
                this.Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='credentials'>
        /// Required. Credentials needed for the client to connect to Azure.
        /// </param>
        /// <param name='rootHandler'>
        /// Optional. The http client handler used to handle http transport.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The delegating handlers to add to the http client pipeline.
        /// </param>
        /// <exception cref="System.ArgumentNullException">
        /// Thrown when a required parameter is null
        /// </exception>
        public AutoRestAzureSpecialParametersTestClient(System.Uri baseUri, Microsoft.Rest.ServiceClientCredentials credentials, System.Net.Http.HttpClientHandler rootHandler, params System.Net.Http.DelegatingHandler[] handlers) : this(rootHandler, handlers)
        {
            if (baseUri == null)
            {
                throw new System.ArgumentNullException("baseUri");
            }
            if (credentials == null)
            {
                throw new System.ArgumentNullException("credentials");
            }
            this.BaseUri = baseUri;
            this.Credentials = credentials;
            if (this.Credentials != null)
            {
                this.Credentials.InitializeServiceClient(this);
            }
        }

        /// <summary>
        /// An optional partial-method to perform custom initialization.
        /// </summary>
        partial void CustomInitialize();
        /// <summary>
        /// Initializes client properties.
        /// </summary>
        private void Initialize()
        {
            this.XMsClientRequestId = new XMsClientRequestIdOperations(this);
            this.SubscriptionInCredentials = new SubscriptionInCredentialsOperations(this);
            this.SubscriptionInMethod = new SubscriptionInMethodOperations(this);
            this.ApiVersionDefault = new ApiVersionDefaultOperations(this);
            this.ApiVersionLocal = new ApiVersionLocalOperations(this);
            this.SkipUrlEncoding = new SkipUrlEncodingOperations(this);
            this.Odata = new OdataOperations(this);
            this.Header = new HeaderOperations(this);
            this.BaseUri = new System.Uri("http://localhost");
            this.ApiVersion = "2015-07-01-preview";
            this.AcceptLanguage = "en-US";
            this.LongRunningOperationRetryTimeout = 30;
            this.GenerateClientRequestId = true;
            SerializationSettings = new Newtonsoft.Json.JsonSerializerSettings
            {
                Formatting = Newtonsoft.Json.Formatting.Indented,
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new Microsoft.Rest.Serialization.ReadOnlyJsonContractResolver(),
                Converters = new System.Collections.Generic.List<Newtonsoft.Json.JsonConverter>
                    {
                        new Microsoft.Rest.Serialization.Iso8601TimeSpanConverter()
                    }
            };
            DeserializationSettings = new Newtonsoft.Json.JsonSerializerSettings
            {
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new Microsoft.Rest.Serialization.ReadOnlyJsonContractResolver(),
                Converters = new System.Collections.Generic.List<Newtonsoft.Json.JsonConverter>
                    {
                        new Microsoft.Rest.Serialization.Iso8601TimeSpanConverter()
                    }
            };
            CustomInitialize();
            DeserializationSettings.Converters.Add(new Microsoft.Rest.Azure.CloudErrorJsonConverter()); 
        }    
    }
}
