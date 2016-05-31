// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp
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
                    yield return "Models";
                }
            }
        }
    }
}