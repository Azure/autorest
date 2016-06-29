// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The model for parameter template.
    /// </summary>
    public class ParameterTemplateModel : Parameter
    {
        /// <summary>
        /// Initializes a new instance of the class ParameterTemplateModel.
        /// </summary>
        /// <param name="source">The source parameter object.</param>
        public ParameterTemplateModel(Parameter source)
        {
            this.LoadFrom(source);
        }
    }
}