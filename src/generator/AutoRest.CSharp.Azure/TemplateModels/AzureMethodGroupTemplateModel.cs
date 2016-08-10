// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.TemplateModels;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.TemplateModels
{
    public class AzureMethodGroupTemplateModel : MethodGroupTemplateModel
    {
        public AzureMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
            : base(serviceClient, methodGroupName)
        {
            MethodGroupType = MethodGroupName + "Operations";
            // Clear base initialized MethodTemplateModels and re-populate with
            // AzureMethodTemplateModel
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == methodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient, SyncMethodsGenerationMode.None)));
        }

        /// <summary>
        /// Returns the using statements for the Operations.
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest.Azure";

                if (this.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)) || this.HeaderTypes.Any())
                {
                    yield return this.ModelsName;
                }
            }
        }
    }
}