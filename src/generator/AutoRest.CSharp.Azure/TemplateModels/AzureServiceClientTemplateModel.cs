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
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public AzureServiceClientTemplateModel(ServiceClient serviceClient, bool internalConstructors)
            : base(serviceClient, internalConstructors)
        {
            // TODO: Initialized in the base constructor. Why Clear it?
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient, SyncMethodsGenerationMode.None)));
        }

        /// <summary>
        /// Returns the OperationsTemplateModels for the ServiceClient.
        /// </summary>
        public override IEnumerable<MethodGroupTemplateModel> Operations
        {
            get
            {
                return MethodGroups.Select(mg => new AzureMethodGroupTemplateModel(this, mg));
            }
        }

        /// <summary>
        /// Returns the using statements for the ServiceClient.
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest";
                yield return "Microsoft.Rest.Azure";

                if (this.ModelTypes.Any( m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)))
                {
                    yield return this.ModelsName;
                }
            }
        }
    }
}