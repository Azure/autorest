// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    public class OperationsTemplateModel : ServiceClient
    {
        public OperationsTemplateModel(ServiceClient serviceClient, string operationName)
        {
            this.LoadFrom(serviceClient);
            HasModelTypes = serviceClient.HasModelTypes();
            MethodTemplateModels = new List<MethodTemplateModel>();
            Methods.Where(m => m.Group == operationName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));
            OperationName = operationName;
        }

        public bool HasModelTypes { get; private set; }
        public List<MethodTemplateModel> MethodTemplateModels { get; set; }

        public string OperationName { get; set; }

        public virtual IEnumerable<string> Usings
        {
            get
            {
                if (HasModelTypes)
                {
                    yield return Namespace + ".Models";
                }
            }
        }
    }
}