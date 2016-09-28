// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Extensions;

namespace AutoRest.NodeJS.Model
{
    public class PropertyJs : Core.Model.Property
    {
        protected PropertyJs()
        {
            // properties with dots by surrounding them with single quotes to represent 
            // them as a single property and not as one being part of another. For example: 'odata.nextLink' 
            Name.OnGet += name =>
            {
                // completely replacing base behavior.

                object clientName = null;
                if (Extensions.TryGetValue("x-ms-client-name", out clientName))
                {
                    return CodeNamer.Instance.GetPropertyName(clientName as string);
                }

                // start with raw value, clean it and camelcase it.
                name = CodeNamer.Instance.CamelCase(CodeNamer.Instance.GetValidName( Name.FixedValue, '.', '_'));

                return name.Contains(".") && !name.StartsWith("'") ? $"'{name}'" : name;
            };

            SerializedName.OnGet += serializedName => (this.WasFlattened() ? serializedName : serializedName?.Replace(".", "\\\\."))?.Replace("\\\\\\\\","\\\\");
        }
    }
}