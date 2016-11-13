// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Python.Model;

namespace AutoRest.Python.Azure.Model
{
    public class MethodGroupPya : MethodGroupPy
    {
        public MethodGroupPya() 
        {
        }
        public MethodGroupPya(string name) : base(name)
        {
        }

        public override bool HasAnyModel => CodeModel.ModelTypes.Any(model => 
            !model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) || 
            !(bool) model.Extensions[AzureExtensions.ExternalExtension]);

        public bool HasAnyCloudErrors => MethodTemplateModels.Any(item => item.DefaultResponse.Body == null || item.DefaultResponse.Body.Name == "CloudError");

        public bool HasAnyLongRunOperation => MethodTemplateModels.Any(m => m.Extensions.ContainsKey(AzureExtensions.LongRunningExtension));
    }
}