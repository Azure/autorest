// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.TemplateModels
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