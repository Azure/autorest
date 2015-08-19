// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// The model for the Azure method parameter template.
    /// </summary>
    public class AzureParameterTemplateModel : ParameterTemplateModel
    {
        /// <summary>
        /// Initializes a new instance of the AzureParameterTemplateModel class.
        /// </summary>
        /// <param name="source">The source.</param>
        public AzureParameterTemplateModel(Parameter source) : base(source)
        {
        }
    }
}