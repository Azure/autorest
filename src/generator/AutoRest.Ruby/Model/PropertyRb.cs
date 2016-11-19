// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Extensions;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model for property template.
    /// </summary>
    public class PropertyRb : Core.Model.Property
    {
        protected PropertyRb()
        {
            // properties with dots in serialized name should escape . with back slash. For example: 'odata.nextLink'
            // 1. When properties are flattened use serialized name directly
            // 2. When properties are not flattened and have . in serialized name then escape . with back slash
            SerializedName.OnGet += serializedName => (this.WasFlattened() ? serializedName : serializedName?.Replace(".", "\\\\."));
        }
    }
}
