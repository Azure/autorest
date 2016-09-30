// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


using System;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Extensions
{
    /// <summary>
    /// Extensions methods for client model.
    /// </summary>
    public static class ClientModelHelpers
    {
        /// <summary>
        /// Returns true if property has x-ms-client-flatten extension and its value is true.
        /// </summary>
        /// <param name="propertyToCheck">Property to check.</param>
        /// <returns></returns>
        public static bool ShouldBeFlattened(this IVariable propertyToCheck)
        {
            if (propertyToCheck == null)
            {
                throw new ArgumentNullException("propertyToCheck");
            }

            return propertyToCheck.Extensions.ContainsKey(SwaggerExtensions.FlattenExtension) &&
                (bool)propertyToCheck.Extensions[SwaggerExtensions.FlattenExtension];
        }

        /// <summary>
        /// Returns true if property was flattened via x-ms-client-flatten extension.
        /// </summary>
        /// <param name="propertyToCheck">Property to check.</param>
        /// <returns></returns>
        public static bool WasFlattened(this IVariable propertyToCheck)
        {
            if (propertyToCheck == null)
            {
                throw new ArgumentNullException("propertyToCheck");
            }

            return propertyToCheck.Extensions.ContainsKey(SwaggerExtensions.FlattenOriginalTypeName);
        }

        /// <summary>
        /// Gets or sets the parameter client (explicitly defined code generation) name.
        /// </summary>
        public static string GetClientName(this IVariable parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            return parameter.Extensions.GetValue<string>("x-ms-client-name").Else(parameter.Name);
        }
    }
}