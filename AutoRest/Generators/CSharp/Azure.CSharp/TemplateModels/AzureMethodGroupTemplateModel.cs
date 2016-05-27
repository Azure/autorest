// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp.Azure
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
                if (MethodTemplateModels.Any(m =>
                    m.ParameterTemplateModels.Any(p => ((AzureParameterTemplateModel)p).IsODataFilterExpression)))
                {
                    yield return "Microsoft.Rest.Azure.OData";
                }
                yield return "Microsoft.Rest.Azure";

                if (this.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)) || this.HeaderTypes.Any())
                {
                    yield return "Models";
                }
            }
        }
    }
}