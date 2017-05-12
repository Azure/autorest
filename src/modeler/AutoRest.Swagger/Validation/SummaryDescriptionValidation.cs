using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Core.Logging;

namespace AutoRest.Swagger.Validation
{
    public class SummaryDescriptionValidation: TypedRule<Operation>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2023";

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
        public override string MessageTemplate => Resources.SummaryDescriptionVaidationError;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Operation operation, RuleContext context)
        {
            if(operation.Description != null && operation.Summary != null && operation.Description.Trim().Equals(operation.Summary.Trim()))
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, new object[0]);
            }
        }
    }
}
