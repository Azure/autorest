// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

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
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
        }

        /// <summary>
        /// Returns the using statements for the Operations.
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                if (Methods.Any(m =>
                    m.Parameters.Any(p =>
                        p.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
                        p.Type is CompositeType &&
                        p.Location == ParameterLocation.Query)))
                {
                    yield return "System.Linq.Expressions";
                    yield return "Microsoft.Rest.Azure.OData";
                }
                yield return "Microsoft.Rest.Azure";

                if (this.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension)))
                {
                    yield return "Models";
                }
            }
        }
    }
}