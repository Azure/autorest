// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swagger.Validation.Core;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Core.Logging;
using System;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class PathParametersMinLengthValidation : TypedRule<SwaggerParameter>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2064";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Path Parameter '{0}' must have a minimum length {1}";



        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;


        public override IEnumerable<ValidationMessage> GetValidationMessages(SwaggerParameter entity, RuleContext context)
        {
            if (entity.In == ParameterLocation.Path)
            {
                int? minLen = null;
                try
                {
                    minLen = Int32.Parse(entity.MinLength);
                }
                catch (Exception)
                {
                    // do nothing
                }
                if (minLen == null)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, entity.Name, "specified in integer format.");
                }
                if (minLen < 0)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, entity.Name, "greater than or equal to zero.");
                }
            }
        }
    }
}