// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Rest;

namespace AutoRest.Generator.CSharp.Tests.Utilities
{
    public class TestTracingInterceptor : IServiceClientTracingInterceptor
    {
        private readonly ILogger _logger;

        public TestTracingInterceptor()
        {
            var factory = new LoggerFactory();
            _logger = factory.CreateLogger<TestTracingInterceptor>();
            factory.AddConsole();
        }

        public void Configuration(string source, string name, string value)
        {
            // Ignore
        }

        public void EnterMethod(string invocationId, object instance, string method, IDictionary<string, object> parameters)
        {
            _logger.LogInformation("enter {0}({1})", method,
                string.Join(",", parameters.Select(kv => string.Format("{0}='{1}'", kv.Key, kv.Value))));
        }

        public void ExitMethod(string invocationId, object returnValue)
        {
            // Ignore
        }

        public void Information(string message)
        {
            _logger.LogInformation(message);
        }

        public void ReceiveResponse(string invocationId, HttpResponseMessage response)
        {
            _logger.LogInformation("   response: {0}", response.AsFormattedString());
        }

        public void SendRequest(string invocationId, HttpRequestMessage request)
        {
            _logger.LogInformation("    request: {0}", request.AsFormattedString());
        }

        public void TraceError(string invocationId, Exception exception)
        {
            _logger.LogInformation("    error: {1},{0}", invocationId, exception);
        }
    }
}
