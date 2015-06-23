// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator.CSharp.Azure
{
    public class AzureParameterTemplateModel : ParameterTemplateModel
    {
        public AzureParameterTemplateModel(Parameter source) : base(source)
        {
        }

        /// <summary>
        /// Gets declaration for the parameter.
        /// </summary>
        public override string DeclarationExpression
        {
            get
            {
                if (SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
                    Location == ParameterLocation.Query &&
                    Type is CompositeType)
                {
                    return string.Format("Expression<Func<{0}, bool>>", Type.Name);
                }

                return base.DeclarationExpression;
            }
        }
    }
}