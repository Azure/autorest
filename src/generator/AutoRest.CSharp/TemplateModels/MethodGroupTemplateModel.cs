// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class MethodGroupTemplateModel : ServiceClient
    {
        public MethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            // MethodGroup name and type are always the same but can be 
            // changed in derived classes
            MethodGroupName = methodGroupName;
            MethodGroupType = methodGroupName;
            Methods.Where(m => m.Group == MethodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient, SyncMethodsGenerationMode.None)));
        }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public string MethodGroupName { get; set; }

        public string MethodGroupType { get; set; }

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