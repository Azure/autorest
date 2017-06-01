// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Flags properties of boolean type as they are not recommended, unless it's the only option.
    /// </summary>
    public class EnumInsteadOfBoolean : TypedRule<SwaggerObject>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3018";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;


        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.BooleanPropertyNotRecommended;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validates whether properties of type boolean exist.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns>true if there are no propeties of type boolean, false otherwise.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(SwaggerObject entity, RuleContext context)
        {
            if (entity.Type?.Equals(DataType.Boolean) == true)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("name")), this, ((SwaggerParameter)entity).Name);
            }
            if (entity.GetType() == typeof(Schema) && ((Schema)entity).Properties != null)
            {
                foreach (KeyValuePair<string, Schema> property in ((Schema)entity).Properties)
                {
                    if (property.Value?.Type?.Equals(DataType.Boolean) == true)
                    {
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("properties").AppendProperty(property.Key)), this, property.Key);
                    }
                }
            }
            if (entity.GetType() == typeof(SwaggerParameter) && ((SwaggerParameter)entity).Schema?.Type?.Equals(DataType.Boolean) == true)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty("name")), this, ((SwaggerParameter)entity).Name);
            }
        }
    }
}