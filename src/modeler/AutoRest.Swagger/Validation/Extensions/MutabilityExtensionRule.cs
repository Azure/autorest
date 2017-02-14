// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;

namespace AutoRest.Swagger.Validation
{
    public abstract class MutabilityExtensionRule : ExtensionRule
    {
        protected override string ExtensionName => "x-ms-mutability";

        public abstract override string MessageTemplate { get; }

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public abstract override Category Severity { get; }
    }
}
