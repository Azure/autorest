namespace Fixtures.Azure.SwaggerBatAzureSpecials
{
    using System;
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
    using Microsoft.Azure;
    using Models;

    /// <summary>
    /// Test Infrastructure for AutoRest
    /// </summary>
    public partial class AutoRestAzureSpecialParametersTestClient : ServiceClient<AutoRestAzureSpecialParametersTestClient>, IAutoRestAzureSpecialParametersTestClient, IAzureClient
    {
        /// <summary>
        /// The base URI of the service.
        /// </summary>
        public Uri BaseUri { get; set; }

        /// <summary>
        /// Gets or sets json serialization settings.
        /// </summary>
        public JsonSerializerSettings SerializationSettings { get; private set; }

        /// <summary>
        /// Gets or sets json deserialization settings.
        /// </summary>
        public JsonSerializerSettings DeserializationSettings { get; private set; }        

        /// <summary>
        /// The subscription id, which appears in the path, always modeled in
        /// credentials. The value is always '1234-5678-9012-3456'
        /// </summary>
        public string SubscriptionId { get; set; }

        /// <summary>
        /// The subscriptionId, which appears in the path, the value is always
        /// '1234-5678-9012-3456'
        /// </summary>
        public string SubscriptionId { get; set; }

        /// <summary>
        /// The api version, which appears in the query, the value is always
        /// '2015-07-01-preview'
        /// </summary>
        public string ApiVersion { get; set; }

        /// <summary>
        /// The api version, which appears in the query, the value is always
        /// '2.0'. Possible values for this parameter include: '2.0'
        /// </summary>
        public string ApiVersion { get; set; }

        /// <summary>
        /// An unencoded path parameter with value 'path1/path2/path3'.
        /// Possible values for this parameter include: 'path1/path2/path3'
        /// </summary>
        public string UnencodedPathParam { get; set; }

        /// <summary>
        /// An unencoded query parameter with value
        /// 'value1&amp;q2=value2&amp;q3=value3'. Possible values for this
        /// parameter include: 'value1&amp;q2=value2&amp;q3=value3'
        /// </summary>
        public string Q1 { get; set; }

        /// <summary>
        /// The Api Version.
        /// </summary>
        public string ApiVersion { get; private set; }

        /// <summary>
        /// Subscription credentials which uniquely identify Microsoft Azure
        /// subscription.
        /// </summary>
        public SubscriptionCloudCredentials Credentials { get; set; }

        /// <summary>
        /// The retry timeout for Long Running Operations.
        /// </summary>
        public int? LongRunningOperationRetryTimeout { get; set; }

        public virtual ISubscriptionInCredentialsOperations SubscriptionInCredentials { get; private set; }

        public virtual ISubscriptionInMethodOperations SubscriptionInMethod { get; private set; }

        public virtual IApiVersionDefaultOperations ApiVersionDefault { get; private set; }

        public virtual IApiVersionLocalOperations ApiVersionLocal { get; private set; }

        public virtual ISkipUrlEncodingOperations SkipUrlEncoding { get; private set; }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        public AutoRestAzureSpecialParametersTestClient() : base()
        {
            this.Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='handlers'>
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public AutoRestAzureSpecialParametersTestClient(params DelegatingHandler[] handlers) : base(handlers)
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
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public AutoRestAzureSpecialParametersTestClient(HttpClientHandler rootHandler, params DelegatingHandler[] handlers) : base(rootHandler, handlers)
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
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public AutoRestAzureSpecialParametersTestClient(Uri baseUri, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new ArgumentNullException("baseUri");
            }
            this.BaseUri = baseUri;
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='subscriptionId'>
        /// Required. The subscription id, which appears in the path, always modeled in credentials. The value is always '1234-5678-9012-3456'
        /// </param>
        /// <param name='subscriptionId'>
        /// Required. The subscriptionId, which appears in the path, the value is always '1234-5678-9012-3456'
        /// </param>
        /// <param name='apiVersion'>
        /// Required. The api version, which appears in the query, the value is always '2015-07-01-preview'
        /// </param>
        /// <param name='apiVersion'>
        /// Required. The api version, which appears in the query, the value is always '2.0'. Possible values for this parameter include: '2.0'
        /// </param>
        /// <param name='unencodedPathParam'>
        /// Required. An unencoded path parameter with value 'path1/path2/path3'. Possible values for this parameter include: 'path1/path2/path3'
        /// </param>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify Microsoft Azure subscription.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public AutoRestAzureSpecialParametersTestClient(string subscriptionId, string subscriptionId, string apiVersion, string apiVersion, string unencodedPathParam, SubscriptionCloudCredentials credentials, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (subscriptionId == null)
            {
                throw new ArgumentNullException("subscriptionId");
            }
            if (subscriptionId == null)
            {
                throw new ArgumentNullException("subscriptionId");
            }
            if (apiVersion == null)
            {
                throw new ArgumentNullException("apiVersion");
            }
            if (apiVersion == null)
            {
                throw new ArgumentNullException("apiVersion");
            }
            if (unencodedPathParam == null)
            {
                throw new ArgumentNullException("unencodedPathParam");
            }
            if (credentials == null)
            {
                throw new ArgumentNullException("credentials");
            }
            this.SubscriptionId = subscriptionId;
            this.SubscriptionId = subscriptionId;
            this.ApiVersion = apiVersion;
            this.ApiVersion = apiVersion;
            this.UnencodedPathParam = unencodedPathParam;
            this.Credentials = credentials;
        }

        /// <summary>
        /// Initializes a new instance of the AutoRestAzureSpecialParametersTestClient class.
        /// </summary>
        /// <param name='baseUri'>
        /// Optional. The base URI of the service.
        /// </param>
        /// <param name='subscriptionId'>
        /// Required. The subscription id, which appears in the path, always modeled in credentials. The value is always '1234-5678-9012-3456'
        /// </param>
        /// <param name='subscriptionId'>
        /// Required. The subscriptionId, which appears in the path, the value is always '1234-5678-9012-3456'
        /// </param>
        /// <param name='apiVersion'>
        /// Required. The api version, which appears in the query, the value is always '2015-07-01-preview'
        /// </param>
        /// <param name='apiVersion'>
        /// Required. The api version, which appears in the query, the value is always '2.0'. Possible values for this parameter include: '2.0'
        /// </param>
        /// <param name='unencodedPathParam'>
        /// Required. An unencoded path parameter with value 'path1/path2/path3'. Possible values for this parameter include: 'path1/path2/path3'
        /// </param>
        /// <param name='credentials'>
        /// Required. Subscription credentials which uniquely identify Microsoft Azure subscription.
        /// </param>
        /// <param name='handlers'>
        /// Optional. The set of delegating handlers to insert in the http
        /// client pipeline.
        /// </param>
        public AutoRestAzureSpecialParametersTestClient(Uri baseUri, string subscriptionId, string subscriptionId, string apiVersion, string apiVersion, string unencodedPathParam, SubscriptionCloudCredentials credentials, params DelegatingHandler[] handlers) : this(handlers)
        {
            if (baseUri == null)
            {
                throw new ArgumentNullException("baseUri");
            }
            if (subscriptionId == null)
            {
                throw new ArgumentNullException("subscriptionId");
            }
            if (subscriptionId == null)
            {
                throw new ArgumentNullException("subscriptionId");
            }
            if (apiVersion == null)
            {
                throw new ArgumentNullException("apiVersion");
            }
            if (apiVersion == null)
            {
                throw new ArgumentNullException("apiVersion");
            }
            if (unencodedPathParam == null)
            {
                throw new ArgumentNullException("unencodedPathParam");
            }
            if (credentials == null)
            {
                throw new ArgumentNullException("credentials");
            }
            this.BaseUri = baseUri;
            this.SubscriptionId = subscriptionId;
            this.SubscriptionId = subscriptionId;
            this.ApiVersion = apiVersion;
            this.ApiVersion = apiVersion;
            this.UnencodedPathParam = unencodedPathParam;
            this.Credentials = credentials;
        }

        /// <summary>
        /// Initializes client properties.
        /// </summary>
        private void Initialize()
        {
            this.SubscriptionInCredentials = new SubscriptionInCredentialsOperations(this);
            this.SubscriptionInMethod = new SubscriptionInMethodOperations(this);
            this.ApiVersionDefault = new ApiVersionDefaultOperations(this);
            this.ApiVersionLocal = new ApiVersionLocalOperations(this);
            this.SkipUrlEncoding = new SkipUrlEncodingOperations(this);
            this.BaseUri = new Uri("http://localhost");
            this.ApiVersion = "2015-07-01-preview";
            SerializationSettings = new JsonSerializerSettings
            {
                Formatting = Formatting.Indented,
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            SerializationSettings.Converters.Add(new ResourceJsonConverter()); 
            DeserializationSettings = new JsonSerializerSettings{
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                NullValueHandling = NullValueHandling.Ignore,
                ReferenceLoopHandling = ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver()
            };
            DeserializationSettings.Converters.Add(new ResourceJsonConverter()); 
            DeserializationSettings.Converters.Add(new CloudErrorJsonConverter()); 
        }    
    }
}
