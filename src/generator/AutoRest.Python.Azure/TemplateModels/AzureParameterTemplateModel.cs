// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Python.TemplateModels;

namespace AutoRest.Python.Azure.TemplateModels
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