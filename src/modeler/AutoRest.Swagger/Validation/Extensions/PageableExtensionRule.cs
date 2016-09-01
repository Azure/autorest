// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    internal static class PageableExtensions
    {
        public static T GetValueOrNull<T>(this Dictionary<string, T> dictionary, string key)
        {
            T value = default(T);
            if (dictionary != null)
            {
                dictionary.TryGetValue(key, out value);
            }
            return value;
        }
    }

    public abstract class PageableExtensionRule : ExtensionRule
    {
        protected override string ExtensionName => "x-ms-pageable";

        protected static Schema Get200ResponseSchema(RuleContext context)
        {
            OperationResponse response = context?.GetFirstAncestor<Operation>()?.Responses?.GetValueOrNull("200");
            if (response == null)
            {
                return null;
            }
            var resolver = new SchemaResolver(context?.GetServiceDefinition());
            return resolver.Unwrap(response.Schema);
        }

        public abstract override string MessageTemplate { get; }

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public abstract override LogEntrySeverity Severity { get; }
    }
}
