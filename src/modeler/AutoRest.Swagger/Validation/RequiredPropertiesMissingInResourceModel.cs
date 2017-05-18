// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates the structure of Resource Model that it must contain id,
    /// name, type, location, tags with everything as readonly except location 
    /// and tags.
    /// </summary>
    public class RequiredPropertiesMissingInResourceModel : TypedRule<Dictionary<string, Schema>>
    {

        private static readonly IEnumerable<string> ReadonlyProps = new List<string>() { "name", "id", "type" };
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2020";

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
        public override string MessageTemplate => Resources.ResourceModelIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Validates the structure of Resource Model
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <returns>true if the resource model is valid.false otherwise.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var resourceModels = context.ResourceModels;

            foreach (var resourceModel in resourceModels)
            {
                if(!ValidationUtilities.ContainsReadOnlyProperties(resourceModel, definitions, ReadonlyProps))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(resourceModel)), this, resourceModel);
                }
            }
        }
        
    }
}
