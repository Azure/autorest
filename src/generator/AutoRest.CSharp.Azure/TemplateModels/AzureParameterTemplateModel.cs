// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.CSharp.TemplateModels;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.TemplateModels
{
    public class AzureParameterTemplateModel : ParameterTemplateModel
    {
        public AzureParameterTemplateModel(Parameter source) : base(source)
        { }        

        /// <summary>
        /// Gets True if parameter can call .Validate method
        /// </summary>
        public override bool CanBeValidated
        {
            get
            {
                return !IsODataFilterExpression;
            }
        }

        /// <summary>
        /// Gets True if parameter is OData $filter, $top, $orderby, $expand, $skip expression
        /// </summary>
        public virtual bool IsODataFilterExpression
        {
            get
            {
                return base.Extensions.ContainsKey(AzureExtensions.ODataExtension);
            }
        }
    }
}