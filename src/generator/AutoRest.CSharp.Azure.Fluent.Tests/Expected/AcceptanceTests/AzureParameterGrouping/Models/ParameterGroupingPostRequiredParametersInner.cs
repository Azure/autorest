// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
// 
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Fixtures.Azure.AcceptanceTestsAzureParameterGrouping.Models
{
    using System.Linq;

    /// <summary>
    /// Additional parameters for the parameterGrouping_postRequired operation.
    /// </summary>
    public partial class ParameterGroupingPostRequiredParametersInner
    {
        /// <summary>
        /// Initializes a new instance of the
        /// ParameterGroupingPostRequiredParametersInner class.
        /// </summary>
        public ParameterGroupingPostRequiredParametersInner() { }

        /// <summary>
        /// Initializes a new instance of the
        /// ParameterGroupingPostRequiredParametersInner class.
        /// </summary>
        /// <param name="path">Path parameter</param>
        /// <param name="query">Query parameter with default</param>
        public ParameterGroupingPostRequiredParametersInner(int body, string path, string customHeader = default(string), int? query = default(int?))
        {
            Body = body;
            CustomHeader = customHeader;
            Query = query;
            Path = path;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public int Body { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public string CustomHeader { get; set; }

        /// <summary>
        /// Gets or sets query parameter with default
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public int? Query { get; set; }

        /// <summary>
        /// Gets or sets path parameter
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "")]
        public string Path { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Path == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Path");
            }
        }
    }
}
