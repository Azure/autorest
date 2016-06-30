// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Python.TemplateModels;

namespace AutoRest.Python.Azure.TemplateModels
{
    public class AzureModelInitTemplateModel : ModelInitTemplateModel
    {
        public AzureModelInitTemplateModel(ServiceClient serviceClient, IEnumerable<string> pageClass)
            : base(serviceClient)
        {
            PagedClasses = pageClass;
        }

        public IEnumerable<string> PagedClasses { get; private set; }
    }
}