// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Ruby.TemplateModels
{
    /// <summary>
    /// The model for property template.
    /// </summary>
    public class PropertyTemplateModel : Property
    {
        /// <summary>
        /// Initializes a new instance of the class PropertyTemplateModel.
        /// </summary>
        /// <param name="source">The source property object.</param>
        public PropertyTemplateModel(Property source)
        {
            this.LoadFrom(source);
        }
    }
}