// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Extensions.Azure;
using AutoRest.Python.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Azure.Model
{
    public class PropertyPya : PropertyPy
    {
        public PropertyPya()
        {
            DefaultValue.OnGet += value =>
            {
                // single quotes for these...
                if (SerializedName.EqualsIgnoreCase(AzureExtensions.ApiVersion) || SerializedName.EqualsIgnoreCase(AzureExtensions.AcceptLanguage))
                {
                    return value.Replace("\"", "'");
                }
                return value;
            };
        }
    }
}