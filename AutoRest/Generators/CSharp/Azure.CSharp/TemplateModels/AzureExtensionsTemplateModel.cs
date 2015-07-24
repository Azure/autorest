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
    public class AzureExtensionsTemplateModel : ExtensionsTemplateModel
    {
        public AzureExtensionsTemplateModel(ServiceClient serviceClient, string operationName)
            : base(serviceClient, operationName)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == operationName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
            if (ExtensionName != Name)
            {
                ExtensionName = ExtensionName + "Operations";
            }
        }

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