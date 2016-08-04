// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class ExtensionsTemplateModel : ServiceClient
    {
        public ExtensionsTemplateModel(ServiceClient serviceClient, string operationName, SyncMethodsGenerationMode syncWrappers)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            ExtensionName = operationName ?? this.Name;
            this.Methods.Where(m => m.Group == operationName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient, syncWrappers)));
        }


        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public string ExtensionName { get; set; }

        public virtual IEnumerable<string> Usings
        {
            get
            {
                if (this.ModelTypes.Any() || this.HeaderTypes.Any())
                {
                    yield return this.ModelsName;
                }
            }
        }
    }
}