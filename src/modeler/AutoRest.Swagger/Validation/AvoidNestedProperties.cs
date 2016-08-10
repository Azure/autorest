// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class AvoidNestedProperties : TypedRule<Schema>
    {
        private const string ClientFlattenExtensionName = "x-ms-client-flatten";
        /// <summary>
        /// An <paramref name="entity" /> fails this rule if it 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(Schema schema, RuleContext context)
            => context.Key != "properties" || IsClientFlattenUsed(schema.Extensions);

        private static bool IsClientFlattenUsed(Dictionary<string, object> extensions)
            => extensions.ContainsKey(ClientFlattenExtensionName)
            && extensions[ClientFlattenExtensionName] is bool
            && (bool)extensions[ClientFlattenExtensionName] == true;

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Consider using x-ms-client-flatten to provide a better end user experience";

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
    }
}