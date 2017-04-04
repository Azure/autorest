// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Core.Logging;

namespace AutoRest.Swagger.Validation
{
    public class RequiredReadOnlyPropertiesValidation : TypedRule<Schema>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2062";

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
        public override string MessageTemplate => Resources.RequiredReadOnlyPropertiesValidation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Validates if a property is marked as required, it should not be read only.
        /// </summary>
        /// <param name="definition"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Schema definition, RuleContext context)
        {
            if(definition.Properties != null)
            {
                foreach (KeyValuePair<string, Schema> property in definition.Properties)
                {
                    if (property.Value.ReadOnly && definition.Required?.Contains(property.Key) == true)
                    {
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, property.Key);
                    }
                }
            }            
        }
    }
}
