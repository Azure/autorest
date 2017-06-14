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
    public class ResourceRequiredMustNotHaveName : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2002";

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
        public override string MessageTemplate => Resources.ResourceRequiredMustNotHaveNameValidationError;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Checks if the 'Resource' model has 'name' property is marked as required.
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns>false if the 'Resource' model has 'name' property is marked as required. 'true' otherwise.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            if (definitions.Any(definition =>
                definition.Key.Equals("Resource", StringComparison.OrdinalIgnoreCase) &&
                definition.Value.Required.Any(required => required?.Equals("name", StringComparison.OrdinalIgnoreCase) == true)))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("Resource")), this, new object[1]);
            }
        }
    }
}
