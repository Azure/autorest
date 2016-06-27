// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
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