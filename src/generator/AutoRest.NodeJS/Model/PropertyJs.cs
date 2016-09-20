// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Extensions;

namespace AutoRest.NodeJS.Model
{
    public class PropertyJs : Core.Model.Property
    {
        protected PropertyJs()
        {
            // properties with dots by surrounding them with single quotes to represent 
            // them as a single property and not as one being part of another. For example: 'odata.nextLink' 
            Name.OnGet += name => name.Contains(".") && !name.StartsWith("'") ? $"'{name}'" : name;

            SerializedName.OnGet += serializedName => this.WasFlattened() ? serializedName : serializedName?.Replace(".", "\\\\.");
        }
    }
}