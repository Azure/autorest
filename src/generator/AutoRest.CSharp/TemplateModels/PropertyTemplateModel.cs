// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class PropertyTemplateModel : Property
    {
        public PropertyTemplateModel(Property source)
        {
            this.LoadFrom(source);
        }
    }
}