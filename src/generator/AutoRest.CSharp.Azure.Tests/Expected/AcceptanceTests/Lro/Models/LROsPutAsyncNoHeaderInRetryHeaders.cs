// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Azure;
    using AcceptanceTestsLro;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for putAsyncNoHeaderInRetry operation.
    /// </summary>
    public partial class LROsPutAsyncNoHeaderInRetryHeaders
    {
        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutAsyncNoHeaderInRetryHeaders class.
        /// </summary>
        public LROsPutAsyncNoHeaderInRetryHeaders() { }

        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutAsyncNoHeaderInRetryHeaders class.
        /// </summary>
        public LROsPutAsyncNoHeaderInRetryHeaders(string azureAsyncOperation = default(string))
        {
            AzureAsyncOperation = azureAsyncOperation;
        }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "Azure-AsyncOperation")]
        public string AzureAsyncOperation { get; set; }

    }
}
