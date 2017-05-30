// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class LongRunningOperationsWithLongRunningExtension : TypedRule<Operation>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2065";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.LongRunningOperationsWithLongRunningExtensionError;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validates if the long running operation has long running extension enabled.
        /// </summary>
        /// <param name="operation"></param>
        /// <param name="context"></param>
        /// <returns>true if the long running operation has long running extension enabled. false otherwise.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Operation operation, RuleContext context)
        {
            if(operation.Responses?.Any(response => response.Key.Equals("201", StringComparison.OrdinalIgnoreCase)) == true && 
              operation.Extensions?.Any(extension => extension.Key.Equals("x-ms-long-running-operation", StringComparison.OrdinalIgnoreCase) && (bool)extension.Value) == false)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, new object[0]);
            }
        }
    }
}
