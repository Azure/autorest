// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Fixtures.Azure.AcceptanceTestsLro.Models
{
    using Fixtures.Azure;
    using Fixtures.Azure.AcceptanceTestsLro;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines headers for putAsyncNoHeaderInRetry operation.
    /// </summary>
    public partial class LROsPutAsyncNoHeaderInRetryHeadersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutAsyncNoHeaderInRetryHeadersInner class.
        /// </summary>
        public LROsPutAsyncNoHeaderInRetryHeadersInner()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// LROsPutAsyncNoHeaderInRetryHeadersInner class.
        /// </summary>
        public LROsPutAsyncNoHeaderInRetryHeadersInner(string azureAsyncOperation = default(string))
        {
            AzureAsyncOperation = azureAsyncOperation;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "Azure-AsyncOperation")]
        public string AzureAsyncOperation { get; set; }

    }
}
