// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsPaging.Models
{
    using System.Linq;

    /// <summary>
    /// Additional parameters for a set of operations, such as:
    /// Paging_getMultiplePagesFragmentWithGroupingNextLink,
    /// Paging_nextFragmentWithGrouping.
    /// </summary>
    public partial class CustomParameterGroupInner
    {
        /// <summary>
        /// Initializes a new instance of the CustomParameterGroupInner class.
        /// </summary>
        public CustomParameterGroupInner() { }

        /// <summary>
        /// Initializes a new instance of the CustomParameterGroupInner class.
        /// </summary>
        /// <param name="apiVersion">Sets the api version to use.</param>
        /// <param name="tenant">Sets the tenant to use.</param>
        public CustomParameterGroupInner(string apiVersion, string tenant)
        {
            ApiVersion = apiVersion;
            Tenant = tenant;
        }

        /// <summary>
        /// Gets or sets sets the api version to use.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public string ApiVersion { get; set; }

        /// <summary>
        /// Gets or sets sets the tenant to use.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public string Tenant { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (ApiVersion == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "ApiVersion");
            }
            if (Tenant == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Tenant");
            }
        }
    }
}
