// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python;
using Microsoft.Rest.Generator.Utilities;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzureParameterTemplateModel : ParameterTemplateModel
    {
        public AzureParameterTemplateModel(Parameter source)
            : base(source)
        {
        }

        /// <summary>
        /// Gets parameter declaration
        /// </summary>
        public override string DeclarationExpression
        {
            get { return this.Type.Name; }
        }
    }
}