// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Model
{
    public class ParameterCsa : ParameterCs
    {
        public ParameterCsa()
        { }        

        /// <summary>
        /// Gets True if parameter can call .Validate method
        /// </summary>
        public override bool CanBeValidated => !IsODataFilterExpression;

        /// <summary>
        /// Gets True if parameter is OData $filter, $top, $orderby, $expand, $skip expression
        /// </summary>
        public virtual bool IsODataFilterExpression => base.Extensions.ContainsKey(AzureExtensions.ODataExtension);
    }
}