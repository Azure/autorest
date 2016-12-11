// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class LroStatusCode : TypedRule<Operation>
    {
        /// <summary>
        /// An <paramref name="entity" /> fails this rule if it is marked as both readonly and required.
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(Operation entity) =>
            entity.Extensions.GetValueOrNull("x-ms-long-running-operation") as bool? != true ||
            entity.Responses.Any(response => response.Key == "200" || response.Key == "201" || response.Key == "204");

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Long running operations should have a terminal status code (any of 200, 201, 204).";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
    }
}
