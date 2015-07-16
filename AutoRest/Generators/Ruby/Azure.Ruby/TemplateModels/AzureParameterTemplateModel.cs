// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
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