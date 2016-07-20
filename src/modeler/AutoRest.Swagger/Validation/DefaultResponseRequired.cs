// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;

namespace AutoRest.Swagger.Validation
{
    public class DefaultResponseRequired : TypedRule<IDictionary<string, OperationResponse>>
    {
        /// <summary>
        /// This rule fails if the <paramref name="entity"/> lacks responses or lacks a default response
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(IDictionary<string, OperationResponse> entity)
            => entity != null && entity.ContainsKey("default");

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.NoDefaultResponse;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
